terraform{
  backend "s3" {
    bucket = "learn-devops-with-terraform"
    key    = "misc/elastic/terraform.tfstate"
    region = "us-east-1"
  }
}