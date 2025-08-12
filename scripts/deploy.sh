#!/bin/bash

# Variables
PROJECT_ID="your-gcp-project-id"
TAG=$1

if [ -z "$TAG" ]; then
  echo "Usage: ./deploy.sh <TAG>"
  exit 1
fi

# Create a release in Cloud Deploy
gcloud deploy releases create release-$TAG \
  --delivery-pipeline gke-pipeline \
  --region us-central1 \
  --images app=us-central1-docker.pkg.dev/$PROJECT_ID/my-repo/app:$TAG

echo "Release created. Promote manually or wait for automatic promotion."