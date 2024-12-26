

resource "aws_ssm_parameter" "https_web_alb_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/https_web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}
