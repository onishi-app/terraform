#
# ログ格納用S3バケット
#
module "s3_logs" {
  source = "./modules/storage/s3"

  # common
  prefix  = local.prefix
  subname = "logs"

  # Bucket Policy
  policy_statement = [
    {
      principals = {
        type        = "Service"
        identifiers = ["logging.s3.amazonaws.com"]
      }
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["arn:aws:s3:::${local.prefix}-s3-logs/*"]
      condition = [
        {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = [data.aws_caller_identity.self.account_id]
        }
      ]
    }
  ]
}

#
# サンプルS3バケット
#
module "s3_sample_bucket" {
  source = "./modules/storage/s3"

  # common
  prefix  = local.prefix
  subname = "sample-bucket"

  # Transfer Acceleration
  accelerate_status = "Enabled"

  # Bucket Ownership
  object_ownership = "ObjectWriter"

  # Public Access
  public_access_block_config = {
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false
  }

  # Logging
  logging_enabled = true
  target_bucket   = module.s3_logs.bucket_id
  target_prefix   = "sample-bucket/"

  # SSE Encrypt
  sse_algorithm     = "aws:kms"
  kms_master_key_id = "aws/s3"

  # Versioning
  versioning_status = "Enabled"

  # Lifecycle Rule
  rule_created = true
  rule_id      = "sample-lifecycle-rule"
  filter = [{
    and                      = true
    object_size_greater_than = null
    object_size_less_than    = null
    prefix                   = "error/"
  }]
  transition = [{
    date          = null
    days          = 2
    storage_class = "GLACIER"
  }]
  expiration = [{
    date                         = null
    days                         = 4
    expired_object_delete_marker = false
  }]
  # non_ver_transition = [{
  #   newer_noncurrent_versions = 6
  #   noncurrent_days           = 10
  #   storage_class             = "GLACIER"
  # }]
  non_ver_expiration = [{
    newer_noncurrent_versions = 4
    noncurrent_days           = 12
  }]
}