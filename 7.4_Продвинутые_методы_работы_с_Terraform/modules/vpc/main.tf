terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "develop_vpc" {
  name = "develop_vpc"
}

resource "yandex_vpc_subnet" "new_subnet" {
  name           = "${var.vpc_name}-${var.default_zone}"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop_vpc.id
  v4_cidr_blocks = var.default_cidr
}
