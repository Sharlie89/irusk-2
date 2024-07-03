resource "aws_lambda_function" "ml_prediction" {
  filename         = "${path.module}/../../ml_deployment/lambda_function_payload.zip"
  function_name    = "ml_prediction_function"
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../../ml_deployment/lambda_function_payload.zip")
  runtime          = "python3.8"

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.ml_prediction.arn
}

