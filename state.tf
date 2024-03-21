terraform{
  backend "s3" {
    bucket = "learn-devops-with-terraform"
    key    = "misc-code/tools/terraform.tfstate"
    region = "us-east-1"
  }
}