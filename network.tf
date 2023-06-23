#
# サンプル セキュリティグループ１
#
module "sample_sg_1" {
  source = "./modules/security_group"

  prefix  = local.prefix
  subname = "sample-sg-1"

  # Security Group
  description = "sample security group 1"

  # security Group Rule
  rule_map = {
    http = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
  }
}

#
# サンプル セキュリティグループ２
#
module "sample_sg_2" {
  source = "./modules/security_group"

  prefix  = local.prefix
  subname = "sample-sg-2"

  # Security Group
  description = "sample security group 2"

  # Security Group Rule
  rule_map = {
    from_sample = {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.sample_sg_1.sg_id
      description              = "allow all traffic from ${module.sample_sg_1.sg_name}"
    }
    to_sample = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "TCP"
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.sample_sg_1.sg_id
      description              = "allow tcp to ${module.sample_sg_1.sg_name}"
    }
  }
}