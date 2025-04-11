This directory contains Terraform files for provisioning the lab environment. **Note that these files are for reference, and meant to be deployed in the order specified in the Boundary Cloud Host Catalogs tutorial.** The plan will not deploy correctly without exporting the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION` environment variables defined in the tutorial.

**Please note that usage of this template will incur costs associated with your AWS account.** You are responsible for these costs. See the Dynamic Host Catalogs tutorial section **Cleanup and teardown** to learn about destroying these resources after completing the tutorial.

The Terraform plan creates:

- 5 Amazon Linux instances
  - AMI ID `ami-0a0d7666aecd99093`
  - Size: `t3.micro` (worker is t2.micro)

The VMs are named and tagged as follows:

- boundary-1-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-2-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-3-production
    - Tags: `service-type`: `database` and `application`: `production`
- boundary-4-production
    - Tags: `service-type`: `database` and `application`: `prod`
- boundary-worker
    - Tags: `service-type`: `worker` and `cloud`: `aws`

The fourth VM, `boundary-vm-4-production`, is purposefully misconfigured with a tag of `application`: `prod` that is corrected by the learner in the Dynamic Host Catalogs tutorial.

The fifth VM, `boundary-worker`, is a self-managed Boundary worker instance. After registering the worker with the Boundary control plane, the dynamic host catalog plugin can use the AWS DescribeInstances API to fetch a list of hosts for Boundary to sync. The worker is only necessary when setting up dynamic credentials using AssumeRole. Static credentials provided by IAM credentials do not require a self-managed worker.