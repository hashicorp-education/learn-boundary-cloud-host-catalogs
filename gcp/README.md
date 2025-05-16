# Google Cloud Platform Infrastructure Manager deployment

This directory contains a `terraform/` directory for provisioning the lab
environment with Terraform.

To use the Terraform configuraiton, ensure your local environment is
authenticated with GCP.

For example, using the [GCP CLI](https://cloud.google.com/sdk/docs/install)

`gcloud auth application-default login`

The GCP Infrastructure Manager template, `gcp-dynamic-hosts.yaml` is
expirmental. Please use the Terraform configuraiton.

**Please note that usage of this configuration will incur costs associated with your GCP account.** You are responsible for these costs. See the Dynamic Host Catalogs tutorial section **Cleanup and teardown** to learn about destroying these resources after completing the tutorial.

The lab template creates:

- 4 Centos VMs
  - Family: centos-stream-9-arm64
  - Size: e2-micro

The VMs are named and tagged as follows:

- boundary-vm-1-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-vm-2-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-vm-3-production
    - Tags: `service-type`: `database` and `application`: `production`
- boundary-vm-4-production
    - Tags: `service-type`: `database` and `application`: `prod`

The fourth VM, `boundary-vm-4-production`, is purposefully misconfigured with a tag of `application`: `prod` that is corrected by the learner in the Dynamic Host Catalogs tutorial.