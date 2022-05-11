# locals {
# 	mongodb_atlas_api_pub_key = ""
# 	mongodb_atlas_api_pri_key = ""
# 	mongodb_atlas_org_id  = ""
# }

# terraform {
# 	required_providers {
#     	    mongodbatlas = {
#       	        source = "mongodb/mongodbatlas"
#       	        version = "1.3.1"
#     	    }
# 	}
# }

# provider "mongodbatlas" {
# 	public_key  = local.mongodb_atlas_api_pub_key
# 	private_key = local.mongodb_atlas_api_pri_key
# }

# resource "mongodbatlas_project" "my_project" {
#   name   = "test"
#   org_id = local.mongodb_atlas_org_id
# }

# resource "mongodbatlas_cluster" "my_cluster" {
# 	project_id          	= mongodbatlas_project.my_project.id
# 	name                	= "terraform"

# 	provider_name = "TENANT"
# 	backing_provider_name = "AWS"
# 	provider_region_name = "US_EAST_1"
# 	provider_instance_size_name = "M0"
	
# 	depends_on = [mongodbatlas_project.my_project]
# }

# output "connection_strings" {
# 	value = mongodbatlas_cluster.my_cluster.connection_strings.0.standard_srv
# }