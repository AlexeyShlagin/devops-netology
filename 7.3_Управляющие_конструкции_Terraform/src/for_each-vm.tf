locals {
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

resource "yandex_compute_instance" "vm" {
  depends_on  = [yandex_compute_instance.platform]
  for_each    = var.vm_instances
  name        = each.value.vm_name
  platform_id = var.vm_web_platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = local.ssh_public_key
  }
}
