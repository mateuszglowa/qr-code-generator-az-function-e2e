# Deployment Plan

Status: Ready for Validation

## Request
Update the existing Azure Functions Python app so it accepts a URL, generates a QR code image, stores it in Azure Blob Storage using Function App configuration, creates a SAS URL for the uploaded blob, and returns that URL in an HTTP 200 response.

## Mode
MODIFY existing application

## Current State
- Existing Python Azure Functions v2 HTTP trigger in qr-app/function_app.py.
- Existing Terraform-managed Azure Function App and Storage Account.
- Existing storage container provisioned by Terraform for the Function App.
- Existing workflow deploys qr-app to the Function App.

## Planned Changes
- Update the HTTP trigger implementation to validate the incoming URL and generate a QR code image.
- Upload the generated QR image to Azure Blob Storage.
- Generate a time-limited SAS URL for the uploaded blob and return it to the client as JSON.
- Add the required Python dependencies for QR code generation and Blob Storage access.
- Add or align Function App settings so code reads storage configuration from environment variables.
- If needed, update Terraform so the Function App exposes the required app settings consistently.

## Azure Configuration Strategy
- Reuse the existing storage account already provisioned for the Function App.
- Read storage connection details from Function App settings rather than hardcoding names.
- Prefer private blob container access and return only a generated SAS URL.

## Validation Plan
- Verify Python dependencies resolve.
- Verify the function file has no workspace diagnostics.
- Verify the function can parse input and return the expected JSON response format.
- Confirm the required app settings are present in Terraform or local settings for local execution.

## Open Decisions
- Use the existing function storage container for generated QR codes unless a separate container is preferred.
- Use a short SAS expiry window unless a different TTL is required.
