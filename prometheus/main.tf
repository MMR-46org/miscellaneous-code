terraform {
  backend s3{
    bucket = "learn-devops-with-terraform"
    key    = "misc/prometheus/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_ami" "centos8" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

}


resource "aws_instance" "prometheus" {
  ami               = data.aws_ami.centos8.image_id
  instance_type     = "t3.small"
  vpc_security_group_ids = ["sg-04e445f50c19e84f2"]
  iam_instance_profile = aws_iam_instance_profile.main.name

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_route53_record" "prometheus" {
  zone_id = "Z0189341LG4L24HIU4QF"
  name    = "prometheus"
  type    =  "A"
  ttl     =  30
  records = [aws_instance.prometheus.private_ip]
}


resource "aws_route53_record" "prometheus-public" {
  zone_id    =  "Z0189341LG4L24HIU4QF"
  name       =  "prometheus-public"
  type       =  "A"
  ttl        =  30
  records    = [aws_instance.prometheus.public_ip]
}

resource "aws_route53_record" "Grafana" {
  zone_id = "Z0189341LG4L24HIU4QF"
  name    = "Grafana"
  type    =  "A"
  ttl     =  30
  records = [aws_instance.prometheus.public_ip]
}



resource "aws_iam_role" "main" {
  name               = "prometheus-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "prometheus"

    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Prometheus",
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeInstances",
            "ec2:DescribeAvailabilityZones"
          ],
          "Resource": "*"
        }

      ]
    })
  }
}



resource "aws_iam_instance_profile" "main" {
  name = "prometheus-role"
  role = aws_iam_role.main.name
}
