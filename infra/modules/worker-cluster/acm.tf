

resource "google_gke_hub_feature_membership" "acm" {
  project    = data.google_project.project.project_id
  location   = "global"
  feature    = var.acm_feature
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.20.2"
    config_sync {
      source_format = "unstructured"
      enabled       = true
      git {
        sync_repo   = "https://github.com/infonova/asm-showcase.git"
        sync_branch = "main"
        policy_dir  = "config-sync/worker-cluster"
        secret_type = "none"
      }
    }
  }


}


resource "google_gke_hub_feature_membership" "pc" {
  project    = data.google_project.project.project_id
  location   = "global"
  feature    = var.pc_feature
  membership = google_gke_hub_membership.membership.membership_id
  policycontroller {
    policy_controller_hub_config {
      install_spec = "INSTALL_SPEC_ENABLED"
    }
  }
  provider = google-beta
}
