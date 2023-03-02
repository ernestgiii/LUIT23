# **** provider.tf***

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    docker = {
      source = "kreuzwerker/docker"
    }

  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "blackntechbucket"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

provider "docker" {}