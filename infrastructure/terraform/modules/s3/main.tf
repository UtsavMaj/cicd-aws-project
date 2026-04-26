# modules/s3/main.tf
# S3 bucket and DynamoDB table were pre-created manually as Terraform backend
# We reference them here as data sources only

data "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
}

data "aws_dynamodb_table" "tf_locks" {
  name = "terraform-locks"
}