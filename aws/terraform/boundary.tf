## This file is used to set up the Boundary host catalog and host sets for AWS resources. 

## The following code is commented out to prevent the provisioning of the Boundary resources before the credentials and other AWS resources have been provisioned. 

## Uncomment lines 7 - 42, and the section you need for dynamic or static credentials to set up the Boundary host catalog and host sets.

# provider "boundary" {
#   addr                   = var.boundary_addr
#   auth_method_login_name = var.boundary_login_name
#   auth_method_password   = var.boundary_login_password
# }

# variable "aws_region" {
#   type = string
# }

# variable "boundary_addr" {
#   type = string
# }

# variable "boundary_login_name" {
#   type = string
# }

# variable "boundary_login_password" {
#   type = string
# }

# resource "boundary_scope" "aws_test_org" {
#   name                     = "AWS test org"
#   description              = "Test org for AWS resources"
#   scope_id                 = "global"
#   auto_create_admin_role   = true
#   auto_create_default_role = true
# }

# resource "boundary_scope" "aws_project" {
#   name                   = "aws_project"
#   description            = "Test project for AWS dynamic host catalogs"
#   scope_id               = boundary_scope.aws_test_org.id
#   auto_create_admin_role = true
# }

## Uncomment the following to set up dynamic credentials

# variable "iam_role_arn" {
#   type = string
# }

# variable "iam_role_id" {
#   type = string
# }

# resource "boundary_host_catalog_plugin" "aws_host_catalog" {
#   name          = "AWS Catalog"
#   description   = "AWS Host Catalog"
#   scope_id      = boundary_scope.aws_project.id
#   plugin_name   = "aws"
#   worker_filter = "\"aws\" in \"/tags/cloud\""

#   # recommended to pass in aws secrets using a file() or using environment variables
#   attributes_json = jsonencode({
#     "region" = var.aws_region,
#     "disable_credential_rotation" = true,
#     "role_arn" = var.iam_role_arn,
#     "role_external_id" = var.iam_role_id
#   })
# }

# output "aws_host_catalog_id" {
#   value = boundary_host_catalog_plugin.aws_host_catalog.id
# }

# resource "boundary_host_set_plugin" "database_host_set" {
#   name             = "Database Host Set"
#   description      = "AWS database host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:service-type=database"]
#   })
# }

# output "database_host_set_id" {
#   value = boundary_host_set_plugin.database_host_set.id
# }

# resource "boundary_host_set_plugin" "dev_host_set" {
#   name             = "Dev Host Set"
#   description      = "AWS dev host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:application=dev"]
#   })
# }

# output "dev_host_set_id" {
#   value = boundary_host_set_plugin.dev_host_set.id
# }

# resource "boundary_host_set_plugin" "production_host_set" {
#   name             = "Production Host Set"
#   description      = "AWS Production host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:application=production"]
#   })
# }

# output "production_host_set_id" {
#   value = boundary_host_set_plugin.production_host_set.id
# }

## Uncomment the following to set up static credentials

# variable "iam_access_key_id" {
#   type = string
# }

# variable "iam_secret_access_key" {
#   type = string
# }

# resource "boundary_host_catalog_plugin" "aws_host_catalog" {
#   name          = "AWS Catalog"
#   description   = "AWS Host Catalog"
#   scope_id      = boundary_scope.aws_project.id
#   plugin_name   = "aws"

#   # recommended to pass in aws secrets using a file() or using environment variables
#   attributes_json = jsonencode({
#     "region" = var.aws_region,
#     "disable_credential_rotation" = true 
#   })
#   secrets_json = jsonencode({
#     "access_key_id"     = var.iam_access_key_id,
#     "secret_access_key" = var.iam_secret_access_key
#   })
# }

# output "aws_host_catalog_id" {
#   value = boundary_host_catalog_plugin.aws_host_catalog.id
# }

# resource "boundary_host_set_plugin" "database_host_set" {
#   name             = "Database Host Set"
#   description      = "AWS database host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:service-type=database"]
#   })
# }

# output "database_host_set_id" {
#   value = boundary_host_set_plugin.database_host_set.id
# }

# resource "boundary_host_set_plugin" "dev_host_set" {
#   name             = "Dev Host Set"
#   description      = "AWS dev host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:application=dev"]
#   })
# }

# output "dev_host_set_id" {
#   value = boundary_host_set_plugin.dev_host_set.id
# }

# resource "boundary_host_set_plugin" "production_host_set" {
#   name             = "Production Host Set"
#   description      = "AWS Production host set"
#   host_catalog_id  = boundary_host_catalog_plugin.aws_host_catalog.id
#   attributes_json  = jsonencode({
#     "filters" = ["tag:application=production"]
#   })
# }

# output "production_host_set_id" {
#   value = boundary_host_set_plugin.production_host_set.id
# }