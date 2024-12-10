variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "dev"
        Terraform = true
    }
}


variable "rds_tags" {
    default = {
        Component = "mysql"
    }
}

variable "database_subnet_cidrs" {
    default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "zone_name" {
    default = "yashd.icu"
}