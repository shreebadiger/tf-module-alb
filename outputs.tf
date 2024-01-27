output "listener_arn" {
  value = aws_lb_listener.https.arn
}

output "alb_name" {
  value = aws_lb.main.dns_name
}