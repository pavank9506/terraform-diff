# Terraform Drift Detection with MS Teams Alerts

This repository automates drift detection for Terraform-managed infrastructure and sends alerts to Microsoft Teams when drift is detected.

## Features
- Scheduled drift detection every 6 hours
- Manual workflow dispatch
- AWS credentials configured via GitHub Actions
- MS Teams alert on drift detection

## Workflow Overview
The GitHub Actions workflow performs the following steps:
1. **Checkout repo**: Clones the repository.
2. **Configure AWS credentials**: Assumes a read-only IAM role for Terraform plan.
3. **Setup Terraform**: Installs Terraform CLI.
4. **Terraform Init**: Initializes Terraform in the repo.
5. **Terraform Plan (Drift Check)**: Runs `terraform plan` to check for drift.
6. **Detect Drift**: Sets a flag if drift is detected.
7. **Send MS Teams Alert**: Sends a formatted message to a Teams channel if drift is found.

## MS Teams Alert Example
The alert message includes:
- 🚨 Drift detected
- Repository name
- Triggering user
- Link to the workflow run

## Setup Instructions
1. **Add Secrets to GitHub**
   - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (if not using role assumption)
   - `MS_TEAMS_WEBHOOK`: Incoming webhook URL for your Teams channel
2. **Customize Schedule**
   - Edit the cron expression in `.github/workflows/ci.yml` to change detection frequency.
3. **Teams Webhook Setup**
   - Go to your Teams channel > Connectors > Incoming Webhook
   - Copy the webhook URL and add it as a secret in your repository

## Example Workflow Snippet
```yaml
- name: Send MS Teams Alert
  if: steps.drift.outputs.drift == 'true'
  env:
    MS_TEAMS_WEBHOOK: ${{ secrets.MS_TEAMS_WEBHOOK }}
  run: |
    curl -H "Content-Type: application/json" -d '{
      "text": "**🚨 Terraform Drift Detected**\n\nRepo: ${{ github.repository }}\nTriggered by: ${{ github.actor }}\nRun: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
    }' "$MS_TEAMS_WEBHOOK"
```

## Customization
- You can modify the Teams message format in the workflow file.
- Add more details or actions as needed.

