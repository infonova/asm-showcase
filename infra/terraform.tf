terraform {
  
  backend "gcs" {
    bucket = "tf-state-be-asm-showcase"
    prefix = "terraform/state"
  }

  required_version = "~> 1.3.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
