#
# common
#
variable "prefix" {
  type        = string
  description = "[システム名]-[環境]の形式の文字列。例：terra-stg"
}
variable "subname" {
  type        = string
  description = "リソースの役割。例：ec2-web01"
}

#
# aws_security_group
#
variable "description" {
  type        = string
  default     = ""
  description = "セキュリティグループの説明"
}
variable "vpc_id" {
  type        = string
  default     = null
  description = "セキュリティグループを作成するVPCのID。デフォルトはリージョンのデフォルトVPC"
}

#
# aws_security_group_rule
#
variable "rule_map" {
  type = map(object({
    type                     = string       # ingress or egress
    from_port                = number       # 開始ポート
    to_port                  = number       # 終了ポート
    protocol                 = string       # プロトコル
    cidr_blocks              = list(string) # IPv4 CIDRブロックのリスト
    ipv6_cidr_blocks         = list(string) # IPv6 CIDRブロックのリスト
    source_security_group_id = string       # 送信元セキュリティグループID
    description              = string       # ルールの説明
  }))
  default     = {}
  description = "セキュリティグループルールのマップ"
}
