terraform {
  backend "gcs" {
    bucket  = "shishmakov-bucket"
    path    = "infra/terraform.tfstate"
    project = "infra-179717"
    region = "us-central1"
  }
}

