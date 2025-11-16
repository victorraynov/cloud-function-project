/******************************************
  General Variables
******************************************/
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Function"
  type        = string
  default     = "europe-west2"
}

variable "firestore_location" {
  description = "Firestore database location"
  type        = string
  default     = "europe-west2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "environment_code" {
  description = "Environment code"
  type        = string
  default     = "prod"
}

/******************************************
  Module Toggles
******************************************/
variable "enabled_modules" {
  description = "Toggle modules on/off"
  type = object({
    firestore       = bool
    service_account = bool
    cloud_function  = bool
  })
  default = {
    firestore       = true
    service_account = true
    cloud_function  = true
  }
}

/******************************************
  Firestore Variables
******************************************/
variable "firestore_databases" {
  description = "Firestore databases configuration"
  type = map(object({
    type                        = optional(string)
    concurrency_mode            = optional(string)
    app_engine_integration_mode = optional(string)
  }))
  default = {}
}

/******************************************
  Service Account Variables
******************************************/
variable "service_accounts" {
  description = "Service accounts configuration"
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    roles        = optional(list(string))
  }))
  default = {}
}

/******************************************
  Cloud Function Variables
******************************************/
variable "cloud_functions" {
  description = "Cloud Functions configuration"
  type = map(object({
    description           = optional(string)
    runtime               = optional(string)
    entry_point           = optional(string)
    source_dir            = optional(string)
    available_memory      = optional(string)
    timeout               = optional(number)
    max_instances         = optional(number)
    min_instances         = optional(number)
    ingress_settings      = optional(string)
    service_account_key   = optional(string)
    environment_variables = optional(map(string))
  }))
  default = {}
}
