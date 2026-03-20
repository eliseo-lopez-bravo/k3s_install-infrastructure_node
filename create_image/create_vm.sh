#!/bin/bash

# Delete ssh key
ssh-keygen -f '/root/.ssh/known_hosts' -R '192.168.3.150'

# Test Before Converting to Template
qm clone 9000 101 --name test-vm
qm set 101 --ipconfig0 ip=192.168.3.150/24,gw=192.168.3.1
qm start 101