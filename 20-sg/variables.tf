variable "mysql_sg_tags" {
    default = {
        Component = "mysql"
    }
}

variable "backend_sg_tags" {
    default = {
        Component = "backend"
    }
}

variable "bastion_sg_tags" {
    default = {
        Component = "bastion"
    }
}

variable "ansible_sg_tags" {
    default = {
        Component = "ansible"
    }
}
variable "vpn_sg_tags" {
    default = {
        Component = "vpn"
    }
}




variable "frontend_sg_tags" {
    default = {
        Component = "frontend"
    }
}

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

variable "app_alb_sg_tags" {
    default = {
        Component = "app_alb"
    }
}

variable "web_alb_sg_tags" {
    default = {
        Component = "web_alb"
    }
}

