resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_IDs" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_IDs"
  type  = "StringList" #we habe 2 subnets , so it is a list ["subnet1" , "subnet2"] , we convert this into subnet1 ,subnet2 using join by removing , from "module.vpc.public_subnet_IDs"(which was a list and now will be converted as a string)
  value = join (",", module.vpc.public_subnet_IDs)
}

resource "aws_ssm_parameter" "private_subnet_IDs" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_IDs"
  type  = "StringList" #we habe 2 subnets , so it is a list ["subnet1" , "subnet2"] , we convert this into subnet1 ,subnet2 using join by removing , from "module.vpc.public_subnet_IDs"(which was a list and now will be converted as a string)
  value = join (",", module.vpc.private_subnet_IDs)
}

resource "aws_ssm_parameter" "database_subnet_IDs" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_IDs"
  type  = "StringList" 
  value = join (",", module.vpc.database_subnet_IDs)
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}