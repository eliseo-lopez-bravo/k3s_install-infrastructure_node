#!/bin/bash

# Convert template back to VM
qm set 9000 --template 0

# Destroy template
qm destroy 9000 --purge