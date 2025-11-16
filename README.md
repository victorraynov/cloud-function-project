# VPC Inventory Cloud Function

Automatically lists all VPCs and Subnets in a GCP project and saves the inventory to Firestore database.

## Quick Deploy

## What Gets Created

- Cloud Function (Gen 2)
- Firestore Database
- Service Account with minimal permissions
- Storage bucket for function source

### 1. Configure

```bash
# gcloud authentication
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Insert PROJECT_ID in terraform/vars/prod.tfvars
project_id = "your-project-id"
```

### 2. Deploy Infrastructure

```bash
# From root
terraform init -backend-config=vars/prod_backend.tfvars
terraform apply -var-file=vars/prod.tfvars
```

### 3. Get Function URL

```bash
terraform output function_urls
```

### 4. Trigger Inventory

```bash
FUNCTION_URL=$(terraform output -json function_urls | jq -r '.["vpc-inventory-function"]')

curl "$FUNCTION_URL"
```

## Query Firestore Data

### Using gcloud:

```bash
# List all inventories
gcloud firestore collections list

# Get latest inventory
gcloud firestore documents list vpc_inventories --limit=1

# Get specific inventory
gcloud firestore documents get vpc_inventories/{number}
```

## Local Testing

```bash
cd function

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

export GCP_PROJECT="studious-camp-478213-k4"

functions-framework --target=vpc_inventory --debug
```

Then trigger: `curl http://localhost:8080`


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_function"></a> [cloud\_function](#module\_cloud\_function) | ./modules/cloud_function | n/a |
| <a name="module_firestore"></a> [firestore](#module\_firestore) | ./modules/firestore | n/a |
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | ./modules/service_account | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.required_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_functions"></a> [cloud\_functions](#input\_cloud\_functions) | Cloud Functions configuration | <pre>map(object({<br/>    description           = optional(string)<br/>    runtime               = optional(string)<br/>    entry_point           = optional(string)<br/>    source_dir            = optional(string)<br/>    available_memory      = optional(string)<br/>    timeout               = optional(number)<br/>    max_instances         = optional(number)<br/>    min_instances         = optional(number)<br/>    ingress_settings      = optional(string)<br/>    service_account_key   = optional(string)<br/>    environment_variables = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled_modules"></a> [enabled\_modules](#input\_enabled\_modules) | Toggle modules on/off | <pre>object({<br/>    firestore       = bool<br/>    service_account = bool<br/>    cloud_function  = bool<br/>  })</pre> | <pre>{<br/>  "cloud_function": true,<br/>  "firestore": true,<br/>  "service_account": true<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"production"` | no |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | Environment code | `string` | `"prod"` | no |
| <a name="input_firestore_databases"></a> [firestore\_databases](#input\_firestore\_databases) | Firestore databases configuration | <pre>map(object({<br/>    type                        = optional(string)<br/>    concurrency_mode            = optional(string)<br/>    app_engine_integration_mode = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_firestore_location"></a> [firestore\_location](#input\_firestore\_location) | Firestore database location | `string` | `"europe-west2"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region for Cloud Function | `string` | `"europe-west2"` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Service accounts configuration | <pre>map(object({<br/>    display_name = optional(string)<br/>    description  = optional(string)<br/>    roles        = optional(list(string))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firestore_databases"></a> [firestore\_databases](#output\_firestore\_databases) | Firestore database names |
| <a name="output_function_names"></a> [function\_names](#output\_function\_names) | Cloud Function names |
| <a name="output_function_urls"></a> [function\_urls](#output\_function\_urls) | Cloud Function URLs |
| <a name="output_service_account_emails"></a> [service\_account\_emails](#output\_service\_account\_emails) | Service account emails |
<!-- END_TF_DOCS -->