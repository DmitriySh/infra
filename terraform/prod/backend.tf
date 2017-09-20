terraform {
  backend "gcs" {
    bucket  = "infra-179717-bucket"
    path    = "infra/terraform.tfstate"
    project = "infra-179717"
    region = "europe-west1"
  }
}

