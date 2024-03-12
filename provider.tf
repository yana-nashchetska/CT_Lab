terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-central-1"
  access_key = "AKIA4MTWJCQUVXCWF2AN"
  secret_key = "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"
}
