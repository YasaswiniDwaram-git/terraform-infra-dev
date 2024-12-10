module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = local.resource_name

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id # we use public subnet IDs here for bastion (take it from VPC module output) check if below is there in VPC module output , in 10-VPC it has to be stored to parameters , so we can use it here
#   output "public_subnet_IDs" {
#     value = aws_subnet.public[*].id
  tags = merge (
    var.common_tags,
    var.bastion_tags,
    {
        Name = local.resource_name
    }
  )
} 