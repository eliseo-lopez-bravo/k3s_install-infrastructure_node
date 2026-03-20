provider "proxmox" {
  pm_api_url      = "https://192.168.3.168:8006/api2/json"
  pm_tls_insecure = true
}

############################
# VARIABLES
############################

variable "gateway" {
  default = "192.168.3.1"
}

variable "cidr" {
  default = "24"
}

############################
# MASTER NODE
############################

resource "proxmox_vm_qemu" "k3s_master" {
  name        = "k3s-master"
  target_node = "proxmox-node"
  clone       = "ubuntu-cloudinit-template" # <-- MUST EXIST
  cores       = 2
  memory      = 2048

  disk {
    size = "20G"
    type = "scsi"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.3.100/${var.cidr},gw=${var.gateway}"

  sshkeys = file("../ssh_keys/id_rsa.pub")

  ciuser     = "root"
  cipassword = "disabled"
}

############################
# WORKER NODES
############################

resource "proxmox_vm_qemu" "k3s_worker" {
  count       = 2
  name        = "k3s-worker-${count.index + 1}"
  target_node = "proxmox-node"
  clone       = "ubuntu-cloudinit-template"
  cores       = 2
  memory      = 1024

  disk {
    size = "20G"
    type = "scsi"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.3.10${count.index + 1}/${var.cidr},gw=${var.gateway}"

  sshkeys = file("../ssh_keys/id_rsa.pub")

  ciuser     = "root"
  cipassword = "disabled"
}

############################
# OUTPUTS (FOR JENKINS / ANSIBLE)
############################

output "k3s_master_ip" {
  value = "192.168.3.100"
}

output "k3s_worker_ips" {
  value = [
    for i in range(2) :
    "192.168.3.10${i + 1}"
  ]
}
