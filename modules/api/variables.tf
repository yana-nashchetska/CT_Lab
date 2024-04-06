variable "region" {
  type = string
}

variable "myprofile" {
  type = string
}

# variable "name" {
#   type = string
# }

variable "get_all_authors_invoke_arn" {
  # value = aws_lambda_function.lambda.get_all_authors.invoke_arn
  type = string
}

variable "get_all_courses_invoke_arn" {
  # value = aws_lambda_function.lambda.get_all_authors.invoke_arn
  type = string
}


variable "get_all_authors_arn" {
  type = string
}

variable "save_course_arn" {
  type = string
}

variable "save_course_invoke_arn" {
  type = string
}

# variable "update_course_arn" {
#   type = string
# }

variable "get_all_courses_arn" {
  type = string
}

# variable "get_one_course_arn" {
#   type = string
# }

# variable "delete_course_arn" {
#   type = string
# }