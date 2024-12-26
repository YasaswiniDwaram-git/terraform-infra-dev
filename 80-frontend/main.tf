module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = local.resource_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id # we use public subnet IDs here for bastion (take it from VPC module output) check if below is there in VPC module output , in 10-VPC it has to be stored to parameters , so we can use it here
#   output "public_subnet_IDs" {
#     value = aws_subnet.public[*].id
  tags = merge (
    var.common_tags,
    var.frontend_tags,
    {
        Name = local.resource_name
    }
  )
} 

resource "null_resource" "frontend" {
  # Changes everytime the frontend instance id changes
  triggers = {
    instance_id = module.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.frontend.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.frontend_tags.Component} ${var.environment}"
    ]
  }   
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend.id
  state       = "stopped"
  depends_on = [null_resource.frontend]
}


resource "aws_ami_from_instance" "frontend"{
  name               = local.resource_name
  source_instance_id = module.frontend.id
  depends_on = [aws_ec2_instance_state.frontend]
}

resource "null_resource" "backend_delete" {
  # Changes everytime the frontend instance id changes
  triggers = {
    instance_id = module.frontend.id
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
  }   
  depends_on = [aws_ami_from_instance.frontend]
}

resource "aws_lb_target_group" "frontend" {
  name        = local.resource_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  health_check {
    interval = 5
    matcher = "200-299"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 4
    path = "/"
    port = 80
    protocol = "HTTP"
  }
}

resource "aws_launch_template" "frontend" {
  name = local.resource_name
  image_id = aws_ami_from_instance.frontend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }

}

resource "aws_autoscaling_group" "frontend" {
  name                 = local.resource_name
  max_size             = 5
  min_size             = 2
  health_check_grace_period = 60
  target_group_arns = [aws_lb_target_group.frontend.arn]
  health_check_type         = "ELB"
  desired_capacity          = 2 #starting how many u want
  vpc_zone_identifier  = [local.public_subnet_id]
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  

  tag {
    key                 = "project"
    value               = "expense"
    propagate_at_launch = false
  }
  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = false
  }
  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "frontend" {
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = local.web_alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["${var.project_name}-${var.environment}.${var.zone_name}"]
    }
  }
}
