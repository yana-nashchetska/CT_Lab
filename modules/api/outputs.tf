# output "get_all_authors_invoke_arn" {
#   value = aws_lambda_function.get_all_authors.invoke_arn
# }

output "aws_api_gateway_rest_api_my_api_execution_arn" {
  value = aws_api_gateway_rest_api.my_api.execution_arn
}