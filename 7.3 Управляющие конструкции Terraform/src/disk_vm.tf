
resource "yandex_compute_disk" "disks" {
  count = 3
  name  = "my-disk-${count.index}"
  size  = 1

}


resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.vm_web_platform_id

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    content {
      device_name = secondary_disk.value.name
      disk_id     = secondary_disk.value.id
    }
  }

}
