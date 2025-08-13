output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "artifact_registry_url" {
  value = "us-central1-docker.pkg.dev/${var.project_id}/my-repo"
}

output "clouddeploy_pipeline_name" {
  value = google_clouddeploy_delivery_pipeline.pipeline.name
}

output "clouddeploy_targets" {
  value = {
    dev        = google_clouddeploy_target.dev.name
    staging    = google_clouddeploy_target.staging.name
    production = google_clouddeploy_target.production.name
  }
}