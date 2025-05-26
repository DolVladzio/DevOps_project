#!/bin/bash
set -euo pipefail

CONFIG_PATH=$1
SERVICE_PRINCIPAL_NAME=$(grep -oP '"terraform_username":\s*"\K[^"]+' "$CONFIG_PATH")
SERVICE_PRINCIPAL_ROLE="Contributor"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
DESCRIPTION="The service principal for Terraform"
KEY_FILE="${2%.json}.json"

STORAGE_ACCOUNT_NAME="$(grep -oP '"storage_account_name_azurerm":\s*"\K[^"]+' "$CONFIG_PATH")$(date +%s)"
CONTAINER_NAME=$(grep -oP '"bucket_state_name":\s*"\K[^"]+' "$CONFIG_PATH")
RESOURCE_GROUP=$(grep -oP '"resource_group_name_azurerm":\s*"\K[^"]+' "$CONFIG_PATH")
LOCATION=$(grep -oP '"location_azurerm":\s*"\K[^"]+' "$CONFIG_PATH")

DB_USERNAME=$(grep -oP '"db-username":\s*"\K[^"]+' "$CONFIG_PATH")
DB_PASS=$(grep -oP '"db-pass":\s*"\K[^"]+' "$CONFIG_PATH")
SECRET_NAME_DB_USERNAME=$(grep -o 'db-username[:]*' "$CONFIG_PATH")
SECRET_NAME_DB_PASS=$(grep -o 'db-pass[:]*' "$CONFIG_PATH")
KEY_VAULT_NAME=$(grep -oP '"key_vault_name_azurerm":\s*"\K[^"]+' "$CONFIG_PATH")
#########################################################################
if [[ -z "$SUBSCRIPTION_ID" ]]; then
	echo "✅ Error: Unable to retrieve Azure subscription ID."
	exit 1
else
	echo "=== Project's ID: '$SUBSCRIPTION_ID' ==="
	echo
fi
#########################################################################
if az ad sp list --display-name $SERVICE_PRINCIPAL_NAME | grep -q '"displayName": $SERVICE_PRINCIPAL_NAME'; then
    echo "✅ Service principal exists."
	echo
else
    echo "=== Service principal does not exist. Creating... ==="
	az ad sp create-for-rbac --name "$SERVICE_PRINCIPAL_NAME" \
		--role $SERVICE_PRINCIPAL_ROLE \
		--scopes "/subscriptions/$SUBSCRIPTION_ID" > "$KEY_FILE"
	echo
fi
#########################################################################
