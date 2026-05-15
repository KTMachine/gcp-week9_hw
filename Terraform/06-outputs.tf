# 7-outputs.tf
# Outputs printed to terminal after apply.
# Useful for verifying the deployment and referencing values in other configs.

output "vpc_name" {
  description = "Name of the custom VPC"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "Self link of the custom VPC — used to reference this VPC in other GCP resources"
  value       = google_compute_network.vpc.self_link
}

output "subnet_name" {
  description = "Name of the subnet created within the custom VPC"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_cidr" {
  description = "CIDR range assigned to the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "mig_name" {
  description = "Name of the managed instance group"
  value       = google_compute_region_instance_group_manager.main.name
}

output "mig_self_link" {
  description = "Self link of the MIG — used to attach a load balancer backend service"
  value       = google_compute_region_instance_group_manager.main.self_link
}

output "mig_instance_group" {
  description = "Instance group URL — required when attaching this MIG to a backend service"
  value       = google_compute_region_instance_group_manager.main.instance_group
}

output "health_check_self_link" {
  description = "Self link of the health check — can be referenced by a load balancer backend service"
  value       = google_compute_health_check.http.self_link
}
