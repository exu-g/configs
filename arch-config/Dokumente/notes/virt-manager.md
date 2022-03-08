# Virt Manager Setup Arch
`# pacman -S libvirt qemu iptables-nft dnsmasq dmidecode bridge-utils virt-manager edk2-ovmf`  
`# usermod -aG libvirt marc`  
`# systemctl enable --now libvirtd.service`  
