terraform {
  backend "gcs" {
    bucket = "tfstate-asm-showcase-bearingpoint"
  }
}