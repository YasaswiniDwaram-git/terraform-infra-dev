data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "public_subnet_IDs" {
  name = "/${var.project_name}/${var.environment}/public_subnet_IDs"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "https_web_alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/https_web_alb_listener_arn"
}

data "aws_ami" "devopspractice"{
    most_recent      = true
    owners           = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}