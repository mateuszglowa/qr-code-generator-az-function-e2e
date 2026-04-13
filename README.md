# QR Code Generator with Azure Function

This project creates QR codes from a URL and stores generated PNG files in Azure Blob Storage.
The HTTP API returns a temporary SAS URL that clients can use to download the generated image.

## What This Project Contains

- Python Azure Function app in [qr-app](qr-app)
- Terraform infrastructure in [infra](infra)
- CI/CD workflows in [.github/workflows](.github/workflows)

## How It Works

1. Client sends a URL to the HTTP trigger endpoint.
2. Function validates the URL.
3. Function generates a QR PNG.
4. Function uploads PNG to Blob Storage container.
5. Function returns JSON with blob path and read-only SAS URL.

Main implementation: [qr-app/function_app.py](qr-app/function_app.py)

## API Contract

### Endpoint

- Route: `/api/http_trigger`
- Method: `GET` or `POST`
- Auth level: anonymous

### Request

You can pass `url` in query string or JSON body.

Example query string:

```bash
curl "http://localhost:7071/api/http_trigger?url=https://example.com"
```

Example JSON body:

```bash
curl -X POST "http://localhost:7071/api/http_trigger" \
	-H "Content-Type: application/json" \
	-d '{"url":"https://example.com"}'
```

### Success Response

```json
{
	"url": "https://example.com",
	"blob_name": "qr-codes/20260413T102233Z-abc123....png",
	"sas_url": "https://<storage>.blob.core.windows.net/<container>/<blob>?<sas>",
	"expires_in_minutes": 15
}
```

### Error Responses

- `400` if `url` is missing or invalid
- `500` if QR generation or Blob upload fails

## Application Settings

Function expects these settings:

- `AzureWebJobsStorage`
- `QR_CODE_CONTAINER_NAME`
- `QR_CODE_SAS_EXPIRY_MINUTES` (optional, default `15`)

Local template: [qr-app/local.settings.json](qr-app/local.settings.json)

## Local Development

### Prerequisites

- Python 3.13
- Azure Functions Core Tools v4
- Terraform 1.14.0
- Azure CLI (if deploying infra)

### Setup

```bash
cd qr-app
python3.13 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Populate [qr-app/local.settings.json](qr-app/local.settings.json) with a valid storage connection string and optional overrides.

### Run Function Locally

```bash
cd qr-app
func start
```

## Infrastructure (Terraform)

Terraform root: [infra](infra)

Environment variables file:

- [infra/environment/dev/terraform.tfvars](infra/environment/dev/terraform.tfvars)

### Validate and Plan

```bash
cd infra
terraform fmt -check -recursive
terraform init -reconfigure
terraform validate
terraform plan -var-file=environment/dev/terraform.tfvars
```

### Apply

```bash
cd infra
terraform apply -var-file=environment/dev/terraform.tfvars
```

## GitHub Workflows

### Function Deployment Workflow

File: [.github/workflows/main_funcapp-dev-qrcode.yml](.github/workflows/main_funcapp-dev-qrcode.yml)

- Triggered on push to `main` only when files in `qr-app/**` change
- Builds and deploys the Function app to Azure

Required secrets:

- `AZUREAPPSERVICE_CLIENTID_E061B3BE4A9E4D17844BDBBE414D1813`
- `AZUREAPPSERVICE_TENANTID_8AFD40476860464998EB9FEC8BCB36D9`
- `AZUREAPPSERVICE_SUBSCRIPTIONID_4ECC95F8F1D74F33BB41428708879A00`

### Terraform Infra Workflow

File: [.github/workflows/terraform-infra.yml](.github/workflows/terraform-infra.yml)

- Runs plan on pull requests and pushes that modify `infra/**`
- Runs apply on `push` to `main` and manual dispatch

Required secret:

- `AZURE_CREDENTIALS`

## Troubleshooting

- `terraform fmt -check` fails: run `terraform fmt -recursive` in [infra](infra)
- Terraform backend 403 on `init`: ensure service principal in `AZURE_CREDENTIALS` has Blob data-plane access to backend state container
- Flex Consumption update error for `FUNCTIONS_WORKER_RUNTIME`: do not set that app setting for `azurerm_function_app_flex_consumption`

## Project Structure

```text
.
├── .github/workflows/
│   ├── main_funcapp-dev-qrcode.yml
│   └── terraform-infra.yml
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── provider.tf
│   ├── backend.tf
│   └── environment/dev/terraform.tfvars
└── qr-app/
		├── function_app.py
		├── requirements.txt
		├── host.json
		└── local.settings.json
```
