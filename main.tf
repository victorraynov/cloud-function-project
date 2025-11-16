/******************************************
  Enable Required APIs
******************************************/
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "firestore.googleapis.com",
    "artifactregistry.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}

/******************************************
  Firestore Database
******************************************/
module "firestore" {
  source = "./modules/firestore"

  for_each = var.enabled_modules.firestore ? var.firestore_databases : {}

  project_id    = var.project_id
  location      = var.firestore_location
  database_name = each.key
  database      = each.value

  depends_on = [google_project_service.required_apis]
}

/******************************************
  Service Account Module
******************************************/
module "service_account" {
  source = "./modules/service_account"

  for_each = var.enabled_modules.service_account ? var.service_accounts : {}

  project_id      = var.project_id
  account_id      = each.key
  service_account = each.value

  depends_on = [google_project_service.required_apis]
}

/******************************************
  Cloud Function Module
******************************************/
module "cloud_function" {
  source = "./modules/cloud_function"

  for_each = var.enabled_modules.cloud_function ? var.cloud_functions : {}

  project_id       = var.project_id
  region           = var.region
  function_name    = each.key
  function_config  = each.value
  service_account  = try(module.service_account[each.value.service_account_key].email, "")

  depends_on = [
    google_project_service.required_apis,
    module.service_account
  ]
}
