# PromoxVE 8 to 9 Upgrade Process

For more information see: https://pve.proxmox.com/wiki/Upgrade_from_8_to_9

- Stop all VMS and CTs running on the host
- Install all available updates
```
apt update && apt dist-upgrade -y
```
- Run the upgrade compatibility checker
```
pve8to9 --full
```
- Resolve any issues and run again
  - For example: `apt remove systemd-boot`
  - Ignore: `WARN: a suitable kernel (proxmox-kernel-X.XX) is installed, but an unsuitable (6.X.XX-XX-pve) is booted, missing reboot?!`
- Remove old no-nag and old no-subscription repos
```
rm -f /etc/apt/apt.conf.d/99-proxmox-no-nag-script
rm -f /etc/apt/sources.list.d/pve-no-enterprise.list
rm -f /etc/apt/sources.list.d/ceph-no-enterprise.list
```
- Update Debian Base Repositories to Trixie
```
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/pve-enterprise.list
```
- Add Proxmox 9 no-subscription repository
```
cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
```
- Upgrade the system
```
apt update && apt dist-upgrade -y
```
- When prompted:
  - `q` to close news
  - `y` to install /etc/issue
  - Restart services without asking? `Yes`
  - `y` to install /etc/lvm/lvm.conf
- Check Result & Reboot
  - Run: `pve8to9 --full`
  - Ignore: `WARN: a suitable kernel (proxmox-kernel-X.XX) is installed, but an unsuitable (6.X.XX-XX-pve) is booted, missing reboot?!`
  - `reboot` if no other issues found
- Allow server to reboot and verify upgrade
- Run the community post-install script
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```
- When prompted:
  - Start the script with: `yes`
  - Deb822 sources detected: `Ok`
  - 'pve-enterprise' repository already exists: `disable`
  - 'pve-no-subscription' repository is currently ENABLED: `keep`
  - Add (Disabled) 'pvetest' repository: `no`
  - Disable subscription nag: `yes`
  - Support Subscriptions: `Ok`
  - Disable high availability: `yes`
  - Disable Corosync for a Proxmox VE Cluster: `yes`
  - Update Proxmox VE now: `yes`
  - Post-Install Reminder: `Ok`
  - Reboot Proxmox VE now: `yes`
- Run the community kernel cleanup script
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/kernel-clean.sh)"
```

Finished
