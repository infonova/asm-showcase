terraform {

  backend "gcs" {
    bucket = "tf-state-be-asm-showcase"
    prefix = "terraform/state"
  }

  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.82.0"
    }
  }
}
