module "labels" {
  source  = "cloudposse/label/null"
  name    = var.name
}

resource "aws_iam_policy" "get_all_authors_policy" {
  name        = "get_all_authors_policy" 
  policy      = data.aws_iam_policy_document.get-all-authors.json
}

data "aws_iam_policy_document" "get-all-authors" {
    statement {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "dynamodb:Scan"
      ]
      resources = [
        "*", 
        "${var.dynamodb_authors_arn}/*"
      ]
    }
}

resource "aws_iam_role" "get_all_authors_lambda_role" {
  name = "get-all-authors-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_lambda" {
  policy_arn = aws_iam_policy.get_all_authors_policy.arn
  role       = aws_iam_role.get_all_authors_lambda_role.name
}
