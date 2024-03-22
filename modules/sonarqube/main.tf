resource "aws_instance" "sonarqube" {
  ami                      =  data.aws_ami.centos8.image_id
  instance_type            = var.instance_type
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
    Name: var.tool
  }
}

resource "aws_route53_record" "sonarqube" {
  zone_id = "Z0189341LG4L24HIU4QF"
  name    = var.tool
  type    =  "CNAME"
  ttl     =  30
  records = [var.dns_name]
}


resource "aws_lb_listener_rule" "rule" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }


  condition {
    host_header {
      values = ["${var.tool}.madhanmohanreddy.tech"]
    }
  }
}



resource "aws_lb_target_group" "tg" {
  name     = "${var.tool}-tg"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
