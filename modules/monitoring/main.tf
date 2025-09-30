resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# === CloudTrail ===
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "ct-logs-${var.env}-${random_id.bucket_suffix.hex}"
  tags = {
    Environment = var.env
    Purpose     = "cloudtrail-logs"
  }
}
resource "aws_s3_bucket_versioning" "cloudtrail_logs_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_sse" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
      # or for KMS: kms_master_key_id = aws_kms_key.mykey.arn
    }
  }
}
# ✅ (Optional) Bucket Policy to Allow CloudTrail to Write Logs
resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


##############################
# CloudTrail
##############################

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.project_name}-${var.env}"
  retention_in_days = 30
}
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-${var.env}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  # is_multi_region_trail         = true
  enable_logging                = true

  cloud_watch_logs_group_arn  = "${aws_cloudwatch_log_group.cloudtrail.arn}:*" # Required for CW integration
  cloud_watch_logs_role_arn   = var.cloudtrail_to_cw_role_arn

  depends_on = [aws_cloudwatch_log_group.cloudtrail]
}
##############################
# VPC Flow Logs
##############################

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc-flow-log/${var.project_name}-${var.env}"
  retention_in_days = 30
}

resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = var.flow_logs_role_arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
  log_destination_type = "cloud-watch-logs"
}
