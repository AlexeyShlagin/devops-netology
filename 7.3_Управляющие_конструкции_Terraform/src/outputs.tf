
locals {
  all_servers = concat([for i in yandex_compute_instance.platform : i], [for i in yandex_compute_instance.vm : i], [yandex_compute_instance.storage])
}


output "all_vm" {
  value = [
    for i in local.all_servers :
    {
      "name" = i.name
      "id"   = i.id
      "fqdn" = i.network_interface[0].nat_ip_address
    }
  ]

}

/*
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
      "fqdn" = [vm.network_interface[0].nat_ip_address]
    }
  ]

}

*/
