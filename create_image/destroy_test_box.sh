#!/bin/bash

# Shutdown VM
qm shutdown 101

# Force stop (if stuck)
qm stop 101

# Delete a VM  once stopped:
qm destroy 101 --purge