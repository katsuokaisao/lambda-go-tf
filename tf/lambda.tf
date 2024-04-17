resource "aws_lambda_function" "lambda_go" {
  function_name = "lambda-go"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.go_lambda.repository_url}:latest"
  role          = aws_iam_role.go_lambda.arn
  publish       = true

  memory_size = 128
  timeout     = 28

  lifecycle {
    ignore_changes = [
      image_uri, last_modified
    ]
  }
}

resource "aws_cloudwatch_log_group" "lambda_go" {
  name              = "/aws/lambda/lambda-go"
  retention_in_days = 7
}

resource "aws_iam_role" "go_lambda" {
  name               = "go-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "go_lambda" {
  name   = "go-lambda-policy"
  policy = data.aws_iam_policy_document.go_lambda.json
}

data "aws_iam_policy_document" "go_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "go_lambda" {
  role       = aws_iam_role.go_lambda.name
  policy_arn = aws_iam_policy.go_lambda.arn
}
