variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}
variable "network_name" {
  default = "boundary-vm-network"
}
variable "subnet_name" {
  default = "boundary-vm-subnet"
}
variable "subnet_cidr" {
  default = "10.1.0.0/24"
}
variable "vm_machine_type" {
  default = "e2-micro"
}
variable "vm_image" {
  default = "projects/centos-cloud/global/images/centos-stream-9-arm64-v20250513"
}
variable "admin_username" {
  default = "gcpuser"
}
variable "ssh_public_key" {
  description = "SSH public key for the VM"
  default     = "gcpuser:<replace-me>"
}

provider "google" {
  project = "hc-a97523a64a74444c93206161af5"
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.network.id
  ip_cidr_range = var.subnet_cidr
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "boundary-vm-allow-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["boundary-vm"]
}

resource "google_compute_address" "vm_ip" {
  count  = 4
  name   = "boundary-vm-${count.index + 1}-ip"
  region = var.region
}

resource "google_compute_instance" "vm" {
  count        = 4
  name         = "boundary-vm-${count.index + 1}"
  machine_type = var.vm_machine_type
  zone         = var.zone

  tags = [
    "boundary-vm",
    count.index == 2 ? "production" : count.index == 3 ? "prod" : "dev"
  ]

  boot_disk {
    initialize_params {
      image = var.vm_image
      type  = "pd-standard"
    }
    auto_delete = true
  }

  network_interface {
    network    = google_compute_network.network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.vm_ip[count.index].address
    }
  }

  metadata = {
    ssh-keys = var.ssh_public_key
  }
}

output "vm_public_ips" {
  value = [for ip in google_compute_address.vm_ip : ip.address]
}

output "ssh_commands" {
  value = [
    for ip in google_compute_address.vm_ip :
    "ssh ${var.admin_username}@${ip.address}"
  ]
}
