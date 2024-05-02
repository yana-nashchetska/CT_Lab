module "label" {
  source   = "cloudposse/label/null"
  version = "0.25.0"

  namespace  = var.namespace
  stage      = var.stage
  label_order = var.label_order
  environment = var.environment
}

module "label_front_app2" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context

  name = "front-app2"

  tags = {
    Name = local.tag_name
  }
}