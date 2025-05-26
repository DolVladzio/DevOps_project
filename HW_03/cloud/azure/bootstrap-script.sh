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
if az keyvault show --name "$KEY_VAULT_NAME" --query "name" -o tsv; then
    echo "✅ Key Vault '$KEY_VAULT_NAME' exists."
	echo
else
	echo "=== Creating Azure Key Vault ==="
	az keyvault create --name "$KEY_VAULT_NAME" \
		--resource-group "$RESOURCE_GROUP" \
		--location "$LOCATION"
	echo
fi
#########################################################################
# check_secret_exists() {
#     az keyvault secret show --vault-name "$1" \
# 		--name "$2" > /dev/null 2>&1
# 	return $?
# }
# # Function to create a secret if it doesn't already exist
# createSecret() {
# 	KEY_VAULT_NAME=$1
# 	SECRET_NAME=$2
# 	SECRET_VALUE=$3

# 	if check_secret_exists "$KEY_VAULT_NAME" "$SECRET_NAME"; then
# 		echo "✅ Secret '$SECRET_NAME' created and value added in Key Vault '$KEY_VAULT_NAME'."
# 		echo
# 	else
# 		echo "Creating secret '$SECRET_NAME'..."
# 		if az keyvault secret set --vault-name "$KEY_VAULT_NAME" \
# 				--name "$SECRET_NAME" \
# 				--value "$SECRET_VALUE" > /dev/null 2>&1; then
#             echo "✅ Secret '$SECRET_NAME' created and value added."
# 			echo
#         else
#             echo "❌ Failed to create secret '$SECRET_NAME'."
#             exit 1
#         fi
# 	fi
# }
# createSecret "$KEY_VAULT_NAME" "$SECRET_NAME_DB_USERNAME" "$DB_USERNAME"
# createSecret "$KEY_VAULT_NAME" "$SECRET_NAME_DB_PASS" "$DB_PASS"
#########################################################################
if az storage account show --name "$STORAGE_ACCOUNT_NAME" \
		--resource-group "$RESOURCE_GROUP" > /dev/null 2>&1; then
    echo "✅ Azure Storage account '$STORAGE_ACCOUNT_NAME' already exists."
	echo
else
	echo "=== Setting Up Azure Storage for Terraform State ==="
	az storage account create --name "$STORAGE_ACCOUNT_NAME" \
		--resource-group "$RESOURCE_GROUP" \
		--location "$LOCATION" \
		--sku "Standard_LRS"
	echo
fi
#########################################################################
if az storage container show \
		--name "$CONTAINER_NAME" \
		--account-name "$STORAGE_ACCOUNT_NAME" \
		--resource-group "$RESOURCE_GROUP" > /dev/null 2>&1; then
	echo "✅ Storage container '$CONTAINER_NAME' exists in account '$STORAGE_ACCOUNT_NAME'."
	echo
else
	echo "=== Creating the container $CONTAINER_NAME ==="
	az storage container create --name "$CONTAINER_NAME" \
		--account-name "$STORAGE_ACCOUNT_NAME"
	echo
fi
#########################################################################
