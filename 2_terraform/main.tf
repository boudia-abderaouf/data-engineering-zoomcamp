terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  credentials = "./keys/my-creds.json"
  project = "terraform-demo-467210"
  region  = "europe-west9"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "terraform-demo-467210-terra-bucket"
  location      = "EUROPE-WEST9"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}
