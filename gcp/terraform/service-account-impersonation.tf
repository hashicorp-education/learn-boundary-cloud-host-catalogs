## This file is used to set up GCP service account impersonation.

## The following code is commented out to prevent the provisioning of 
## the Boundary resources before the lab environment and VMs have been provisioned. 

## Uncomment the following lines to set up GCP service account impersonation.


## Create a new service account for Boundary

# resource "google_service_account" "boundary_target_service_account" {
#   account_id   = "boundary-target-sa2"
#   display_name = "Boundary Target Service Account"
# }

# resource "google_service_account" "boundary_base_service_account" {
#   account_id   = "boundary-base-sa2"
#   display_name = "Boundary Base Service Account"
# }

## Grant the compute viewer role to the target service account

# resource "google_project_iam_member" "boundary_compute_viewer" {
#   project = var.gcp_project_id
#   role    = "roles/compute.viewer"
#   member  = google_service_account.boundary_target_service_account.member
# }

## Grant the iam.serviceAccountTokenCreator role to the base service account

# resource "google_project_iam_member" "boundary_SA_token_creator" {
#   project = var.gcp_project_id
#   role    = "roles/iam.serviceAccountTokenCreator"
#   member  = google_service_account.boundary_base_service_account.member
# }

## Create a key for the base service account

# resource "google_service_account_key" "boundary_base_service_account_key" {
#   service_account_id = google_service_account.boundary_base_service_account.id
#   public_key_type     = "TYPE_X509_PEM_FILE"
#   private_key_type    = "TYPE_GOOGLE_CREDENTIALS_FILE"
#   key_algorithm       = "KEY_ALG_RSA_2048"
# }