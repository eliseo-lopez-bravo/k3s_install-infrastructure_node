#!/bin/bash

# Download Cloud Image (Ubuntu)
cd /var/lib/vz/template/iso
wget -nc https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

# Create Base VM (Template Source)
qm create 9000 \
  --name ubuntu-cloudinit-template \
  --memory 2048 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0

# Import Disk into Proxmox Storag
qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm

# Attach Disk + Enable Cloud-Init
qm set 9000 --scsihw virtio-scsi-pci
qm set 9000 --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit

# Configure Boot + Console
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0


# Set Default Cloud-Init Options (Optional but Recommended)
qm set 9000 --ciuser root
qm set 9000 --sshkey ~/.ssh/id_rsa.pub

# Convert to Template
qm template 9000

# Test Before Converting to Template
qm clone 9000 101 --name test-vm
qm set 101 --ipconfig0 ip=192.168.3.150/24,gw=192.168.3.1
qm start 101