data "google_project" "project" {}

module "gke" {

  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                    = "27.0.0"
  project_id                 = data.google_project.project.project_id
  name                       = "gke-asm-cluster-${var.cl_index}"
  region                     = var.region
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true
  release_channel            = "REGULAR"
  remove_default_node_pool   = true
  enable_shielded_nodes      = true
  create_service_account     = true
  grant_registry_access      = true
  gce_pd_csi_driver          = false

  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.project.number}"
  }


  node_pools = [
    {
      name               = "default-node-pool"
      image_type         = "COS_CONTAINERD"
      machine_type       = "e2-standard-4" # for ASM
      min_count          = 1               # for ASM
      initial_node_count = 1
      max_count          = 2
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      auto_repair        = true
      auto_upgrade       = true
      enable_gcfs        = false
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}