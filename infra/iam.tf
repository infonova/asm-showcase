resource "google_service_account" "prom_frontend" {
  project    = data.google_project.project.project_id
  account_id = "prom-frontend"
}

resource "google_service_account_iam_member" "prom_frontend_wip" {
  service_account_id = google_service_account.prom_frontend.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[monitoring/prom-frontend]"
}

resource "google_project_iam_member" "prom_frontend_bindings" {
  project = data.google_project.project.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.prom_frontend.email}"
}
