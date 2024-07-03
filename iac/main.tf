provider "aws" {
  region = "us-west-2"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

module "iam" {
  source = "./modules/iam"
  bucket_name = module.s3.bucket_name
}

module "lambda" {
  source = "./modules/lambda"
  bucket_name = module.s3.bucket_name
  role_arn = module.iam.role_arn
}

module "apigateway" {
  source = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_function_arn
}

module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id = module.apigateway.api_id
  stage = module.apigateway.api_stage
  domain_name = module.route53.api_domain_name
}

output "api_url" {
  value = "https://${module.route53.api_domain_name}"
}

