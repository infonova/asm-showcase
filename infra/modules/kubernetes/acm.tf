resource "google_gke_hub_feature" "acm" {
  project        = var.project_id
  name = "configmanagement"
  location = "global"

  provider = google-beta
}

resource "google_gke_hub_feature_membership" "acm" {
  project        = var.project_id
  location = "global"
  feature = google_gke_hub_feature.acm.name
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.14.1"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo   = "https://github.com/infonova/asm-showcase.git"
        sync_branch = "main"
        policy_dir  = "config-sync"
        secret_type = "none"
      }
    }
  }
  provider = google-beta
}