terraform {
  backend "gcs" {
    bucket = "tf-state-be-austria"
    prefix = "terraform/state/asm-showcase"
  }

  required_version = "~> 1.3.7"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
