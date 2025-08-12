# GKE CI/CD Pipeline with Cloud Build and Cloud Deploy

## Overview
This project sets up a CI/CD pipeline for deploying applications to GKE using Cloud Build and Cloud Deploy, with Terraform managing the infrastructure.

## Setup Instructions
1. Clone the repository.
2. Navigate to the `terraform/` directory and run:
   ```bash
   terraform init
   terraform apply
   ```
3. Connect your GitHub repository to Cloud Build:
   - Go to the Google Cloud Console > Cloud Build > Triggers.
   - Connect your GitHub repository and create a trigger for `app/cloudbuild.yaml`.
4. Build and push the application image using Cloud Build:
   ```bash
   gcloud builds submit --config app/cloudbuild.yaml
   ```
5. Deploy the application using Cloud Deploy:
   ```bash
   ./scripts/deploy.sh $TAG
   ```

## Directory Structure
- `terraform/`: Terraform configurations for GCP resources.
- `app/`: Application code and Docker configuration.
- `clouddeploy/`: Cloud Deploy pipeline and Kubernetes manifests.
- `scripts/`: Helper scripts for deployment.

## Components

### Terraform Infrastructure
- **GKE Cluster**: Managed Kubernetes cluster on Google Cloud
- **Artifact Registry**: Docker image repository
- **APIs**: Enables Cloud Build, Cloud Deploy, and Container APIs

### CI/CD Pipeline
- **Cloud Build**: Builds and pushes Docker images
- **Cloud Deploy**: Manages deployments across environments
- **Environments**: Dev, Staging, and Production

### Kubernetes Manifests
- Separate deployment configurations for each environment
- Configurable replica counts per environment

## Usage

### Initial Setup
1. Set your GCP project ID in `terraform/terraform.tfvars`:
   ```hcl
   project_id = "your-gcp-project-id"
   ```

2. Initialize and apply Terraform:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

### Deploying Applications
1. Push code changes to your GitHub repository
2. Cloud Build will automatically trigger and build the image
3. Use the deploy script to create a release:
   ```bash
   ./scripts/deploy.sh v1.0.0
   ```

### Environment Promotion
- Deployments start in the `dev` environment
- Promote to `staging` and then `production` through the Cloud Deploy console
- Each environment has different replica counts for scaling

## Security Considerations
- GKE nodes use OAuth scopes for cloud platform access
- Artifact Registry provides secure image storage
- Environment isolation through separate Kubernetes namespaces

## Monitoring and Logging
- Use Google Cloud Console for monitoring GKE clusters
- Cloud Build logs available in Cloud Logging
- Cloud Deploy provides deployment history and rollback capabilities