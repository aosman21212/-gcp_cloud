output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "artifact_registry_url" {
  value = "us-central1-docker.pkg.dev/${var.project_id}/my-repo"
}