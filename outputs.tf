/******************************************
  Cloud Function Outputs
******************************************/
output "function_urls" {
  description = "Cloud Function URLs"
  value = {
    for k, v in module.cloud_function : k => v.function_url
  }
}

output "function_names" {
  description = "Cloud Function names"
  value = {
    for k, v in module.cloud_function : k => v.function_name
  }
}

/******************************************
  Service Account Outputs
******************************************/
output "service_account_emails" {
  description = "Service account emails"
  value = {
    for k, v in module.service_account : k => v.email
  }
}

/******************************************
  Firestore Outputs
******************************************/
output "firestore_databases" {
  description = "Firestore database names"
  value = {
    for k, v in module.firestore : k => v.database_name
  }
}
