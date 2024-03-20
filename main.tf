module "sonarqube" {
  source   = "./modules/sonarqube"
  for_each = var.tools
  tool     = each.key
  instance_type = each.value["instance_type"]

}