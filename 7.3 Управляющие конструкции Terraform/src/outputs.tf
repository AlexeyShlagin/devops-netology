output "web" {
  value = [
    for vm in yandex_compute_instance.platform :
    {
      "name" = vm.name
      "id"   = vm.id
      "fqdn" = vm.network_interface[0].nat_ip_address
    }
  ]

}

output "main_and_replica" {
  value = [
    for vm in yandex_compute_instance.vm :
    {
      "name" = vm.name
      "id"   = vm.id
      "fqdn" = vm.network_interface[0].nat_ip_address
    }
  ]

}

output "storage" {
  value = [
    for vm in yandex_compute_instance.storage :
    {
      "name" = vm.name
      "id"   = vm.id
      "fqdn" = vm.network_interface[0].nat_ip_address
    }
  ]

}

