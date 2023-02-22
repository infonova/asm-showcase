

resource "google_gke_hub_feature" "asm" {
  project        = var.project_id
  name = "servicemesh"
  location = "global"

  provider = google-beta
}

resource "google_gke_hub_feature_membership" "asm" {
  project        = var.project_id
  location = "global"
  feature = google_gke_hub_feature.asm.name
  membership = google_gke_hub_membership.membership.membership_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta
}