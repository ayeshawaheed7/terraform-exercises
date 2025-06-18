# EKS Cluster Provisioning with Terraform

This project provisions **Amazon EKS clusters** using **Terraform**, with consistent infrastructure for multiple environments: `dev`, `test`, `staging`, and `prod`. It also deploys a **MySQL database via Helm** with persistent storage on EBS, following infrastructure-as-code and CI/CD best practices.

---

## Features

* Automated provisioning of EKS clusters using Terraform modules
* Separate infrastructure for each environment (`dev`, `test`, `staging`, `prod`)
* Remote state management using S3 for safe team collaboration
* MySQL deployed via Helm with:
  * 3 replicas
  * Volume persistence using AWS EBS
* EKS volumes provisioned via the AWS EBS CSI Driver
* Compatible with CI/CD pipelines for automated deployment

---

## Environments

Each environment has its own:

* CIDR blocks for VPC and subnets
* Unique cluster name and tags
* Dedicated S3 backend path for remote state

### Example `dev.tfvars`:

```hcl
env_prefix                   = "dev"
vpc_cidr_block               = "10.10.0.0/16"
private_subnet_cidr_blocks   = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
public_subnet_cidr_blocks    = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
```

---

## Infrastructure Components

### VPC

* Created using `terraform-aws-modules/vpc`
* Private and public subnets across multiple AZs
* Tagged for Kubernetes discovery

### EKS Cluster

* 1 EKS cluster per environment
* 1 managed node group (3 nodes)
* 1 Fargate profile for Java application pods
* AWS EBS CSI driver enabled for volume provisioning

### MySQL via Helm

* Installed using the Bitnami Helm chart
* Deployed in the EKS cluster
* Configurable via `mysql-values.yaml`
* Ensures volume persistence

---

## Remote State

Terraform state is stored in an **S3 bucket**, ensuring safe and collaborative access.

Example configuration:

```hcl
terraform {
  backend "s3" {
    bucket = "my-app-tfstatebucket"
    key    = "my-app-dev/state.tfstate"
    region = "ap-southeast-1"
  }
}
```

---

## Usage

### 1. Initialize Terraform

```bash
terraform init -backend-config=envs/dev/backend-dev.hcl
```

### 2. Plan the changes

```bash
terraform plan -var-file=envs/dev/dev.tfvars
```

### 3. Apply the changes

```bash
terraform apply -var-file=envs/dev/dev.tfvars --auto-approve
```

Repeat with the appropriate tfvars file for other environments (`test`, `staging`, `prod`).

---

## Connect to EKS Cluster

After provisioning, you can use `kubectl` to interact with your EKS cluster. First, configure your kubeconfig:

### Update kubeconfig for your environment

```bash
aws eks update-kubeconfig \
  --name dev-my-app-cluster \
  --region ap-southeast-1
```

Replace `dev-my-app-cluster` and region if you're targeting another environment (e.g., `test-my-app-cluster`).

### Verify the connection

```bash
kubectl get nodes
```

You should see your EKS worker nodes listed.

---

## CI/CD Integration

* This project supports automated deployment through **Jenkins** or any CI/CD tool.
* The pipeline handles Terraform initialization, planning, and applying changes for a given environment.
* AWS credentials are securely injected into the pipeline.
* Recommended: Configure separate pipelines for each environment to isolate infrastructure changes.

---

## Requirements

* [Terraform >= 1.3](https://www.terraform.io/downloads)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* IAM permissions to manage EKS, VPC, EC2, and S3 resources
* Jenkins CI/CD platform

---

## Best Practices Followed

* Modular and reusable infrastructure code
* Environment isolation with separate state files
* Versioned modules (`eks`, `vpc`, etc.)
* Automated volume provisioning via EBS CSI
* Declarative MySQL deployment with Helm
* Supports GitOps-style workflows with CI/CD

