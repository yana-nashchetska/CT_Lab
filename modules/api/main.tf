data "aws_caller_identity" "current" {}

module "labels" {
  source   = "cloudposse/label/null"
  version = "0.25.0"
  stage = "dev"
  name = var.name
}

resource "aws_api_gateway_rest_api" "this" {
  name = module.labels.id
}

// // // // 
resource "aws_api_gateway_resource" "authors_resource" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors-resource"
}

# resource "aws_api_gateway_resource" "authors_resource" {
#   parent_id   = aws_api_gateway_rest_api.this.root_resource_id
#   path_part   = "api-resource"
#   rest_api_id = aws_api_gateway_rest_api.this.id
# }

resource "aws_lambda_permission" "get_all_authors_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "get-all-authors-lambda"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.this.id}/*/${aws_api_gateway_method.this_method.http_method}${aws_api_gateway_resource.authors_resource.path}"
}

resource "aws_api_gateway_integration" "this_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors_resource.id
  http_method             = aws_api_gateway_method.this_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_authors_invoke_arn

  depends_on = [ aws_api_gateway_method.this_method ]
}

resource "aws_api_gateway_deployment" "this_depl" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.authors_resource.id,
      aws_api_gateway_method.this_method.id,
      aws_api_gateway_integration.this_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_method" "this_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.authors_resource.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}


resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.this_depl.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}