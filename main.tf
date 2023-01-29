locals {
  project_id        = "asm-showcase"
  region            = "europe-west1"
  enabled_services  = ["compute.googleapis.com"]
  vpc_name          = "${local.project_id}-vpc"
  subnet_name       = "${local.project_id}-subnet"
  pod_ip_range_name = "pod-ip-range"
  svc_ip_range_name = "svc-ip-range"
}

resource "google_project_service" "enabled_service" {
  for_each = toset(local.enabled_services)
  project  = local.project_id
  service  = each.key
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id   = local.project_id
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
