variable "gcp_project_id" {
  ## Replace with your GCP project ID, such as "hc-26fb1119fccb4f0081b121xxxxx"
  default = ""
}

variable "gcp_region" {
  ## Replace with your GCP region, such as "us-central1"
  default = ""
}

variable "gcp_zone" {
  ## Replace with your GCP zone, such as "us-central1-a"
  default = ""
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
  default = "projects/centos-cloud/global/images/centos-stream-9-v20250513"
}

variable "vm_labels" {
  default = [
    {"name":"boundary-1-dev","service-type":"database", "application":"dev"},
    {"name":"boundary-2-dev","service-type":"database", "application":"dev"},
    {"name":"boundary-3-production","service-type":"database", "application":"production"},
    {"name":"boundary-4-production","service-type":"database", "application":"prod"}
  ]
}

variable "ssh_username" {
  default = "gcpuser"
}

variable "ssh_pub_key_file" {
  ## Optional SSH public key file path for access to the VMs
  ## This is required if using GCP Application Default Credentials (ADC)
  description = "Path to SSH public key for the VM"
  default     = ""
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.gcp_region
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
  target_tags   = ["boundary-vm", "boundary-worker"]
}

resource "google_compute_address" "vm_ip" {
  count  = 4
  name   = "boundary-vm-${count.index + 1}-ip"
  region = var.gcp_region
}

resource "google_compute_instance" "vm" {
  count        = 4
  name         = var.vm_labels[count.index].name
  machine_type = var.vm_machine_type
  zone         = var.gcp_zone

  tags = [
    "boundary-vm"
  ]

  labels = var.vm_labels[count.index]

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

  metadata = var.ssh_pub_key_file == "" ? {ssh-keys = ""} : {ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_file)}"}
}

output "vm_public_ips" {
  value = [for ip in google_compute_address.vm_ip : ip.address]
}

## Uncomment the following only if you use GCP Application Default Credentials (ADC)
## This code creates a VM to use as a Boundary worker with GCP ADC
##
## You must set up an SSH key using the ssh_pub_key_file variable to configure the worker

# resource "google_compute_address" "worker_ip" {
#   name   = "boundary-worker-ip"
#   region = var.gcp_region
# }

# resource "google_compute_instance" "worker" {
#   name         = "boundary-worker"
#   machine_type = "e2-standard-2"
#   zone         = var.gcp_zone
#   allow_stopping_for_update = true

#   tags = [
#     "boundary-worker",
#   ]

#   labels = {
#     name         = "boundary-worker"
#     service-type = "worker"
#   }

#   boot_disk {
#     initialize_params {
#       image = var.vm_image
#       type  = "pd-standard"
#     }
#     auto_delete = true
#   }

#   network_interface {
#     network    = google_compute_network.network.id
#     subnetwork = google_compute_subnetwork.subnet.id
#     access_config {
#       nat_ip = google_compute_address.worker_ip.address
#     }
#   }

#   ## The following block is only for ADC configuration, after setting up 
#   ## the application-default-credentials.tf file.
#   ## Uncomment the following lines after configuring the application-default-credentials.tf file.

#   # service_account {
#   #   email  = google_service_account.boundary_service_account.email
#   #   scopes = ["compute-ro"]
#   # }

#   metadata = {ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_file)}"}
# }

# output "worker_public_ip" {
#   value = google_compute_instance.worker.network_interface[0].access_config[0].nat_ip
# }

# output "worker_ssh_command" {
#   value = "ssh ${var.ssh_username}@${google_compute_instance.worker.network_interface[0].access_config[0].nat_ip} -i /path/to/gcpuser/private/key"
# }
