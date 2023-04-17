terraform {
  backend "s3" {
    bucket = "us-east-1-priv2-tf-backend"
    key    = "state/terraform.tfstate"
    region = "us-west-2"
  }
}
