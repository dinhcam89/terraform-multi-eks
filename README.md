# Terraform Multi EKS

This repository provides Terraform configurations to deploy two separate EKS (Elastic Kubernetes Service) clusters in AWS. These configurations allow for the creation of two distinct environments (e.g., development and production) with their own EKS clusters.


- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Repository Structure

```plaintext
terraform-multi-eks/
├── environments/
│   ├── development/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── modules/
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
