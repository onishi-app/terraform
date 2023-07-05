#
# サンプルIAMロール＆ポリシー
#
module "sample_iam_1" {
  source = "./modules/iam"

  prefix  = local.prefix
  subname = "sample-1"

  # IAM Role
  role_description = "sample iam role 1"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
  assume_type        = "Service"
  assume_identifiers = ["ec2.amazonaws.com"]

  # IAM Policy
  policy_description = "sample iam policy 1"
  policy_statement = [
    {
      effect    = "Allow"
      actions   = ["s3:*"]
      resources = [module.s3_logs.bucket_arn]
      condition = [
        {
          test     = "NumericLessThanEquals"
          variable = "aws:MultiFactorAuthAge"
          values   = ["3600"]
        }
      ]
      # condition を設定しない場合は condition = []
    }
  ]
}