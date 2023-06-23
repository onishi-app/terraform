locals {
  prefix = format("%s-%s", var.system, var.env)
}
variable "system" {
  type        = string
  default     = "terra"
  description = "システム名"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "環境名"
}