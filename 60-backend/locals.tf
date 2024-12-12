locals {
    resource_name = "${var.project_name}-${var.environment}-backend"
    backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value
    private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_IDs.value)[0]
    ami_id = data.aws_ami.devopspractice.id
}