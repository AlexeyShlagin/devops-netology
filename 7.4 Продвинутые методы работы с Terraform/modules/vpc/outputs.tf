
output "yandex_vpc_subnet" {
  value       = yandex_vpc_subnet.new_subnet.id
  description = "subnet id"
}
