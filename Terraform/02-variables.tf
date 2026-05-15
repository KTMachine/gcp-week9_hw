# Input variables for Terraform configuration

# Variable for GCP Project ID
variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = ""
}

# Variable for the region
variable "region" {
  description = "GCP region for the provider and resources"
  type        = string
  default     = "us-central1"
}

# Variable for the zone
variable "zone" {
  description = "GCP zone for the provider and resources"
  type        = string
  default     = "us-central1-a"
}

# Variable for the VPC
variable "vpc_name" {
  description = "Name for the VPC network"
  type        = string
  default     = "custom-vpc"
}

# Variable for the CIDR subnet
variable "subnet_cidr" {
  description = "CIDR range for the single subnet in the VPC"
  type        = string
  default     = "10.11.0.0/24"
}

# Variable for the name for the Managed Instance Group
variable "mig_name" {
  description = "Name for the Managed Instance Group"
  type        = string
  default     = "who-gives-a-fuck"
}

# Variable for the minimum amount of Instances
variable "mig_min_instances" {
  description = "Minimum number of Instances for the MIG autoscaler"
  type        = number
  default     = 3
}

# Variable for the maximum amount of Instances 
variable "mig_max_instances" {
  description = "Maximum number of Instances for the MIG autoscaler"
  type        = number
  default     = 6
}