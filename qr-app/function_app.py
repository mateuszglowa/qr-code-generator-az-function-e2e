import io
import json
import logging
import os
import uuid
from datetime import UTC, datetime, timedelta
from urllib.parse import urlparse

import azure.functions as func
import qrcode
from azure.core.exceptions import ResourceExistsError
from azure.storage.blob import BlobSasPermissions, BlobServiceClient, ContentSettings, generate_blob_sas

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


def _read_url(req: func.HttpRequest) -> str | None:
    url = req.params.get("url")
    if url:
        return url.strip()

    try:
        req_body = req.get_json()
    except ValueError:
        return None

    body_url = req_body.get("url") if isinstance(req_body, dict) else None
    return body_url.strip() if isinstance(body_url, str) else None


def _is_valid_url(url: str) -> bool:
    parsed = urlparse(url)
    return parsed.scheme in {"http", "https"} and bool(parsed.netloc)


def _build_blob_client() -> tuple[BlobServiceClient, str, int]:
    connection_string = os.getenv("AzureWebJobsStorage")
    container_name = os.getenv("QR_CODE_CONTAINER_NAME")
    sas_expiry_minutes = int(os.getenv("QR_CODE_SAS_EXPIRY_MINUTES", "15"))

    if not connection_string:
        raise RuntimeError("Missing AzureWebJobsStorage application setting.")
    if not container_name:
        raise RuntimeError("Missing QR_CODE_CONTAINER_NAME application setting.")

    return BlobServiceClient.from_connection_string(connection_string), container_name, sas_expiry_minutes


def _generate_qr_png(url: str) -> bytes:
    qr = qrcode.QRCode(box_size=10, border=4)
    qr.add_data(url)
    qr.make(fit=True)

    image = qr.make_image(fill_color="black", back_color="white")
    output = io.BytesIO()
    image.save(output, format="PNG")
    return output.getvalue()


def _generate_blob_sas_url(
    blob_service_client: BlobServiceClient,
    container_name: str,
    blob_name: str,
    expiry_minutes: int,
) -> str:
    account_name = blob_service_client.account_name
    credential = blob_service_client.credential
    account_key = getattr(credential, "account_key", None)

    if not account_name or not account_key:
        raise RuntimeError("Storage account key is unavailable for SAS generation.")

    sas_token = generate_blob_sas(
        account_name=account_name,
        container_name=container_name,
        blob_name=blob_name,
        account_key=account_key,
        permission=BlobSasPermissions(read=True),
        expiry=datetime.now(UTC) + timedelta(minutes=expiry_minutes),
    )
    return f"{blob_service_client.primary_endpoint}/{container_name}/{blob_name}?{sas_token}"


@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("Python HTTP trigger function processed a QR code request.")

    url = _read_url(req)
    if not url:
        return func.HttpResponse(
            json.dumps({"error": "Missing required 'url' parameter."}),
            mimetype="application/json",
            status_code=400,
        )

    if not _is_valid_url(url):
        return func.HttpResponse(
            json.dumps({"error": "The 'url' parameter must be a valid http or https URL."}),
            mimetype="application/json",
            status_code=400,
        )

    try:
        blob_service_client, container_name, sas_expiry_minutes = _build_blob_client()
        container_client = blob_service_client.get_container_client(container_name)
        try:
            container_client.create_container()
        except ResourceExistsError:
            pass

        blob_name = f"qr-codes/{datetime.now(UTC).strftime('%Y%m%dT%H%M%SZ')}-{uuid.uuid4().hex}.png"
        qr_code_bytes = _generate_qr_png(url)
        blob_client = container_client.get_blob_client(blob_name)
        blob_client.upload_blob(
            qr_code_bytes,
            overwrite=True,
            content_settings=ContentSettings(content_type="image/png"),
        )
        sas_url = _generate_blob_sas_url(
            blob_service_client,
            container_name,
            blob_name,
            sas_expiry_minutes,
        )
    except Exception as exc:
        logging.exception("Failed to generate and store QR code.")
        return func.HttpResponse(
            json.dumps({"error": "Failed to generate QR code.", "details": str(exc)}),
            mimetype="application/json",
            status_code=500,
        )

    return func.HttpResponse(
        json.dumps(
            {
                "url": url,
                "blob_name": blob_name,
                "sas_url": sas_url,
                "expires_in_minutes": sas_expiry_minutes,
            }
        ),
        mimetype="application/json",
        status_code=200,
    )