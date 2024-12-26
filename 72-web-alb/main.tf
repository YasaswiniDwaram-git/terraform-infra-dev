module "web_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = local.resource_name #expense-dev-app-alb
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_id
  internal = true
  create_security_group = false
  enable_deletion_protection = false

  security_groups = [local.web_alb_sg_id]

 
 tags = merge (
  var.common_tags,
  var.web_alb_tags
 )
}


resource "aws_lb_listener" "http" {
  load_balancer_arn =  module.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "THis IS APP ALB using HTTP response"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "THIS IS WEB ALB using HTTPS response"
      status_code  = "200"
    }
}
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name
  

  records = [
    {
      name    = "${var.project_name}-${var.environment}"
      type    = "A"
      alias   = {
        name    = module.web_alb.dns_name
        zone_id = module.web_alb.zone_id
        
      }
      allow_overwrite = true
    },
    
  ]
}