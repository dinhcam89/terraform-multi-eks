module "vpc" {
  source = "../modules/vpc"

  project_name = var.project_name
  project_env  = var.project_env
  region       = var.region

  cidr            = var.cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}