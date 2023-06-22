terraform {
  required_version = "1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.3.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      System = var.system
      Env    = var.env
    }
  }
}