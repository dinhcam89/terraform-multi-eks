module "vpc" {
  # https://github.com/terraform-aws-modules/terraform-aws-vpc
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  cidr                   = var.cidr
  azs                    = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  # enable_dns_hostnames   = false
  # enable_dns_support     = false

  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }
}

resource "aws_security_group" "vpc_sg" {
  name        = "${var.project_name}-vpc-sg"
  description = "Security group for ${var.project_name} VPC"
  vpc_id      = module.vpc.vpc_id

  # ingress {
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   description = "PostgreSQL access"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    description     = "Allow outbound TCP traffic"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "udp"
    description     = "Allow outbound UDP traffic"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }
}

