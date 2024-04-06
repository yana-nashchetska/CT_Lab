#  resource "aws_api_gateway_rest_api" "my_api" {
#   name = "my-api"
#   description = "My million and first attempt to create an API Gateway"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "all_authors" { // root
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
#   path_part = "authors"
# }

# // 2. 

# resource "aws_api_gateway_method" "get_authors" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "get_authors" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = aws_api_gateway_method.get_authors.http_method
#   integration_http_method = "POST"
#   type = "AWS"
#   # uri = "arn:aws:apigateway:eu-central-1:states:action/StartExecution"
#   uri = var.get_all_authors_invoke_arn
  
#   request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
#    request_templates       = {
#     "application/xml" = <<EOF
#   {
#      "body" : 
#     {
#       "id": "$input.params('id')",
#       "title" : "$input.json('$.title')",
#       "authorId" : "$input.json('$.authorId')",
#       "length" : "$input.json('$.length')",
#       "category" : "$input.json('$.category')",
#       "watchHref" : "$input.json('$.watchHref')"
#     }
#   }
#   EOF
#   }
#   content_handling = "CONVERT_TO_TEXT"
# }

# resource "aws_api_gateway_method_response" "get_authors" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = aws_api_gateway_method.get_authors.http_method
#   status_code = "200"

#   response_models = { "application/json" = "Empty" }
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin" = false
#   }
# }

# resource "aws_api_gateway_integration_response" "get_authors" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = aws_api_gateway_method.get_authors.http_method
#   status_code = aws_api_gateway_method_response.get_authors.status_code


#   //added cors:
#   response_parameters ={
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }
#   //

#   depends_on = [
#     aws_api_gateway_method.get_authors,
#     aws_api_gateway_integration.get_authors
#   ]
# }

# // options staff:
# //options
# //options
# resource "aws_api_gateway_method" "options" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = "OPTIONS"
#     authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "options_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api.id
#   resource_id             = aws_api_gateway_resource.all_authors.id
#   http_method             = aws_api_gateway_method.options.http_method
#   integration_http_method = "OPTIONS"
#   type                    = "AWS"
#   request_templates = {
#     "application/json" = "{\"statusCode\": 200}"
#   }

#   uri = var.get_all_authors_invoke_arn
# }

# resource "aws_api_gateway_method_response" "options_response" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = aws_api_gateway_method.options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin"  = true
#   }
# }

# resource "aws_api_gateway_integration_response" "options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   resource_id = aws_api_gateway_resource.all_authors.id
#   http_method = aws_api_gateway_method.options.http_method
#   status_code = aws_api_gateway_method_response.options_response.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [
#     aws_api_gateway_method.options,
#     aws_api_gateway_integration.options_integration,
#   ]
# }
# // the end of options

# // permission

# resource "aws_lambda_permission" "lambda_permission" {
#   statement_id  = "AllowMyAPIInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = var.get_all_authors_arn
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*"
# }



// This code suppose to work but...

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my api"
  description = "API example with CORS."
}

# Створення resourse 
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
# //----------------------------
# Додавання дозволу на виклик функції Lambda
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_authors_arn
  principal     = "apigateway.amazonaws.com"
}

# Додавання методу OPTIONS для /authors
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




































# resource "aws_api_gateway_resource" "courses" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
#   path_part   = "courses"
# }


# # Створення ресурсу /courses/{id}
# resource "aws_api_gateway_resource" "course_by_id" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   parent_id   = aws_api_gateway_resource.courses.id
#   path_part   = "{id}"
# }

# # Створення методу GET для /authors
# resource "aws_api_gateway_method" "authors_get" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.authors.id
#   http_method   = "GET"
#   authorization = "NONE"
# }




# # Створення методу OPTIONS для /authors
# resource "aws_api_gateway_method" "authors_options" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.authors.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }


# Створення методу GET для /courses
# resource "aws_api_gateway_method" "courses_post" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.courses.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# # Створення методу PUT для /courses/{id}
# resource "aws_api_gateway_method" "course_by_id_put" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api.id
#   resource_id   = aws_api_gateway_resource.course_by_id.id
#   http_method   = "PUT"
#   authorization = "NONE"
# }

# # Створення моделі для валідації запиту
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
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "dev"
}

# module "cors" {
#   source = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"
