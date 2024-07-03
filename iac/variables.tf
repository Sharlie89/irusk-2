variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "ml-results"
}

variable "domain_name" {
  description = "The domain name for the API"
  type        = string
  default     = "irusk-mlpredictions.com"
}

