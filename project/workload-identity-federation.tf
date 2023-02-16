locals {
  tfc_hostname = "app.terraform.io"
}

resource "google_iam_workload_identity_pool" "tfc_id_pool" {
  workload_identity_pool_id = "terraform-cloud-id-pool"
  display_name              = "Terraform Cloud Identity Pool"
  description               = "Identity pool for Terraform Cloud"
  project                   = google_project.asm_showcase_project.project_id
}

resource "google_iam_workload_identity_pool_provider" "tfc_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc_id_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform-id-provider"
  project                            = google_project.asm_showcase_project.project_id
  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${local.tfc_hostname}"
  }
  attribute_condition = "assertion.terraform_project_id == \"${var.tfc_project_id}\""
}

resource "google_service_account" "tfc_asm_showcase" {
  account_id   = "tfc-asm-showcase"
  display_name = "ASM Showcase Terraform Cloud Service Account"
  project      = google_project.asm_showcase_project.project_id
}

resource "google_service_account_iam_member" "tfc_service_account_member" {
  service_account_id = google_service_account.tfc_asm_showcase.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc_id_pool.name}/*"
}

resource "google_project_iam_member" "tfc_project_member" {
  project = google_project.asm_showcase_project.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tfc_asm_showcase.email}"
}
