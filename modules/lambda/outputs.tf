output "get_all_authors_arn" {
  value = aws_lambda_function.get_all_authors.arn
}

output "save_course_arn" {
  value = aws_lambda_function.save_course.arn
}

output "update_course_arn" {
  value = aws_lambda_function.update_course.arn
}