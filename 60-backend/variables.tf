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


variable "backend_tags" {
    default = {
        Component = "backend"
    }
}

variable "zone_name" {
    default = "yashd.icu"
}