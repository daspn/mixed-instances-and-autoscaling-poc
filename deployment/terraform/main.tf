terraform {
  backend "s3" {
    bucket = "zoop-terraform-tfstates-lab"
    region = "us-east-1"
    key    = "mixed_instances_poc.state"
  }
}

provider "aws" {
  region = "us-east-1"
}
