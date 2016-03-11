parted /dev/sda -s 'mklabel gpt'
parted /dev/sda -s 'mkpart esp 1m 513m'
parted /dev/sda -s 'set 1 boot on'
parted /dev/sda -s 'mkpart primary 513m 100%'
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base --needed
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt <<-ENDCHROOT
# set locale
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# set clock
hwclock -wu

# set hostname
echo archlinux > /etc/hostname

# bootloader
bootctl --path=/boot install

# boot entry
cat > /boot/loader/entries/arch.conf <<-ARCH
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda2 rw
ARCH

# boot default entry
cat > /boot/loader/loader.conf <<-DEFAULT
default arch
DEFAULT

# enable dhcp
systemctl enable dhcpcd.service

# root password, change manually after install
passwd<<EOF
vagrant
vagrant
EOF

ENDCHROOT
