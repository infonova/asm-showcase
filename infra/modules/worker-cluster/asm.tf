

resource "google_gke_hub_feature_membership" "asm" {
  project        = var.project_id
  location = "global"
  feature = var.asm_feature
  membership = google_gke_hub_membership.membership.membership_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta
}