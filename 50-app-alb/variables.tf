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

variable "zone_name" {
    default = "yashd.icu"
}

variable "app_alb_tags" {
    default = {
        Component = "app_alb"
    }
}