output "bucket_name" {
  value = data.aws_s3_bucket.tf_state.bucket
}

output "dynamodb_table_name" {
  value = data.aws_dynamodb_table.tf_locks.name
}