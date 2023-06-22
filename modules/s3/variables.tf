#
# common
#
variable "prefix" {
  type        = string
  description = "[システム名]-[環境]の形式の文字列。例：terra-stg"
}
variable "subname" {
  type        = string
  description = "リソースの役割。例：db-logs"
}

#
# aws_s3_bucket
#
variable "force_destroy" {
  type        = bool
  default     = true
  description = "Bucket削除時に全てのオブジェクトを削除して、Bucketも削除する場合はtrue（ロックされたオブジェクトを含む）"
}
variable "object_lock_enabled" {
  type        = bool
  default     = false
  description = "オブジェクトロック設定の有効可否"
}

#
# aws_s3_bucket_accelerate_configuration
#
variable "accelerate_status" {
  type        = string
  default     = "Suspended"
  description = "S3 Transfer Accelerationの有効可否。Enabled or Suspended"
}

#
# aws_s3_bucket_ownership_controls
#
variable "object_ownership" {
  type        = string
  default     = "BucketOwnerEnforced"
  description = "オブジェクトの所有権。BucketOwnerPreferred or ObjectWriter, BucketOwnerEnforced"
}

#
# aws_s3_bucket_public_access_block
#
variable "public_access_block_config" {
  type = object({
    block_public_acls       = bool # 新しいACLを介して付与されたアクセスのブロック
    ignore_public_acls      = bool # 任意のACLを介して付与されたアクセスのブロック
    block_public_policy     = bool # 新しいポリシーを介して付与されたアクセスのブロック
    restrict_public_buckets = bool # 任意のポリシーを介して付与されたアクセスのブロック
  })
  default = {
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  }
  description = "パブリック アクセスのブロック設定"
}

#
# aws_s3_bucket_logging
#
variable "logging_enabled" {
  type        = bool
  default     = false
  description = "S3アクセスログ設定の有効可否"
}
variable "target_bucket" {
  type        = string
  default     = null
  description = "アクセスログを保存させるバケット"
}
variable "target_prefix" {
  type        = string
  default     = null
  description = "オブジェクトのプレフィックス"
}

#
# aws_s3_bucket_server_side_encryption_configuration
#
variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "サーバーサイド暗号化アルゴリズム。AES256 or aws:kms"
}
variable "kms_master_key_id" {
  type        = string
  default     = null
  description = "SSE-KMS暗号化に使用するAWS KMSマスターキーID"
}
variable "bucket_key_enabled" {
  type        = bool
  default     = false
  description = "SSE-KMSにAmazon S3バケットキーを使用するかどうか"
}

#
# aws_s3_bucket_versioning
#
variable "versioning_status" {
  type        = string
  default     = "Disabled"
  description = "バケットのバージョン管理状態。Enabled or Suspended, Disabled"
}
variable "mfa_delete" {
  type        = string
  default     = null
  description = "MFA削除の有効可否（バージョニング有効時に指定）"
}
variable "mfa" {
  type        = string
  default     = null
  description = "認証デバイスのシリアル番号、スペース、認証デバイスに表示される値（バージョニング有効時に指定）"
}

#
# aws_s3_bucket_lifecycle_configuration
#
variable "rule_created" {
  type        = bool
  default     = false
  description = "ライフサイクルルール作成の有効可否"
}
variable "rule_id" {
  type        = string
  default     = ""
  description = "ライフサイクルルールの一意な識別子"
}
variable "rule_status" {
  type        = string
  default     = "Enabled"
  description = "ライフサイクルルールの有効可否"
}
variable "filter" {
  type = list(object({
    and                      = bool   # AND条件適用の有効可否
    object_size_greater_than = number # ルールが適用されるオブジェクトの最小サイズ
    object_size_less_than    = number # ルールが適用されるオブジェクトの最大サイズ
    prefix                   = string # ルールが適用される1つまたは複数のオブジェクトを識別するプレフィックス
  }))
  default     = []
  description = "ライフサイクルルールのフィルター設定"
}
variable "transition" {
  type = list(object({
    date          = number # 指定されたストレージクラスに移動する日。日付の値はRFC3339形式
    days          = number # 指定されたストレージクラスに移動するまでの日数。正の整数のみ指定可能
    storage_class = string # 移動先のストレージクラス
  }))
  default     = []
  description = "現行バージョンのストレージ移動アクション"
}
variable "expiration" {
  type = list(object({
    date                         = number # 指定されたストレージクラスに移動する日。日付の値はRFC3339形式
    days                         = number # 指定されたストレージクラスに移動するまでの日数。正の整数のみ指定可能
    expired_object_delete_marker = bool   # 現行でないバージョンの削除マーカーを削除
  }))
  default     = []
  description = "現行バージョンの削除アクション"
}
variable "non_ver_transition" {
  type = list(object({
    newer_noncurrent_versions = number # 保持する非現行バージョンの個数
    noncurrent_days           = number # 指定されたストレージクラスに移動するまでの日数。正の整数のみ指定可能
    storage_class             = string # 移動先のストレージクラス
  }))
  default     = []
  description = "非現行バージョンのストレージ移動アクション"
}
variable "non_ver_expiration" {
  type = list(object({
    newer_noncurrent_versions = number # 保持する非現行バージョンの個数
    noncurrent_days           = number # 削除されるまでの日数
  }))
  default     = []
  description = "非現行バージョンの削除アクション"
}