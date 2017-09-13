provider "google" {
  project = "infra-179717"
  region  = "europe-west1"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags = ["reddit-app"]

  metadata {
    sshKeys = "appuser:${file("~/.ssh/otus_devops_appuser.pub")}"
  } 
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base-3-1505269146"
    }
  }
  
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  } 

  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }
}

resource "google_compute_firewall" "firewall_puma" {
    name = "allow-puma-default"
   # Название сети, в которой действует правило
    network = "default"
    
    # Какой доступ разрешить
    allow {
       protocol = "tcp"
       ports = ["9292"]
    }

    # Каким адресам разрешаем доступ
    source_ranges = ["0.0.0.0/0"]
    # Правило применимо для инстансов с тегом …
    target_tags = ["reddit-app"]
}

