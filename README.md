# cloud-infrastructures
This repository manages our cloud infrastructure using Terraform, to provision and manage cloud infrastructure across multiple environments. The infrastructure is organised by region and environment to ensure clarity, consistency, and safe separation of resources.

## Repository Structure
- .github/workflows contains the GitHub Actions workflows used for continuous integration.
- `eu-central-1` contains Terraform configurations grouped by environment which includes: dev, staging, and production that represents separate deployment environments.

## Contribution Workflow
> **NOTE:** All Terraform changes in this repository must be made through a Pull Request. This is a strict requirement. Direct pushes are not allowed.

Terraform planning and application are handled automatically by Atlantis, which is integrated with this repository and operates exclusively on Pull Requests. As a result, any Terraform change that is not submitted via a Pull Request will be blocked not be planned or applied.

Once a Pull Request is opened, a continuous integration pipeline runs automatically to check Terraform formatting and validate the configuration before the change can be reviewed and merged.

This workflow ensures that infrastructure changes are reviewed, validated, and applied in a safe and auditable way across all environments.
