

resource "google_gke_hub_feature_membership" "acm" {
  project        = data.google_project.project.project_id
  location = "global"
  feature = var.acm_feature
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.14.3"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo   = "https://github.com/infonova/asm-showcase.git"
        sync_branch = "main"
        policy_dir  = "config-sync/config-cluster"
        secret_type = "none"
      }
    }
  }

  provider = google-beta
}