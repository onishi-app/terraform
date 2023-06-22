# S3 Bucket module (v5.3.0)

#
# Locals
#
locals {
  bucket_name          = format("%s-s3-%s", var.prefix, var.subname)
  lifecycle_and_filter = try(var.filter.and ? var.filter : [], [])
}


#
# S3 Bucket
#
resource "aws_s3_bucket" "this" {
  bucket              = local.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags = {
    Name = local.bucket_name
  }
}

#
# S3 Transfer Acceleration
#
resource "aws_s3_bucket_accelerate_configuration" "this" {
  depends_on = [aws_s3_bucket.this]

  bucket = aws_s3_bucket.this.id
  status = var.accelerate_status
}

#
# S3 Bucket Ownership
#
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.object_ownership
  }
}

#
# S3 Public Access Block
#
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block_config.block_public_acls
  ignore_public_acls      = var.public_access_block_config.ignore_public_acls
  block_public_policy     = var.public_access_block_config.block_public_policy
  restrict_public_buckets = var.public_access_block_config.restrict_public_buckets
}

#
# S3 Logging
#
resource "aws_s3_bucket_logging" "this" {
  count = var.logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
}

#
# S3 Server Side Encrypt
#
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

#
# S3 Versioning
#
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status     = var.versioning_status
    mfa_delete = var.mfa_delete
  }
  mfa = var.mfa
}

#
# Lifecycle Rule
#
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.rule_created ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = var.rule_id
    status = var.rule_status

    # AND条件のフィルター
    dynamic "filter" {
      for_each = length(local.lifecycle_and_filter) > 0 ? local.lifecycle_and_filter : []
      content {
        dynamic "and" {
          for_each = local.lifecycle_and_filter
          content {
            object_size_greater_than = and.value.object_size_greater_than
            object_size_less_than    = and.value.object_size_less_than
            prefix                   = and.value.prefix
          }
        }
      }
    }

    # OR条件のフィルター
    dynamic "filter" {
      for_each = length(local.lifecycle_and_filter) == 0 ? var.filter : []
      content {
        object_size_greater_than = filter.value.object_size_greater_than
        object_size_less_than    = filter.value.object_size_less_than
        prefix                   = filter.value.prefix
      }
    }

    dynamic "transition" {
      for_each = var.transition
      content {
        date          = transition.value.date
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

    dynamic "expiration" {
      for_each = var.expiration
      content {
        date                         = expiration.value.date
        days                         = expiration.value.days
        expired_object_delete_marker = expiration.value.expired_object_delete_marker
      }
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.non_ver_transition
      content {
        newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
        noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
        storage_class             = noncurrent_version_transition.value.storage_class
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.non_ver_expiration
      content {
        newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
        noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
      }
    }
  }
}