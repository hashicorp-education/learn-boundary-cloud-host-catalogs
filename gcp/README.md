# Google Cloud Platform dynamic host catalogs lab deployment

This directory contains a `terraform/` directory for provisioning the lab
environment with Terraform.

To use the Terraform configuration, ensure your local environment is
authenticated with GCP.

For example, using the [GCP CLI](https://cloud.google.com/sdk/docs/install)

`gcloud auth application-default login`

Once authenticated, add the following variable values:

- `gcp_project_id`
- `gcp_region`
- `gcp_zone`
- `ssh_pub_key_file` (optional)

The SSH public key is required for the Application Default Credentials (ADC) Workflow, and is used to configure a Boundary worker. For other credential workflows the key provides optional access to the host VMs.

**Please note that usage of this configuration will incur costs associated with your GCP account.** You are responsible for these costs. See the Dynamic Host Catalogs tutorial section **Cleanup and teardown** to learn about destroying these resources after completing the tutorial.

The lab template creates:

- 4 Centos VMs
  - Family: centos-stream-9-v20250513
  - Size: e2-micro

Optional:

- 1 Centos VM (worker for ADC workflow)
  - Family: centos-stream-9-v20250513
  - Size: e2-standard-2

The VMs are named and labeled as follows:

- boundary-vm-1-dev
    - Labels: `service-type`: `database` and `application`: `dev`
- boundary-vm-2-dev
    - Labels: `service-type`: `database` and `application`: `dev`
- boundary-vm-3-production
    - Labels: `service-type`: `database` and `application`: `production`
- boundary-vm-4-production
    - Labels: `service-type`: `database` and `application`: `prod`

Optional:

- boundary-worker
    - Labels: `service-type`: `worker`

The fourth VM, `boundary-vm-4-production`, is purposefully misconfigured with a label of `application`: `prod` that is corrected by the learner in the GCP Dynamic Host Catalogs tutorial.