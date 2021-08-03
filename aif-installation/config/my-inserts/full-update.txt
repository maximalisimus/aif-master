#!/bin/bash
sudo pacman -Syy archlinux-keyring --noconfirm && sudo pacman -Syyuu --noconfirm && sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg && sudo pacman -Scc && sudo grub-customizer
exit 0
