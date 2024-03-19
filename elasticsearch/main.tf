terraform{
  backend "s3" {
    bucket = "learn-devops-with-terraform"
    key    = "misc/elastic/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos8" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}



resource "aws_instance" "elasticsearch" {
  ami                      =  data.aws_ami.centos8.image_id
  instance_type            = "m6in.large"
  vpc_security_group_ids   = ["sg-04e445f50c19e84f2"]
  subnet_id                = "subnet-0b07ed0f580da13ce"

  instance_market_options{
    market_type = "spot"
    spot_options {
    instance_interruption_behavior = "stop"
    spot_instance_type = "persistent"
   }
  }
  tags = {
    Name: "elasticsearch"
  }
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = "Z0189341LG4L24HIU4QF"
  name    = "elasticsearch"
  type    =  "A"
  ttl     =  30
  records = [aws_instance.elasticsearch.public_ip]
}


resource "aws_route53_record" "logstash" {
  zone_id = "Z0189341LG4L24HIU4QF"
  name    = "logstash"
  type    =  "A"
  ttl     =  30
  records = [aws_instance.elasticsearch.private_ip]
}