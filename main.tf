resource "aws_security_group" "main" {
  name        = local.name
  description = local.name
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidrs
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidrs
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = local.name})

}

resource "aws_lb" "main" {
  name               =  local.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets
  tags = merge(var.tags, {Name =  local.name})
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ERROR"
      status_code  = "500"
    }
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
 
}

# resource "aws_route53_record" "main" {
#   name    = var.dns_name == null ? "${var.component}-${var.env}" : var.dns_name
#   type    = "CNAME"
#   ttl     = 30
#   zone_id =var.route53_zone_id
#   records = [aws_lb.main.dns_name]
  
#   }

#   resource "aws_wafv2_web_acl" "main" {
#     count         = var.enable_https ? 1 : 0
#     name          = "${var.component}-${var.env}"
#     scope         = "REGIONAL"
#     tags          = {}
#     tags_all      = {}
#     token_domains = []

#     default_action {
#         allow {}
#     }

#     rule {
#         name     = "block_curl"
#         priority = 0

#         action {
#             block {
#             }
#         }

#         statement {
#             byte_match_statement {
#                 positional_constraint = "STARTS_WITH"
#                 search_string         = "curl"

#                 field_to_match {
#                     single_header {
#                         name = "user-agent"
#                     }
#                 }

#                 text_transformation {
#                     priority = 0
#                     type     = "NONE"
#                 }
#             }
#         }

#         visibility_config {
#             cloudwatch_metrics_enabled = true
#             metric_name                = "block_curl"
#             sampled_requests_enabled   = true
#         }
#     }

#     visibility_config {
#         cloudwatch_metrics_enabled = true
#         metric_name                = "${var.component}-${var.env}"
#         sampled_requests_enabled   = true
#     }
# }

# resource "aws_wafv2_web_acl_association" "main" {
#   count             = var.enable_https ? 1 : 0
#   resource_arn      = aws_lb.main.arn
#   web_acl_arn       = aws_wafv2_web_acl.main[0].arn
# }
