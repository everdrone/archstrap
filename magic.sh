loadkeys it
ping -c 3 archlinux.org
ls /sys/firmware/efi/efivars
timedatectl set-ntp true
fdisk -l

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o
  n
    # primary
    # 1
    # default start sector
  +16G
  p
  n
    # primary
    # 2
    # default start sector
    # default end sector
  p
  w
EOF

mount /dev/sda1 /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash -e -x ./aux.sh
umount -a
reboot