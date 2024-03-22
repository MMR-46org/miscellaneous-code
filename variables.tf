variable "tools" {
  default = {
    sonarqube = {
      instance_type = "t3.large"
      vpc_id      =  "vpc-05f8f5529d61a83c7"
      port        =  9000
      priority    =  100
    }
  }
}