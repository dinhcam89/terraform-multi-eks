variable "project_name" {
  default = "eks-cicd"
}

variable "project_env" {
  default = "monitoring"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "private_subnets" {
  type = list(string)
  default = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
}