output "id" {
  value = yandex_compute_instance.vm.id
}

output "ip_address" {
  value = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "nat_ip_address" {
  value = try(yandex_compute_instance.vm.network_interface.0.nat_ip_address, "")
}