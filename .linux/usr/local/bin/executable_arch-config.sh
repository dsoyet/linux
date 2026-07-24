ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
locale-gen
echo 'root:root' | chpasswd
systemctl enable systemd-networkd.service systemd-resolved.service
systemctl enable sshd iwd
useradd --create-home --user-group share
echo 'share:share' | chpasswd
