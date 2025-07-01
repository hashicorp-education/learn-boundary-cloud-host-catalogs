# This file is used to set up the GCP service account.

# The following code is commented out to prevent the provisioning of 
# the Boundary resources before the lab environment and VMs have been provisioned. 

# Uncomment the following lines to set up the GCP service account.


## Create a new service account for Boundary

# resource "google_service_account" "boundary_service_account" {
#   account_id   = "boundary-service-account"
#   display_name = "Boundary Service Account"
# }

## Grant the compute viewer role to the service account

# resource "google_project_iam_member" "boundary_compute_viewer" {
#   project = var.gcp_project_id
#   role    = "roles/compute.viewer"
#   member  = google_service_account.boundary_service_account.member
# }