#!/bin/bash

sudo sed -i 's/#DNS=/DNS=8.8.8.8 8.8.4.4/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
sudo apt install nfs-kernel-server -y
sudo mkdir -p /srv/share/upload
sudo chown -R nobody:nogroup /srv/share
sudo chmod 0777 /srv/share/upload
sudo cat << EOF > /etc/exports 
/srv/share 192.168.50.11/32(rw,sync,root_squash)
EOF
sudo exportfs -r
sudo exportfs -s
sudo touch /srv/share/upload/check_file