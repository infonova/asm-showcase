locals {
  region            = "europe-west1"
  gke_zone          = "europe-west1-b"
  vpc_name          = "asm-showcase-vpc"
  subnet_name       = "asm-showcase-subnet"
  pod_ip_range_name = "pod-ip-range"
  svc_ip_range_name = "svc-ip-range"
}

data "google_project" "project" {}


module "vpc" {
  source     = "terraform-google-modules/network/google"
  version    = "~> 10.0.0"
  project_id = data.google_project.project.project_id

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

module "worker_cluster" {
  for_each          = toset(["1"])
  cl_index          = each.value
  source            = "./modules/worker-cluster"
  region            = local.region
  network           = module.vpc.network_name
  subnetwork        = module.vpc.subnets_names[0]
  ip_range_pods     = local.pod_ip_range_name
  ip_range_services = local.svc_ip_range_name
  acm_feature       = google_gke_hub_feature.acm.name
  asm_feature       = google_gke_hub_feature.asm.name
}

module "config_cluster" {
  source            = "./modules/config-cluster"
  region            = local.region
  network           = module.vpc.network_name
  subnetwork        = module.vpc.subnets_names[0]
  ip_range_pods     = local.pod_ip_range_name
  ip_range_services = local.svc_ip_range_name
  acm_feature       = google_gke_hub_feature.acm.name
}


resource "google_gke_hub_feature" "acm" {
  project  = data.google_project.project.project_id
  name     = "configmanagement"
  location = "global"

  provider = google-beta
}

resource "google_gke_hub_feature" "asm" {
  project  = data.google_project.project.project_id
  name     = "servicemesh"
  location = "global"

  provider = google-beta
}

resource "google_compute_global_address" "multi_cluster_ingress_ip_api" {
  name = "multi-cluster-ingress-api"
}

resource "google_compute_global_address" "multi_cluster_ingress_ip_api_usecase" {
  name = "usecase-ingress-api"
}

resource "google_compute_managed_ssl_certificate" "anthos" {
  name = "anthos-cert"

  managed {
    domains = ["anthos.gcp-demo.be-svc.at."]
  }
}

resource "google_compute_managed_ssl_certificate" "anthos-usecaes" {
  name = "usecase-cert"

  managed {
    domains = ["usecase.anthos.gcp-demo.be-svc.at."]
  }
}

data "google_dns_managed_zone" "anthos" {
  name = "gcp-demo"
}

resource "google_dns_record_set" "mci-a-record" {
  managed_zone = data.google_dns_managed_zone.anthos.name
  name         = "anthos.gcp-demo.be-svc.at."
  type         = "A"
  rrdatas      = [google_compute_global_address.multi_cluster_ingress_ip_api.address]
  ttl          = 300
}

resource "google_dns_record_set" "mci-uc-a-record" {
  managed_zone = data.google_dns_managed_zone.anthos.name
  name         = "usecase.anthos.gcp-demo.be-svc.at."
  type         = "A"
  rrdatas      = [google_compute_global_address.multi_cluster_ingress_ip_api_usecase.address]
  ttl          = 300
}
