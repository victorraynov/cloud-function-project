/******************************************
  GCP Configuration
******************************************/
environment        = "production"
environment_code   = "prod"
project_id         = "studious-camp-478213-k4"
region             = "europe-west2"
firestore_location = "europe-west2"

/******************************************
  Module Toggles
******************************************/
enabled_modules = {
  firestore       = true
  service_account = true
  cloud_function  = true
}

/******************************************
  Firestore Database
******************************************/
firestore_databases = {
  vpc-inventory-db = {
    type                        = "FIRESTORE_NATIVE"
    concurrency_mode            = "OPTIMISTIC"
    app_engine_integration_mode = "DISABLED"
  }
}

/******************************************
  Service Accounts
******************************************/
service_accounts = {
  vpc-inventory-sa = {
    display_name = "VPC Inventory Service Account"
    description  = "Service account for VPC inventory Cloud Function"

    roles = [
      "roles/compute.viewer",
      "roles/datastore.user",
      "roles/logging.logWriter",
    ]
  }
}

/******************************************
  Cloud Functions
******************************************/
cloud_functions = {
  vpc-inventory-function = {
    description      = "Lists all VPCs and Subnets and saves to Firestore"
    runtime          = "python311"
    entry_point      = "vpc_inventory"
    source_dir       = "./function"
    available_memory = "512M"
    timeout          = 540
    max_instances    = 10
    min_instances    = 0
    ingress_settings = "ALLOW_ALL"

    service_account_key = "vpc-inventory-sa"

    environment_variables = {
      LOG_LEVEL = "INFO"
    }
  }
}
