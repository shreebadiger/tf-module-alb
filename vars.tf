variable "env" {}
variable "type" {}
variable "internal" {}
variable "vpc_id" {}
variable "sg_cidrs" {}
variable "tags" {}
variable "subnets" {}
variable "route53_zone_id" {}
variable "enable_https" {}
variable "certificate_arn" {}
variable "ingress_ports" {}
variable "dns_name" {
  default = null
}