module "vpc" {
    # source = "../terraform-vpc-root-module" (below we use actual git module)(ref=main , since that's where VPC module script resides)
    source = "git::https://github.com/YasaswiniDwaram-git/terraform-vpc-root-module.git?ref=main"
    project_name = var.project_name
    vpc_cidr = var.vpc_cidr
    environment = var.environment
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = true
    
}