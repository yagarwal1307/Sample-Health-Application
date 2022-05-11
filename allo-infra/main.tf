terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}

resource "aws_apprunner_service" "allo-backend" {
  service_name                   = "apprunner-allo-backend"
  source_configuration {
    image_repository {
      image_configuration {
        port = var.SERVER_PORT
        runtime_environment_variables = {
          "SERVER_PORT" : "${var.SERVER_PORT}",
          "MONGO_USERNAME" : "${var.MONGO_USERNAME}",
          "MONGO_PASSWORD" : "${var.MONGO_PASSWORD}",
          "MONGO_HOSTNAME" : "${var.MONGO_HOSTNAME}",
          "MONGO_DATABASE" : "${var.MONGO_DATABASE}",
          "NODE_ENV" : "${var.NODE_ENV}"
        }
      }
      image_identifier      = "${var.IMAGE_URL}:latest"
      image_repository_type = "ECR"
    }
  }
}

output "apprunner_service_url" {
  value = "https://${aws_apprunner_service.allo-backend.service_url}"
}