output "vm_external_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}
