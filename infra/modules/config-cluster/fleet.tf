resource "google_gke_hub_membership" "membership" {
  project       = data.google_project.project.project_id
  membership_id = "membership-hub-${module.gke.name}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
  provider = google-beta
}

resource "google_gke_hub_feature" "configmanagement_ingress_feature" {
  project  = data.google_project.project.project_id
  name     = "multiclusteringress"
  location = "global"
  provider = google-beta
  spec {
    multiclusteringress {
      config_membership = google_gke_hub_membership.membership.id
    }
  }
}