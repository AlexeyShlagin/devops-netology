output "instance_external_ips" {
  description = "Словарь с соответствием имени экземпляра и его внешнего IP-адреса"
  value = {
    "netology-develop-platform"    = yandex_compute_instance.platform.network_interface[0].nat_ip_address,
    "netology-develop-platform-db" = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
  }
}
