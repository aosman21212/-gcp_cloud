provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# Enable required APIs
resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "clouddeploy" {
  service = "clouddeploy.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "artifactregistry" {
  service = "artifactregistry.googleapis.com"
  disable_dependent_services = true
}

# Create a GKE cluster
resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = "us-central1"

  initial_node_count = 1
  deletion_protection = false

  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 20
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [google_project_service.container]
}

# Create an Artifact Registry repository
resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "my-repo"
  format        = "DOCKER"

  depends_on = [google_project_service.artifactregistry]
}

# Create Cloud Deploy Delivery Pipeline
resource "google_clouddeploy_delivery_pipeline" "pipeline" {
  location = "us-central1"
  name     = "gke-pipeline"

  description = "Pipeline for deploying to GKE"

  serial_pipeline {
    stages {
      target_id = "dev"
      profiles  = []
    }
    stages {
      target_id = "staging"
      profiles  = []
    }
    stages {
      target_id = "production"
      profiles  = []
    }
  }

  depends_on = [google_project_service.clouddeploy]
}

# Create Cloud Deploy Target for Dev
resource "google_clouddeploy_target" "dev" {
  location = "us-central1"
  name     = "dev"

  description = "Development environment"

  gke {
    cluster = google_container_cluster.primary.id
  }

  depends_on = [google_project_service.clouddeploy, google_container_cluster.primary]
}

# Create Cloud Deploy Target for Staging
resource "google_clouddeploy_target" "staging" {
  location = "us-central1"
  name     = "staging"

  description = "Staging environment"

  gke {
    cluster = google_container_cluster.primary.id
  }

  depends_on = [google_project_service.clouddeploy, google_container_cluster.primary]
}

# Create Cloud Deploy Target for Production
resource "google_clouddeploy_target" "production" {
  location = "us-central1"
  name     = "production"

  description = "Production environment"

  gke {
    cluster = google_container_cluster.primary.id
  }

  depends_on = [google_project_service.clouddeploy, google_container_cluster.primary]
}