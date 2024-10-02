# DemoIAM Project Security

This README provides an overview of the security measures implemented in the DemoIAM project.

## Overview

The DemoIAM project uses a combination of Infrastructure as Code (IaC) and CI/CD practices to manage AWS resources securely. We employ several tools and practices to ensure the security and integrity of our infrastructure.

## Security Measures

### 1. AWS OIDC Authentication

We use AWS OIDC (OpenID Connect) for authentication in our GitHub Actions workflows. This allows for secure, temporary credential generation without the need to store long-lived AWS access keys.

- The `aws-actions/configure-aws-credentials@v4` action is used to assume an IAM role.

### 2. Least Privilege Principle

Our GitHub Actions workflows use specific permissions, adhering to the principle of least privilege. For more information on this principle, refer to the AWS article on [Granting least privilege](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege):

### 3. Environment Separation

We maintain separate environments (dev, qa, prod) and use Terraform workspaces to isolate resources. For more information on managing Terraform workspaces, refer to the [Terraform documentation on workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces):

### 4. Manual Approval for Deployments

Critical operations like deployments and destroys require manual approval:

### 5. Infrastructure as Code (IaC) Security Scanning

We use multiple tools to scan our Terraform code for security issues. The results are generated in SARIF (Static Analysis Results Interchange Format) for easy integration with GitHub Security tab.

#### TFLint

TFLint is used to find possible errors and enforce best practices in Terraform code:

### Trivy

Trivy is used to scan IaC resources for vulnerabilities:

### 6. Secure CI/CD Practices

- We use `actions/checkout@v4` to securely check out our repository.
- Terraform plans are generated and reviewed before applying changes in PRs as comments
- Separate workflows for plan, deploy, and destroy operations, also for scanning Terraform code

### 7. Secure State Management

Terraform state is stored securely using backend configurations (e.g., `backend.hcl`), which likely utilizes encrypted S3 buckets and DynamoDB for state locking.

### 8. Service Control Policies (SCPs)

We implement Service Control Policies (SCPs) to manage permissions across our AWS Organization. SCPs provide an additional layer of access control and help enforce security best practices:

- SCPs are applied at the organization, organizational unit (OU), or account level to set guardrails for all IAM entities.
- They help prevent privilege escalation and restrict access to sensitive services or actions.
- Our SCPs are version-controlled and managed through Infrastructure as Code.

For more information on SCPs, refer to the [AWS Organizations User Guide](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html).

### 9. IAM Permission Boundaries

We use IAM Permission Boundaries to set the maximum permissions that IAM entities (users or roles) can have:

- Permission boundaries are applied to IAM users and roles created by our Terraform code.
- They help prevent privilege escalation and ensure that even if an IAM policy grants broader permissions, the effective permissions are limited by the boundary.
- Our permission boundaries are defined in Terraform and follow the principle of least privilege.

For more details on Permission Boundaries, see the [AWS IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html).
