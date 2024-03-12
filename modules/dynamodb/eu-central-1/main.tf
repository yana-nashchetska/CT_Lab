module "label" {
    source = "cloudposse/label/null"

    name = var.name
}


resource "aws_dynamodb_table" "this" {
  name             = var.label.this
  hash_key         = "id"
  read_capacity    = 10
  write_capacity   = 10

  attribute {
    name = "id"
    type = "S"
  }
}