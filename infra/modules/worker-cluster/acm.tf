

resource "google_gke_hub_feature_membership" "acm" {
  project    = data.google_project.project.project_id
  location   = "global"
  feature    = var.acm_feature
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.16.0"
#    config_sync {
#      source_format = "unstructured"
#      git {
#        sync_repo   = "https://github.com/infonova/asm-showcase.git"
#        sync_branch = "main"
#        policy_dir  = "config-sync/worker-cluster"
#        secret_type = "none"
#      }
#    }
    policy_controller {
      enabled                    = true
      template_library_installed = true
    }
  }

  provider = google-beta
}
