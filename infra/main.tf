terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region  = "eu-central-1"

  default_tags {
    tags = {
      managed_by = "Terraform"
      created_by = "Daniel Klier"
    }
  }
}

provider "github" {}
