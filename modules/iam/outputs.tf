output "get_all_authors_role_arn" {
  value = aws_iam_role.get_all_authors_lambda_role.arn
}

output "save_course_role_arn" {
  value = aws_iam_role.save_course_lambda_role.arn
}

output "update_course_role_arn" {
  value = aws_iam_role.update_course_lambda_role.arn
}