# Proxmox Backup Server

## Installation
Ideal hardware setup

- 1 boot drives
- 1 or more storage drives

Download install media

- https://www.proxmox.com/en/downloads/proxmox-backup-server

Boot media and follow installation steps

- Hostname should end in `.home.arpa`
- For example `pbs.home.arpa`

## Configuration
Open the web interface and login

- https://Server.IP.Address:8007

Navigate to: **Administration > Shell** to run commands

- Configure updates
```
VERSION="$(awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release)";
# Enable no-subscription repo
cat <<EOF >/etc/apt/sources.list.d/pbs-install-repo.list
deb http://download.proxmox.com/debian/pbs ${VERSION} pbs-no-subscription
EOF
# Disable enterprise repo
cat <<EOF >/etc/apt/sources.list.d/pbs-enterprise.list
# deb https://enterprise.proxmox.com/debian/pbs ${VERSION} pbs-enterprise
EOF
```
- Disable nag screen
```
echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data\.status.*{/{s/\!//;s/active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" >/etc/apt/apt.conf.d/no-nag-script
apt update && apt --reinstall install proxmox-widget-toolkit
```
- Install updates
```
apt update && apt dist-upgrade -y
```

## Create Datastore
Single Disk

- Navigate to: **Administration > Storage / Disks > Disks**
- Select the drive to add and select `Initialize Disk with GPT`
- Move to the "Directory tab" and select `Create: Directory`
- For "Filesystem:" select `xfs`
- Give the directory a friendly name like `1TB-HD`
- Make sure "Add as Datastore" checked
- Click `Create`

ZFS

- Navigate to: **Administration > Storage / Disks > ZFS**
- Click `Create: ZFS`
- Give the pool a friendly name
- Select all disks you wish to add to the pool
- Select an appropriate RAID Level
- Leave Compression on
- Make sure "Add as Datastore" is checked
- Click `Create`

## Configure Datastore
Navigate to: **Datastore > Your Datastore**

### Configure Namespaces
Note: Namespaces allow you to backup multiple Proxmox Servers to a single Backup Server without the need to require clustering. Separate Namespaces allow Containers and VMs of the same ID from different server to reside on the Backup Server without conflict. Simply create a separate Namespace for each of your servers and specify it when adding the Backup Server to your Proxmox Server.

Note: Namespaces are not required if you are backing up a single Proxmox Server

Select `Content`

- Click `+ Add Namespace`
- For "Namespace Name", enter a unique ID for your first Proxmox Server you are backing up
- Make sure "Parent Namespace" is `Root` unless you are explicitly trying to nest your new Namespace
- Repeat for each Proxmox Server you are backing up

### Configure Prune & GC Jobs
Select `Prune & GC Jobs`

- Under "Prune Jobs" click `Add`
- **Prune Schedule**: `Every first Saturday of the month 02:00`
- **Keep Last**: `4`
- Click `Add`

### Configure Verify
Select `Options`

- Edit `Verify New Snapshots`
- Enable `Verify new backups immediately after completion`

## Add Backup Server to PVE
Navigate to: **Datacenter > Storage > Add > Proxmox Backup Server**

- **ID**: Give the backup server a name
- **Server**: IP of the server
- **Username/Password (UN/PW)**: User credentials. For the username, format it as `user@pam` e.g. `root@pam`
- **Datastore**: Name of the datastore on the backup server
- **Name**: Name of the Namespace on the backup server, you only need to fill this in if you are backing up multiple Proxmox Servers
- **Fingerprint**: On the backup server, on the dashboard page click at the top `Show Fingerprint`
- Click `Add`

## Schedule
Schedules are set on the PVE server

Navigate to: **Datacenter > Backup**

- Click `Add` to create a backup schedule
- **Node**: Select the Node you want to create the schedule on, or leave blank for all Nodes
- **Storage**: Select the backup server
- **Schedule**: Select `First Saturday each month 15:00`
- **Mode**: Leave `Snapshot` selected to reduce downtime. VMs may act as if they are recovering from a power failure when restored
- Make sure **Enable** is checked
- Select the VMs / Containers to add to the backup schedule
- Click `Create` when done

## Restore a VM or Container
In Proxmox, navigate to the backup server storage location and open the "Backups" tab

- Select the VM or Container to restore and click `Restore`
- Confirm the ID of the VM or Container and click `Restore`

### File Level Restore
In the "Backups" tab, select a backup to restore a file from and then select `File Restore`

- Wait for Proxmox to expand the image
- Drill down to the file or you wish to restore and select it
- Click `Download as` or `Download` depending if you selected a folder, multiple or an individual file

## TLS Server Certificate
...

## Configure E-Mail alerts
...

## Troubleshooting

### Remove a Directory Datastore
- Remove the Datastore
```
proxmox-backup-manager datastore remove <id>
```
- Disable mount
```
systemctl disable mnt-datastore-<id>.mount
```
- Remove mount service file
```
rm /etc/systemd/system/mnt-datastore-<id>.mount
```
- Find the disk ID
```
lsblk
```
- Wipe the disk
```
sgdisk --zap-all /dev/sdX
```
