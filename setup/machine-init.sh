#!/usr/bin/env sh

# This script should be executed on machine startup
# Add a cronjob as root like this:
# @reboot ~scriptlocation/machine_init.sh

echo 262144 > /proc/sys/vm/max_map_count
echo 100000 > /proc/sys/fs/file-max

echo "* soft nofile 100000" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 100000" | sudo tee -a /etc/security/limits.conf
echo "* soft memlock unlimited" | sudo tee -a /etc/security/limits.conf
echo "* hard memlock unlimited" | sudo tee -a /etc/security/limits.conf