alacritty fuzzel niri fcitx5-chinese-addons fcitx5-gtk mpv chromium

qt5-wayland keepassxc

base
base-devel
btrfs-progs
devtools
go
linux
neovim
rustup
terminus-font

gtkmm3 open-vm-tools-wayland


pacstrap /mnt base base-devel btrfs-progs devtools go linux linux-firmware neovim rustup terminus-font intel-ucode sbctl iwd nvidia-open

alacritty
archboot
base
base-devel
btrfs-progs
chromium
devtools
dosfstools
fcitx5-chinese-addons
fcitx5-gtk
fuzzel
go
gtkmm3
keepassxc
linux
lostfiles
mpv
neovim
niri
npm
open-vm-tools-wayland
qt5-wayland
rustup
terminus-font


grub-mkstandalone -O x86_64-efi -o esp/EFI/Boot/bootx64.efi --themes=stylish /boot/grub/grub.cfg=exp.cfg

qemu-system-x86_64 -accel kvm -m 1G -drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF_CODE.4m.fd -drive format=raw,file=fat:rw:/home/share/esp -display sdl,gl=on
