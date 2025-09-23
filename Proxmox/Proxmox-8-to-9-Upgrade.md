Upgrade process
- Consult for more information: https://pve.proxmox.com/wiki/Upgrade_from_8_to_9
- Install all available updates
- Run pve8to9 or pve8to9 --full
  - Resolve any issues and run again
  - apt remove systemd-boot
- Remove old no-nag and old no-subscription repos
  - rm -f /etc/apt/apt.conf.d/99-proxmox-no-nag-script
  - rm -f /etc/apt/sources.list.d/pve-no-enterprise.list
  - rm -f /etc/apt/sources.list.d/ceph-no-enterprise.list
- Update Debian Base Repositories to Trixie
  - sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
  - sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/pve-enterprise.list
- Add Proxmox 9 no-subscription repository
cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
- Upgrade the system
  - apt update
  - apt dist-upgrade
    - 'q' to close news
    - 'y' to install /etc/issue
    - Restart services without asking? Yes
    - 'y' to install /etc/lvm/lvm.conf
- Check Result & Reboot
  - Run: pve8to9 --full
  - Ignore "WARN: a suitable kernel (proxmox-kernel-6.14) is installed, but an unsuitable (6.8.12-15-pve) is booted, missing reboot?!"
  - Reboot if no other issues found
- Run the community script
  - bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
  - Disable 'pve-enterprise' repository: y
  - Keep 'pve-no-subscription' as-is
  - Add (Disabled) 'pvetest' repository: n
  - Disable subscription nag: y
  - Disable high availability: y
  - Update Proxmox VE now: y
  - Reboot Proxmox VE now: n
