module "sonarqube" {
  source   = "./modules/sonarqube"
  for_each = var.tools
  tool     = each.key
  instance_type = each.value["instance_type"]
  dns_name     = module.alb.dns_name
  listener_arn = module.alb.listener
  vpc_id       = each.value["vpc_id"]
  port         = each.value["port"]
  priority     = each.value["priority"]
}


module "alb" {
  source  = "./modules/alb"
}