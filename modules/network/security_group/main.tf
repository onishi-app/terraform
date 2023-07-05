# SecurityGroup module (v5.3.0)

#
# Locals
#
locals {
  sg_name = format("%s-sg-%s", var.prefix, var.subname)
}

#
# Security Group
#
resource "aws_security_group" "this" {
  name        = local.sg_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = local.sg_name
  }
}

#
# Security Group Rule
#
resource "aws_security_group_rule" "this" {
  for_each = var.rule_map

  security_group_id        = aws_security_group.this.id
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
}