#!/bin/bash
sudo swapon -s
echo "\n"
free -m
echo "\n"
df -h
read -p "Press [Enter] key to continue"
echo "\nWill create a 4 Gigabyte file\n"
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
sudo echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
