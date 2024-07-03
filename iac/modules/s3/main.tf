resource "aws_s3_bucket" "predictions" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.predictions.bucket
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.predictions.bucket}/*"
    }
  ]
}
POLICY
}

output "bucket_name" {
  value = aws_s3_bucket.predictions.bucket
}
}

