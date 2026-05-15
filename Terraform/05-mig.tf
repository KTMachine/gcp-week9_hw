# The resources for the Managed Instance Groups
resource "google_compute_health_check" "http" {
  name                = "${var.mig_name}-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

# Instance Template
resource "google_compute_instance_template" "main" {
  name_prefix  = "${var.mig_name}-template-1"
  machine_type = "n2-standard-2"

  lifecycle {
    create_before_destroy = true
  }

  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
    disk_type    = "pd-balanced"
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link

    access_config {}
  }

  tags = ["http-server", "ssh-server"]

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
  }

  labels = {
    env = "dev"
  }
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "main" {
  name   = var.mig_name
  region = var.region

  base_instance_name = var.mig_name

  version {
    instance_template = google_compute_instance_template.main.self_link
  }

  distribution_policy_zones = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-f",
  ]

  auto_healing_policies {
    health_check      = google_compute_health_check.http.self_link
    initial_delay_sec = 120
  }
}

# Autoscaler
resource "google_compute_region_autoscaler" "main" {
  name   = "${var.mig_name}-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.main.self_link

  autoscaling_policy {
    min_replicas = var.mig_min_instances
    max_replicas = var.mig_max_instances

    cooldown_period = 60

    cpu_utilization {
      target = 0.60
    }
  }
}