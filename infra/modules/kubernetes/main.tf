module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  project_id        = var.project_id
  name              = "${var.project_id}-gke-asm-cluster"
  regional          = false
  zones             = var.zones
  network           = var.network
  subnetwork        = var.subnetwork
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services
  network_policy    = false

  node_pools = [
    {
      name         = "default-node-pool"
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 3
      spot         = true
    }
  ]
}
