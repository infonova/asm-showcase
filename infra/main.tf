locals {
  region            = "europe-west1"
  gke_zone          = "europe-west1-b"
  vpc_name          = "${var.project_id}-vpc"
  subnet_name       = "${var.project_id}-subnet"
  pod_ip_range_name = "pod-ip-range"
  svc_ip_range_name = "svc-ip-range"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id   = var.project_id
  network_name = local.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = "172.15.0.0/22"
      subnet_region         = local.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = local.pod_ip_range_name
        ip_cidr_range = "10.0.0.0/21"
      },
      {
        range_name    = local.svc_ip_range_name
        ip_cidr_range = "10.0.8.0/21"
      }
    ]
  }
}

module "gke" {
  source            = "./modules/kubernetes"
  project_id        = var.project_id
  zones             = [local.gke_zone]
  network           = module.vpc.network_name
  subnetwork        = local.subnet_name
  ip_range_pods     = local.pod_ip_range_name
  ip_range_services = local.svc_ip_range_name
}
