terraform {
  cloud {
    organization = "patricks-org"

    workspaces {
      name = "asm-showcase-infra"
    }
  }

  required_version = "~> 1.3.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
