#
# common
#
variable "prefix" {}
variable "subname" {}

#
# aws_iam_role
#
variable "role_description" {
  type        = string
  default     = null
  description = "IAMロールの説明"
}
variable "max_session_duration" {
  type        = number
  default     = 3600
  description = "指定されたロールに設定する最大セッション時間（秒）"
}
variable "managed_policy_arns" {
  type        = list(string)
  default     = []
  description = "マネージドポリシーのARNリスト"
}
variable "assume_type" {
  type        = string
  description = "プリンシパルのタイプ"
}
variable "assume_identifiers" {
  type        = list(string)
  description = "プリンシパルの識別子のリスト"
}

#
# aws_iam_policy
#
variable "policy_description" {
  type        = string
  default     = ""
  description = "ポリシーの説明"
}
variable "policy_statement" {
  type = list(object({
    effect    = string       # Allow もしくは Deny
    actions   = list(string) # 許可 もしくは 拒否するアクションのリスト
    resources = list(string) # 対称のリソースのリスト。バケットARN以降の文字列を指定。
    condition = list(object({
      test     = string       # 評価する IAM 条件演算子の名前
      variable = string       # 条件を評価する値
      values   = list(string) # 条件を適用するコンテキスト変数の名前
    }))
  }))
  default     = []
  description = "IAMポリシーステートメントのリスト"
}