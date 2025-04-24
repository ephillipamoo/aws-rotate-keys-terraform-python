provider "aws" {
  region = var.region
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_rotate_keys_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "rotate_keys_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "iam:ListAccessKeys",
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:PutSecretValue"
        ],
        Effect = "Allow",
        Resource = var.secrets_manager_arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/rotate_keys.py"
  output_path = "${path.module}/../lambda/rotate_keys.zip"
}

resource "aws_lambda_function" "rotate_keys" {
  function_name = "rotate_iam_keys"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "rotate_keys.lambda_handler"
  runtime       = "python3.11"
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      IAM_USERNAME         = var.iam_username
      SECRETS_MANAGER_ARN  = var.secrets_manager_arn
    }
  }
}
