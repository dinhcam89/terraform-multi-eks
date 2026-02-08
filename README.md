# Multi-Environment Terraform EKS Deployment

A production-ready Terraform infrastructure-as-code (IaC) project for deploying AWS EKS (Elastic Kubernetes Service) clusters with VPC networking across multiple environments (staging and production).

## 📋 Project Overview

This project provides a modular, reusable Terraform setup to deploy:
- **VPC Infrastructure**: Multi-AZ VPC with public/private subnets and NAT gateway
- **EKS Clusters**: Managed Kubernetes clusters with auto-scaling node groups
- **Multi-Environment Support**: Separate configurations for staging and production environments
- **CI/CD Validation**: Automated validation pipeline via GitHub Actions

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Account (ap-southeast-1)         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────────┐      │
│  │          Staging Environment                 │      │
│  │  CIDR: 10.10.0.0/16 (3 AZs)                 │      │
│  │  ├─ VPC + Public/Private Subnets            │      │
│  │  ├─ NAT Gateway                              │      │
│  │  └─ EKS Cluster (t2.medium, 3 nodes)        │      │
│  └─────────────────────────────────────────────┘      │
│                                                         │
│  ┌─────────────────────────────────────────────┐      │
│  │          Production Environment              │      │
│  │  CIDR: 172.10.0.0/16 (3 AZs)                │      │
│  │  ├─ VPC + Public/Private Subnets            │      │
│  │  ├─ NAT Gateway                              │      │
│  │  └─ EKS Cluster (t2.medium, 3 nodes)        │      │
│  └─────────────────────────────────────────────┘      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 📁 Directory Structure

```
.
├── modules/                    # Reusable Terraform modules
│   ├── vpc/                    # VPC module
│   │   ├── 0-main.tf          # VPC, subnets, NAT gateway
│   │   ├── 1-variables.tf     # Input variables
│   │   ├── 2-data.tf          # Availability zones data source
│   │   └── 3-outputs.tf       # VPC outputs (IDs, subnets)
│   │
│   └── eks/                    # EKS module
│       ├── 0-main.tf          # EKS cluster and node groups
│       ├── 1-variables.tf     # Input variables
│       └── 2-outputs.tf       # Cluster outputs (ID, endpoint)
│
├── staging/                    # Staging environment
│   ├── 0-provider.tf          # AWS provider configuration
│   ├── 1-vpc.tf               # VPC module instantiation
│   ├── 2-eks.tf               # EKS module instantiation
│   ├── 3-variables.tf         # Environment variables
│   ├── 4-output.tf            # Environment outputs
│   ├── terraform.tfstate      # Current state (committed for reference)
│   └── terraform.tfstate.backup
│
├── prod/                      # Production environment
│   ├── 0-provider.tf          # AWS provider configuration
│   ├── 1-vpc.tf               # VPC module instantiation
│   ├── 2-eks.tf               # EKS module instantiation
│   ├── 3-variables.tf         # Environment variables
│   ├── 4-output.tf            # Environment outputs
│   ├── terraform.tfstate      # Current state (committed for reference)
│   └── terraform.tfstate.backup
│
├── .github/
│   └── workflows/
│       └── terraform-validate.yml    # CI/CD validation pipeline
│
├── .tflint.hcl                # TFLint configuration (code quality)
├── .checkov.yaml              # Checkov configuration (security scanning)
└── README.md                  # This file
```

## 🔧 Prerequisites

### Required Tools
- **Terraform** >= 1.0 ([Install](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** >= 2.0 ([Install](https://aws.amazon.com/cli/))
- **kubectl** >= 1.24 ([Install](https://kubernetes.io/docs/tasks/tools/))

### AWS Credentials
```bash
# Configure AWS credentials (interactive)
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=ap-southeast-1
```

### Optional Tools (for local validation)
- **TFLint** - Terraform linting ([Install](https://github.com/terraform-linters/tflint))
- **Checkov** - Security scanning (`pip install checkov`)

## 🚀 Quick Start

### 1. Clone & Navigate
```bash
cd staging  # or cd prod for production
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Review Plan
```bash
terraform plan -out=tfplan
```

### 4. Apply Configuration
```bash
terraform apply tfplan
```

### 5. Get Kubeconfig
```bash
# After deployment completes
aws eks update-kubeconfig \
  --name ops-eks-staging \
  --region ap-southeast-1

# Verify connection
kubectl get nodes
```

## 📊 Environment Configuration

### Staging Environment
- **CIDR**: 10.10.0.0/16
- **Private Subnets**: 10.10.0.0/24, 10.10.1.0/24, 10.10.2.0/24
- **Public Subnets**: 10.10.3.0/24, 10.10.4.0/24, 10.10.5.0/24
- **EKS Cluster**: Kubernetes 1.28, t2.medium nodes (min=1, max=5, desired=3)
- **NAT Gateway**: Single NAT for private subnet egress

### Production Environment
- **CIDR**: 172.10.0.0/16
- **Private Subnets**: 172.10.1.0/24, 172.10.2.0/24, 172.10.3.0/24
- **Public Subnets**: 172.10.4.0/24, 172.10.5.0/24, 172.10.6.0/24
- **EKS Cluster**: Kubernetes 1.28, t2.medium nodes (min=1, max=5, desired=3)
- **NAT Gateway**: Single NAT for private subnet egress

## 🔄 CI/CD Pipeline - Terraform Validation

This project includes an automated GitHub Actions workflow for pull request validation.

### What It Does

When you open a Pull Request that modifies Terraform files:

1. **Terraform Validate** - Checks syntax and configuration correctness
2. **TFLint** - Enforces code quality and best practices
3. **Checkov** - Scans for security misconfigurations

Validation runs on **both staging and prod** directories in parallel.

### Workflow Triggers
- Pull requests to any branch
- Changes to `staging/`, `prod/`, `modules/`, or workflow files

### View Results
- Check PR "Checks" tab to see validation status
- Failed checks will block merge (if branch protection enabled)
- Click "Details" to see error messages and line numbers

### GitHub Actions Configuration

The workflow is defined in [`.github/workflows/terraform-validate.yml`](.github/workflows/terraform-validate.yml)

**Key Features:**
- Matrix jobs: Validates both environments in parallel
- No AWS credentials needed for validation-only checks
- Fails fast on critical errors (syntax, validation)
- Security scanning catches common misconfigurations

## 🔐 Security & Best Practices

### Built-in Security Checks (Checkov)
- Security group rules with open ingress (0.0.0.0/0)
- IAM policy best practices
- AWS resource encryption status
- VPC Flow Logs and logging configurations

### Configuration Best Practices
- ✅ Modular design: Reusable VPC and EKS modules
- ✅ State management: Separate state files per environment
- ✅ Variables: All magic values parameterized
- ✅ Naming conventions: Consistent resource naming (`{project_name}-{project_env}`)
- ✅ Multi-AZ deployment: High availability across 3 availability zones
- ✅ Managed services: AWS-managed EKS and node groups (no self-managed master)

### Recommendations for Production
- [ ] Enable VPC Flow Logs for network monitoring
- [ ] Implement EKS control plane logging
- [ ] Use spot instances for non-critical workloads (modify node group)
- [ ] Enable cluster autoscaling
- [ ] Set up AWS CloudWatch monitoring and alarms
- [ ] Enable AWS IAM roles for service accounts (IRSA)
- [ ] Use a remote state backend (S3 + DynamoDB) instead of local state
- [ ] Enable VPC endpoint for private cluster access

## 📝 Module Variables

### VPC Module
| Variable | Description | Example |
|----------|-------------|---------|
| `project_name` | Project name prefix | `ops` |
| `project_env` | Environment name | `staging` / `prod` |
| `region` | AWS region | `ap-southeast-1` |
| `cidr` | VPC CIDR block | `10.10.0.0/16` |
| `private_subnets` | Private subnet CIDRs (list) | `["10.10.0.0/24", ...]` |
| `public_subnets` | Public subnet CIDRs (list) | `["10.10.3.0/24", ...]` |

### EKS Module
| Variable | Description | Example |
|----------|-------------|---------|
| `project_name` | Project name prefix | `ops` |
| `project_env` | Environment name | `staging` / `prod` |
| `region` | AWS region | `ap-southeast-1` |
| `vpc_id` | VPC ID (from VPC module) | `vpc-xxx` |
| `vpc_private_subnets` | Private subnet IDs (from VPC module) | `["subnet-xxx", ...]` |

## 🧪 Validation & Testing

### Local Validation
```bash
# Syntax validation
terraform validate

# Code quality checks
tflint

# Security scanning
checkov -d . --framework terraform
```

### CI/CD Validation
All validation runs automatically on PR via GitHub Actions. See CI/CD Pipeline section above.

## 📤 Outputs

After `terraform apply`, outputs include:

**VPC Outputs:**
- `vpc_id` - VPC identifier
- `private_subnets` - List of private subnet IDs

**EKS Outputs:**
- `cluster_id` - EKS cluster name
- `cluster_endpoint` - EKS API endpoint

## 🐛 Troubleshooting

### "terraform init" fails
- Ensure AWS credentials are configured
- Check IAM permissions for state bucket (if using remote backend)
- Verify AWS region is set correctly

### "terraform apply" fails with security group errors
- Node security group may already exist; check AWS console
- Destroy and re-apply, or manually remove conflicting SGs

### Can't connect to EKS cluster
```bash
# Update kubeconfig
aws eks update-kubeconfig \
  --name ops-eks-staging \
  --region ap-southeast-1

# Verify kubectl access
kubectl auth can-i get nodes
```

### State file conflicts
- Don't commit `.terraform/` directory (add to .gitignore)
- Keep `terraform.tfstate` in git for reference only
- Consider using S3 remote state for team collaboration

## 📚 Useful Commands

```bash
# Workspace operations
cd staging  # Switch to staging
cd ../prod  # Switch to prod

# Planning & validation
terraform validate        # Check syntax
terraform plan           # Preview changes (no apply)
terraform plan -destroy  # Preview destruction

# Apply operations
terraform apply          # Apply with approval
terraform apply -auto-approve  # Auto-approve (for CI/CD)

# Inspection
terraform show           # Show current state
terraform output         # Show all outputs
terraform output -json   # JSON format

# Cleanup
terraform destroy        # Destroy all resources
terraform destroy -auto-approve  # Auto-approve destruction
```

## 🔗 Related Documentation

- [Terraform AWS Modules - VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws)
- [Terraform AWS Modules - EKS](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Kubernetes kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)

## 📄 License

---

**⚠️ Note:** This is a POC (Proof of Concept) project. Ensure security best practices are reviewed before using in production environments.

**Questions?** Check the troubleshooting section or review the individual `.tf` files for detailed resource configuration.
