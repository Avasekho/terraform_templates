terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}

provider "yandex" {
  token                    = "auth_token_here"
  cloud_id                 = "b1geif0o8r531j9g9i4f"
  folder_id                = "b1gltdfspvplkhv2p5i0"
  zone                     = "ru-central1-b"
}

resource "yandex_compute_instance" "default" {
  name        = "test-tf"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81u2vhv3mc49l1ccbb"
      size = "20"
      type = "network-hdd"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net1.id}"
  }

    metadata = {
    ssh-keys = "avasekho:${file("/home/avasekho/yandex_rsa.pub")}"
    serial-port-enable = 1
    user-data = "#cloud-config\nusers:\n  - name: avasekho\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']"
    }

  scheduling_policy {
    preemptible = true
  }

  resource "yandex_vpc_network" "net1" {}

  resource "yandex_vpc_subnet" "net1" {
  zone       = "ru-central1-b"
  network_id = "${yandex_vpc_network.net1.id}"
}
}