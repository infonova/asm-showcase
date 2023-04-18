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
  version = "~> 7.0"

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
  for_each = toset([ "1","2" ])
  cl_index          = each.value              
  source            = "./modules/kubernetes"
  project_id        = var.project_id
  region            = local.region
  network           = module.vpc.network_name
  subnetwork        = module.vpc.subnets_names[0]
  ip_range_pods     = local.pod_ip_range_name
  ip_range_services = local.svc_ip_range_name
  acm_feature = google_gke_hub_feature.acm.name
  asm_feature = google_gke_hub_feature.asm.name
}


resource "google_gke_hub_feature" "acm" {
  project        = var.project_id
  name = "configmanagement"
  location = "global"

  provider = google-beta
}

resource "google_gke_hub_feature" "asm" {
  project        = var.project_id
  name = "servicemesh"
  location = "global"

  provider = google-beta
}