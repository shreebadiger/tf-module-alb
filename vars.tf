variable "env" {}
variable "type" {}
variable "internal" {}
variable "vpc_id" {}
variable "sg_cidrs" {}
variable "tags" {}
variable "subnets" {}
variable "route53_zone_id" {}
variable "certificate_arn" {}
variable "dns_name" {
  default = null
}