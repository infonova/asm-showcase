data "google_project" "project" {}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  project_id        = data.google_project.project.project_id
  name              = "gke-asm-cluster-${var.cl_index}"
  region            = var.region
  network           = var.network
  subnetwork        = var.subnetwork
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services
  release_channel   = "REGULAR"
  enable_vertical_pod_autoscaling = true

  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.project.number}"
  }

}
