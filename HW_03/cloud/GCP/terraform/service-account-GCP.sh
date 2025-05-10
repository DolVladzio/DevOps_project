#!/bin/bash
set -euo pipefail
#######################################################
CONFIG_PATH=$1
SERVICE_ACCOUNT_NAME=$(grep -oP '"terraform_username":\s*"\K[^"]+' "$CONFIG_PATH")
ROLE="roles/$2"
PROJECT_ID=$(gcloud config get-value project)
DESCRIPTION="The service account for the Terraform"
KEY_FILE=$3
BUCKET_NAME=$(grep -oP '"bucket_state_name":\s*"\K[^"]+' "$CONFIG_PATH")
BUCKET_LOCATION=$(grep -oP '"state_bucket_location_gcp":\s*"\K[^"]+' "$CONFIG_PATH")
#######################################################
# CHECKING PROJECT ID
if [[ -z "$PROJECT_ID" ]]; then
	echo "❌ Error: Unable to retrieve GCP project ID. Use 'gcloud config set project YOUR_PROJECT_ID'"
	exit 1
else
	ho "=== Project's id: '$PROJECT_ID' ==="
fi
#######################################################
REQUIRED_APIS=(
	"iamcredentials.googleapis.com"
	"compute.googleapis.com"
	"cloudresourcemanager.googleapis.com"
	"serviceusage.googleapis.com"
	"storage.googleapis.com"
)

echo "=== Enabling required APIs for project: $PROJECT_ID ==="
for api in "${REQUIRED_APIS[@]}"; do
	echo "- Enabling '$api'..."
	gcloud services enable "$api" --project="$PROJECT_ID" || echo "⚠️  Failed to enable $api"
done
echo "=== All required APIs attempted to enable. ==="
echo
#######################################################
echo "=== Checking for the service account $SERVICE_ACCOUNT_NAME... ==="
if gcloud iam service-accounts describe "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" &>/dev/null; then
	echo "ℹ️ Service account already exists: $SERVICE_ACCOUNT_NAME"
else
	echo "🆕 Creating service account: $SERVICE_ACCOUNT_NAME..."
	gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
		--description="$DESCRIPTION" \
		--display-name="$SERVICE_ACCOUNT_NAME"
fi
#######################################################
echo "🔑 Binding role '$ROLE' to the service account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
	--member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
	--role="$ROLE" || echo "⚠️ Role binding may already exist"
#######################################################
echo "=== Checking if key file already exists: $KEY_FILE ==="
if [[ -f "$KEY_FILE" ]]; then
	echo "ℹ️ Key file already exists: $KEY_FILE. Skipping creation."
else
	echo "🔐 Creating key file: $KEY_FILE"
	gcloud iam service-accounts keys create "$KEY_FILE" \
		--iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
fi
#######################################################
echo "✅ Activating service account..."
gcloud auth activate-service-account \
	"$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
		--key-file="$KEY_FILE" || {
	echo "❌ Failed to activate service account. Check time sync or key validity."
	exit 1
}
#######################################################
echo "=== Checking if bucket exists: gs://$BUCKET_NAME ==="
if gsutil ls -p "$PROJECT_ID" "gs://$BUCKET_NAME" &>/dev/null; then
	echo "ℹ️ Bucket already exists: gs://$BUCKET_NAME"
else
	echo "🪣 Creating bucket: gs://$BUCKET_NAME in $BUCKET_LOCATION"
	gcloud storage buckets create "gs://$BUCKET_NAME" \
		--location="$BUCKET_LOCATION" \
		--uniform-bucket-level-access
fi
#######################################################
echo "🔁 Enabling versioning on bucket: gs://$BUCKET_NAME"
gsutil versioning set on "gs://$BUCKET_NAME" || echo "⚠️ Versioning already enabled?"
#######################################################
# echo "🚀 STARTING TERRAFORM"
# terraform init
# terraform apply
#######################################################
