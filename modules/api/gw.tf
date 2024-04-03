 resource "aws_api_gateway_rest_api" "my_api" {
  name = "my-api"
  description = "My million and first attempt to create an API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "all_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "authors"
}

// 2. 

resource "aws_api_gateway_method" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type = "AWS"
  # uri = "arn:aws:apigateway:eu-central-1:states:action/StartExecution"
  uri = var.get_all_authors_invoke_arn
  
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
   request_templates       = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = "200"

  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
  
}

resource "aws_api_gateway_integration_response" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = aws_api_gateway_method_response.get_authors.status_code


  //added cors:
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  //

  depends_on = [
    aws_api_gateway_method.get_authors,
    aws_api_gateway_integration.get_authors
  ]
}

// options staff:
//options
resource "aws_api_gateway_method" "options" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.all_authors.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "AWS"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  uri = var.get_all_authors_invoke_arn

}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.all_authors.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration,
  ]
}
// the end of options

// deployment /of API

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.get_authors,
    aws_api_gateway_integration.options_integration, 
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "dev"
}

# module "cors" {
#   source = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"

#   api_id          = aws_api_gateway_rest_api.my_api.id
#   api_resource_id = aws_api_gateway_resource.all_authors.id
# }