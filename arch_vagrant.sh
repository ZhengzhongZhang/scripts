yes | pacman -Syu --needed openssh virtualbox-guest-utils-nox virtualbox-guest-dkms linux-headers sudo
systemctl enable sshd dkms vboxservice

useradd -G wheel,vboxsf -m vagrant
passwd -d vagrant
passwd vagrant <<-EOF
vagrant
vagrant
EOF

# ssh settings
mkdir -p /home/vagrant/.ssh
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
sed -i 's/#UseDNS/UseDNS/' /etc/ssh/sshd_config

