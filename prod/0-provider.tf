provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "prometheus_operator" {
  name             = "prometheus-operator"
  repository       = "https://charts.helm.sh/stable"
  chart            = "kube-prometheus-stack"
  version          = "54.1.0"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/values.yaml")
  ]
}



