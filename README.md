# FinOps tagging lab: Azure + Terraform

A small lab for the **Allocation** capability of the FinOps Framework (Crawl phase). Tags are defined in Terraform, and a built-in Azure Policy makes resources inherit them from their resource group, so that manually created resources don't end up as unallocated cost.

Companion code for a blog series on [djordjenedovic.tech](https://djordjenedovic.tech).

## What it creates

| Resource | Name | Purpose |
| --- | --- | --- |
| Resource group | `rg-team-a` | Tagged `team = Team A`, `env = dev01`, covered by the policy |
| Storage account (LRS) | `stteamatest` | Inherits tags from `rg-team-a` |
| Resource group | `rg-team-b` | Tagged `team = Team B`, `env = dev02`, **intentionally not covered** by the policy |
| Storage account (LRS) | `stteambtest` | Inherits tags from `rg-team-b` |
| Policy assignment ×2 | `inherit-team`, `inherit-env` | Built-in *Inherit a tag from the resource group if missing*, one assignment per tag |
| Role assignment ×2 | – | `Tag Contributor` for each assignment's managed identity |
| Remediation ×2 | `remediate-inherit-team`, `remediate-inherit-env` | Fixes resources that existed before the assignment |

All resources also get `managed-by = terraform`. That tag is deliberately **not** inherited by the policy, so a resource created outside Terraform never claims to be managed by it.

`rg-team-b` is left uncovered on purpose. It shows up as the gap in the reporting part of the series.

## Prerequisites

- Terraform >= 1.6
- Azure CLI, logged in with `az login`
- An Azure subscription where you can create role assignments (Owner or User Access Administrator)

## Usage

```bash
az login
az account show                                 # confirm the active subscription

cp terraform.tfvars.example terraform.tfvars    # set unique_suffix
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

### Check compliance

```bash
az policy state trigger-scan --resource-group rg-team-a
az policy state list --resource-group rg-team-a -o table
```

The scan takes a few minutes. Remediation runs asynchronously and can be followed in the portal under **Policy → Remediation**.

### Clean up

```bash
terraform destroy
```

## Variables

| Name | Default | Description |
| --- | --- | --- |
| `location` | `northeurope` | Azure region for all resources |

## Gotchas

- **Policy assignments are not effective immediately.** Resources created in the same apply may not be caught until the next update or a remediation run.
- **Terraform vs. policy.** If a resource has no `tags` in code and the policy adds them, the next `plan` will try to remove them. Keep tags in code, or use `lifecycle { ignore_changes = [tags] }`.

## Cost

Resource groups are free, and two empty LRS storage accounts cost a few cents. Run `terraform destroy` when you're done.