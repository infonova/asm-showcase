locals {
  # BE_Austria
  folder_id = "369295240136"
  # BE-Austria-Billing-Account
  billing_id = "016CFF-D409E2-7F2496"

  enabled_services = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "random_id" "project_suffix" {
  byte_length = 4
}

resource "google_project" "asm_showcase_project" {
  name                = "ASM Showcase"
  project_id          = "asm-showcase-${random_id.project_suffix.hex}"
  folder_id           = local.folder_id
  billing_account     = local.billing_id
  auto_create_network = false
}

resource "google_project_service" "enabled_service" {
  for_each                   = toset(local.enabled_services)
  project                    = google_project.asm_showcase_project.project_id
  service                    = each.key
  disable_dependent_services = true
}
