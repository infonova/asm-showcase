resource "google_gke_hub_membership" "membership" {
  project        = var.project_id
  membership_id = "membership-hub-${module.gke.name}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
  provider = google-beta
}

resource "google_gke_hub_feature" "feature" {
  project        = var.project_id
  name = "servicemesh"
  location = "global"

  provider = google-beta
}

resource "google_gke_hub_feature_membership" "feature_member" {
  project        = var.project_id
  location = "global"
  feature = google_gke_hub_feature.feature.name
  membership = google_gke_hub_membership.membership.membership_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta
}