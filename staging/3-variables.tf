variable "project_name" {
  default = "eks-cicd"
}

variable "project_env" {
  default = "staging"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "cidr" {
  type = string
  default = "10.10.0.0/16"
}

variable "private_subnets" {
  type = list(string)
  default = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]
}