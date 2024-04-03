module "labels" {
  source  = "cloudposse/label/null"
  name    = var.name
}

resource "aws_dynamodb_table" "this" {
  name             = module.labels.id
  hash_key         = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}