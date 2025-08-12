provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# Enable required APIs
resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "clouddeploy" {
  service = "clouddeploy.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  service = "artifactregistry.googleapis.com"
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