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


variable "vpn_tags" {
    default = {
        Component = "vpn"
    }
}