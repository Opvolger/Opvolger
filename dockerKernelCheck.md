https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh


ubuntu
sudo apt-get purge --auto-remove initramfs-tools

sudo apt install docker.io
sudo update-alternatives --config iptables

# need iptables-legacy