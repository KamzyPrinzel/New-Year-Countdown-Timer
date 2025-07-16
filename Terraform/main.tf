provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "nytc-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "nytc-subnet"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
}

resource "google_compute_firewall" "ingress" {
  name    = "nytc-allow-ingress"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 1000
}

resource "google_compute_firewall" "egress" {
  name    = "nytc-allow-egress"
  network = google_compute_network.vpc.id

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
  priority           = 1000
}

resource "google_compute_instance" "vm" {
  name         = "nice-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.subnet.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
}

  tags = ["web"]
}
