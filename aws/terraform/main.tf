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

variable "BOUNDARY_CLUSTER_ID" {
    description = "boundary cluster id used by the self managed worker"
    validation {
        condition     = can(regex("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$", var.BOUNDARY_CLUSTER_ID))
        error_message = "The boundary cluster id value must be a valid uuid."
    }
}

## uncomment the following to set up dynamic credentials for the Boundary host catalog

# output "boundary_iam_role_arn" {
#     value = aws_iam_role.boundary_worker_dhc.arn
# }

# output "boundary_iam_role_id" {
#   value = aws_iam_role.boundary_worker_dhc.id
#   # sensitive = true
# }

# resource "aws_iam_role" "boundary_worker_dhc" {
#   name = "boundary-worker-dhc2"
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

# resource "aws_iam_user" "boundary" {
#   name = "boundary"
#   path = "/"
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