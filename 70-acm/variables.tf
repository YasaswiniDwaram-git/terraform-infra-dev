variable "zone_name" {
    default = "yashd.icu"
}

variable "zone_id" {
    default = "Z00909132T1JJDSG4SBDV"
}

variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "dev"
        Terraform = true
    }
}

variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}