# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.88"
      }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {}

locals {
    deployment_name = try(split(":", data.aws_caller_identity.current.user_id)[1], "boundary-recording-lab")
}

data "aws_caller_identity" "current" {}

## the BOUNDARY_CLUSTER_ID variable is used when connecting to an HCP Boundary cluster. This is empty when using an Enterprise cluster or Boundary in dev mode.
variable "BOUNDARY_CLUSTER_ID" {
    description = "boundary cluster id used by the self managed worker"
    default     = ""
}

## the BOUNDARY_ADDR variable is used when connecting to an Enterprise Boundary cluster or Boundary in dev mode. This is empty when using an HCP Boundary cluster.
variable "BOUNDARY_ADDR" {
    description = "boundary cluster id used by the self managed worker"
    default     = ""
}

## uncomment the following to set up dynamic credentials for the Boundary host catalog

## the following variable defines a variable to enable the worker IAM instance profile when dynamic creds are used. This is empty when static creds are used

# output "boundary_iam_role_arn" {
#     value = aws_iam_role.boundary_worker_dhc.arn
# }

# output "boundary_iam_role_id" {
#   value = aws_iam_role.boundary_worker_dhc.unique_id
# }

# resource "aws_iam_role" "boundary_worker_dhc" {
#   name = "boundary-worker-dhc"
#   assume_role_policy = jsonencode({
#       "Version": "2012-10-17",
#       "Statement": [
#           {
#               "Effect": "Allow",
#               "Action": [
#                   "sts:AssumeRole"
#               ],
#               "Principal": {
#                   "Service": [
#                       "ec2.amazonaws.com"
#                   ]
#               }
#           }
#       ]
#   })
# }

# resource "aws_iam_role_policy" "describe_instances" {
#   name = "AWSEC2DescribeInstances"
#   role = aws_iam_role.boundary_worker_dhc.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:DescribeInstances",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_instance_profile" "boundary_worker_dhc_profile" {
#   name = "boundary-worker-dhc-profile"
#   role = aws_iam_role.boundary_worker_dhc.name
# }

## uncomment the following to set up static credentials for the Boundary host catalog

# output "boundary_access_key_id" {
#     value = aws_iam_access_key.boundary.id
# }

# output "boundary_secret_access_key" {
#   value = aws_iam_access_key.boundary.secret
#   sensitive = true
# }

# resource "random_id" "aws_iam_user_name" {
#   prefix      = "demo-${local.deployment_name}-boundary-iam-user" # The prefix of the user should match prefix demo-{user_email}* inorder to have demoUser as a iam policy.
#   byte_length = 4
# }

# resource "aws_iam_user" "boundary" {
#   name = random_id.aws_iam_user_name.dec
#   path = "/"
#   force_destroy        = true
##  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/DemoUser" # Uncomment if using the dev account. This is a requirement to obtain access in creating a iam user in the dev account.
#   tags                 = {
#     "boundary-demo" = local.deployment_name # Do Not Remove/Edit. This is a requirement to obtain access in creating a iam user in the dev account.
#   }
# }

# resource "aws_iam_access_key" "boundary" {
#   user = aws_iam_user.boundary.name
# }

# resource "aws_iam_user_policy" "BoundaryDescribeInstances" {
#   name = "BoundaryDescribeInstances"
#   user = aws_iam_user.boundary.name
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "ec2:DescribeInstances"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }