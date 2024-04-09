// IT WORKS HALELUJAH

// API 
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my api"
  description = "API example with CORS."
}

# First resourse for an API - authors 
resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_method" "get_authors" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type = "AWS"
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
  resource_id = aws_api_gateway_resource.authors.id
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
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = aws_api_gateway_method_response.get_authors.status_code

response_templates = {
  "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
}


  content_handling = "CONVERT_TO_TEXT"
}

// !!! LAMBDA PERMISSIONS MUST HAVE
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_authors_arn
  principal     = "apigateway.amazonaws.com"
}

# OPTIONS for /authors
resource "aws_api_gateway_method" "authors_options" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Відповідь для методу OPTIONS
resource "aws_api_gateway_method_response" "authors_options_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  status_code = "200"

   response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
   }

   depends_on = [ aws_api_gateway_method.authors_options ]
}
# Прикріплення методу OPTIONS до ресурсу /authors
resource "aws_api_gateway_integration" "authors_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.authors_options.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  # request_templates = {
  #   "application/json" = "{\"statusCode\": 200}"
  # }

  uri = var.get_all_authors_invoke_arn

  depends_on = [ aws_api_gateway_method.authors_options ]
}


# Прикріплення відповіді до методу OPTIONS
resource "aws_api_gateway_integration_response" "authors_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  status_code = aws_api_gateway_method_response.authors_options_response.status_code

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

    depends_on = [
     aws_api_gateway_method_response.authors_options_response
    ]
}





resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_method" "get_courses" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.get_all_courses_invoke_arn
  
  request_parameters  = {"integration.request.header.X-Authorization" = "'static'"}

     request_templates       = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  status_code = "200"

  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


resource "aws_api_gateway_integration_response" "get_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  status_code = aws_api_gateway_method_response.get_courses.status_code

response_templates = {
  "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
}


  content_handling = "CONVERT_TO_TEXT"
}
# //----------------------------
# Додавання дозволу на виклик функції Lambda
resource "aws_lambda_permission" "api_gateway_invoke_courses" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_courses_arn
  principal     = "apigateway.amazonaws.com"
}

# Додавання методу OPTIONS для /courses
resource "aws_api_gateway_method" "courses_options" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Відповідь для методу OPTIONS
resource "aws_api_gateway_method_response" "courses_options_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_options.http_method
  status_code = "200"

   response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
   }

   depends_on = [ aws_api_gateway_method.courses_options ]
}
# Прикріплення методу OPTIONS до ресурсу /authors
resource "aws_api_gateway_integration" "courses_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.courses_options.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  # request_templates = {
  #   "application/json" = "{\"statusCode\": 200}"
  # }

  uri = var.get_all_courses_invoke_arn

  depends_on = [ aws_api_gateway_method.courses_options ]
}


# Прикріплення відповіді до методу OPTIONS
resource "aws_api_gateway_integration_response" "courses_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_options.http_method
  status_code = aws_api_gateway_method_response.courses_options_response.status_code

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

    depends_on = [
     aws_api_gateway_method_response.courses_options_response
    ]
}


/// COURSES POST 

resource "aws_api_gateway_model" "my_api" {
  rest_api_id  = aws_api_gateway_rest_api.my_api.id
  name         = "mymodel"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = jsonencode({
    "$schema": "http://json-schema.org/schema#",
    "title": "json_courses",
    "type": "object",
    "properties": {
      "title": {"type": "string"},
      "authorId": {"type": "string"},
      "length": {"type": "string"},
      "category": {"type": "string"}
    },
    "required": ["title", "authorId", "length", "category"]
  })
}

resource "aws_api_gateway_request_validator" "my_api" {
  name                        = "POSTExampleRequestValidator"
  rest_api_id                 = aws_api_gateway_rest_api.my_api.id
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_method" "post_courses" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"
request_validator_id = aws_api_gateway_request_validator.my_api.id

  request_models = {
    "application/json" = aws_api_gateway_model.my_api.name
  }
}

resource "aws_api_gateway_method_response" "post_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.post_courses.http_method
  status_code = "200"

  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration" "post_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.post_courses.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.save_course_invoke_arn
  
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



resource "aws_api_gateway_integration_response" "post_courses" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.post_courses.http_method
  status_code = aws_api_gateway_method_response.post_courses.status_code

response_templates = {
  "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
}


  content_handling = "CONVERT_TO_TEXT"
}
# //----------------------------
# Додавання дозволу на виклик функції Lambda
resource "aws_lambda_permission" "api_gateway_invoke_post_courses" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.save_course_arn
  principal     = "apigateway.amazonaws.com"
}





# Resource for /courses/{id}
resource "aws_api_gateway_resource" "course_by_id" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.course_by_id.id
  http_method   = "GET"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.my_api.id
}

resource "aws_api_gateway_method_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = "200"

  response_models = { "application/json" = aws_api_gateway_model.my_api.name }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.get_one_course_invoke_arn
  
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}

request_templates = {
  "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
EOF
}

  content_handling = "CONVERT_TO_TEXT"
}



resource "aws_api_gateway_integration_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course.status_code

response_templates = {
  "application/json" = <<EOF
{
  "body" : $input.json('$')
}
EOF
}

  content_handling = "CONVERT_TO_TEXT"
}
# //----------------------------
# Додавання дозволу на виклик функції Lambda
resource "aws_lambda_permission" "api_gateway_invoke_get_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_one_course_arn
  principal     = "apigateway.amazonaws.com"
}



# #  METHOD PUT for /courses/{id}
# resource "aws_api_gateway_method" "course_by_id_put" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.course_by_id.id
#   http_method   = "PUT"
#   authorization = "NONE"
# }

# Створення моделі для валідації запиту
# resource "aws_api_gateway_model" "course_input_model" {
#   rest_api_id  = aws_api_gateway_rest_api.my_api.id
#   name         = "CourseInputModel"
#   content_type = "application/json"
#   schema = <<EOF
# {
#   "$schema": "http://json-schema.org/schema#",
#   "title": "CourseInputModel",
#   "type": "object",
#   "properties": {
#     "title": {"type": "string"},
#     "authorId": {"type": "string"},
#     "length": {"type": "string"},
#     "category": {"type": "string"}
#   },
#   "required": ["title", "authorId", "length", "category"]
# }
# EOF
# }

# # Прикріплення моделі до методу POST
# resource "aws_api_gateway_integration" "courses_post_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.courses.id
#   http_method             = aws_api_gateway_method.courses_post.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.save_course.arn}/invocations"
#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # Прикріплення моделі до методу PUT
# resource "aws_api_gateway_integration" "course_by_id_put_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.course_by_id.id
#   http_method             = aws_api_gateway_method.course_by_id.http_method
#   type = "PUT"
# }


# # Прикріплення моделі до методу PUT
# resource "aws_api_gateway_integration" "course_by_id_put_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.course_by_id.id
#   http_method             = aws_api_gateway_method.course_by_id_put.http_method
#   integration_http_method = "PUT"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.update_course.arn}/invocations"
#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # Прикріплення моделі до методу DELETE
# resource "aws_api_gateway_integration" "course_by_id_delete_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.course_by_id.id
#   http_method             = "DELETE"
#   integration_http_method = "DELETE"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.delete_course.arn}/invocations"
#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # Прикріплення моделі до методу GET
# resource "aws_api_gateway_integration" "course_by_id_get_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.course_by_id.id
#   http_method             = "GET"
#   integration_http_method = "GET"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.get_course.arn}/invocations"
#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }





// DEPLOYMENT

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.get_authors,
    # aws_api_gateway_integration.authors_options_integration, 
    aws_api_gateway_integration.get_courses,
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "dev"
}

# module "cors" {
#   source = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"
