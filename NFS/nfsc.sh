#!/bin/bash

sudo sed -i 's/#DNS=/DNS=8.8.8.8 8.8.4.4/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
sudo apt install nfs-common -y
sudo echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
sudo systemctl daemon-reload
sudo systemctl restart remote-fs.target
sudo mount | grep mnt
ls /mnt/upload
sudo touch /mnt/upload/client_file