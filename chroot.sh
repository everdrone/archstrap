ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc

# IMPORTANT! uncomment en_US.UTF-8 UTF-8 in /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=it > /etc/vconsole.conf

echo arch64 > /etc/hostname
echo "
127.0.0.1 localhost
::1   localhost
" > /etc/hosts

mkinitcpio -p linux

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "/swapfile none swap sw 0 0" >> /etc/fstab

# # to remove use
# # # swapoff -a
# # rm -f /swapfile

echo "---------------------------------"
echo "------- SET THE PASSWORD FOR root"
echo "---------------------------------"
passwd

pacman -S --noconfirm openssh grub-bios linux-headers

useradd -m -g users -G wheel -s /bin/bash everdrone
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo "---------------------------------"
echo "------- SET THE PASSWORD FOR root"
echo "---------------------------------"
passwd everdrone

grub-install --target=i386-pc --recheck /dev/sda
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

# exit
# umount -a
# reboot

# test connection
ping -c 3 archlinux.org

systemctl restart dhcpc.service
systemctl enable sshd.service
pacman -Syyu
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

# test connection
ping -c 3 archlinux.org

pacman -S --noconfirm xorg-server
pacman -S --noconfirm open-vm-tools

systemctl enable vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service

# pacman -S --noconfirm lightdm lightdm-gtk-greeter
# systemctl enable lightdm
# pacman -S --noconfirm mate mate-extra

pacman -S --noconfirm xfce4 xfce4-goodies sddm
systemctl enable sddm

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# install fonts
cp sf-mono /usr/share/fonts/sf-mono
chmod 0444 /usr/share/fonts/sf-mono/*
chmod 0555 /usr/share/fonts/sf-mono

cp sf-compact /usr/share/fonts/sf-compact
chmod 0444 /usr/share/fonts/sf-compact/*
chmod 0555 /usr/share/fonts/sf-compact

cp sf-pro /usr/share/fonts/sf-pro
chmod 0444 /usr/share/fonts/sf-pro/*
chmod 0555 /usr/share/fonts/sf-pro

exit
