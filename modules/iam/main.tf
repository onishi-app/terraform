#
# Locals 
#
locals {
  role_name   = format("%s-role-%s", var.prefix, var.subname)
  policy_name = format("%s-policy-%s", var.prefix, var.subname)
}

#
# IAM Role
#
data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      type        = var.assume_type
      identifiers = var.assume_identifiers
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns  = concat(var.managed_policy_arns, [aws_iam_policy.this.arn])
  max_session_duration = var.max_session_duration

  tags = {
    Name = local.role_name
  }
}

#
# IAM Policy
#
data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.policy_statement
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.condition
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    Name = local.policy_name
  }
}