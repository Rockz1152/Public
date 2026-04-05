# TrueNAS Community Edition

## Drives
High capacity spinning disks are recommended for storage pools for their relative low cost compared to SSDs. Obviously if SSDs become cheaper, dollar per GB, use them instead.

Use either of these sites to help find affordable drives

- https://pcpartpicker.com/
- https://diskprices.com/

Note: For mechanical disks, try to find drives that use CMR technology as opposed to SMR technology. Western Digital Reds or Seagate Iron Wolf drives are examples of recommended drives.

## Installation
- Download installation media from https://www.truenas.com/download/
- Boot the TrueNAS installer via USB and select `Install/Upgrade`
- Use `[Space]` to select your target install disk and press `[Enter]`
  - Selecting more than one drive will create a mirrored installation for redundancy
- Select `Yes` to install
- Select `Administrative user` for "Web UI Authentication Method"
  - Enter a password for the default admin user
- Select `Yes` for "Legacy Boot"
- Wait for the installation to complete and then select `Reboot`
  - While the server is rebooting remove the installation media
- Wait for the system to finish booting and then login to the IP provided through a web browser
- The default username is `truenas_admin`

## User Configuration

> [!NOTE]
> This section is optional if you prefer to use the built-in administrator account `truenas_admin`.
> If you want to use a custom username instead, proceed.

Create a new user

- Go to Credentials > Users
- Click `Add` in the top right
- Fill in `Username`
- Allow Access
  - Check SMB Access
  - Check TrueNAS Access - Set to `Full Admin`
  - Check Shell Access
- Authentication
  - Enter your password
- Additional Details
  - Click the pencil next to "Shell"
  - Select `bash` from the dropdown
  - Click the pencil next to "Sudo Commands"
  - Check both `Allow all sudo commands` and `Allow all sudo commands with no password`
  - Click `Save`

Disable default admin user

- Go to Credentials > Users
- Select `truenas_admin` and then click `Edit`
- Under "Authentication" check `Disable Password`
- Click `Save`

## Network Configuration
Configure a static IP address for your server

- System > Network > Interfaces
- Next to an interface, click the three dots for "Show Actions" and select `Edit`
- Under "DHCP" select `Define Static IP Addresses`
- Click `Add` and enter an IP Address and Subnet mask
- Uncheck `Autoconfigure IPv6` and click `Save`
- A dialogue for "Set Gateway and DNS" should open
  - Double check the Default Gateway and Primary DNS Server and click `Register`
- At the top of the page click `Test changes`, check `Confirm` and click `Test Changes` again
- Open a browser to the new IP Address and login
  - Click `Go to Network Settings`, then `Save changes`, and lastly `Save`

## System Configuration
- System > General Settings
  - Localization > Settings
    - Under "Timezone" select yours from the dropdown and click `Save`
  - GUI > Settings
    - Uncheck `Usage collection & UI error reporting` and click `Save`
- System > Advanced Settings
  - Access > Configure
    - Set "Token Lifetime" to `900` and click `Save`
- System > Update
  - Change "Update Profile" to `General` if available

### Enable SSH (Optional)
- Credentials > Users
  - Select your Username and click `Edit`
  - Check `SSH password login enabled`
  - Click `Save`
- System > Services
  - For SSH, start the service and then toggle on `Start Automatically`

### Disable Text Console (Optional)
If you want to secure your server against local access you can disable the text console menu from showing without a password

- System > Advanced Settings
- Console > Configure
- Uncheck `Show Text Console without Password Prompt` and click `Save`

To access it manually, you will can run the following command locally or over SSH
```
sudo cli --menu
```
To exit the Console Setup, press `Ctrl + D`

## Create a Disk Pool
- Select Storage on the left side
- Click `Disks` to inspect the physical disks available to the system
- Select Storage on the left side again and then click `Create Pool`
- Give an appropriate name for the pool
  - A good Rule of thumb for pool naming is `Host-Size-Type`. e.g. `nas-8tb-z1`
- Names must comply with naming conventions: https://docs.oracle.com/cd/E23824_01/html/821-1448/gbcpt.html
```
Each ZFS component, such as datasets and pools, must be named according to the following rules:
  - Each component can only contain alphanumeric characters in addition to the following four special characters:
    - Underscore (_)
    - Hyphen (-)
    - Colon (:)
    - Period (.)
Pool names must begin with a letter, except for the following restrictions:
  - The beginning sequence c[0-9] is not allowed.
  - The name "log" is reserved.
  - A name that begins with: mirror, raidz, raidz1, raidz2, raidz3, or spare is not allowed because these names are reserved.
  - Pool names must not contain a percent sign (%).
Dataset names must begin with an alphanumeric character.
Dataset names must not contain a percent sign (%).
```
- Click Next
- In the Data section select the desired layout for the pool
  - Mouse over each layout for a description
- If you are setting up a simple pool, click `Save And Go To Review`
- Click `Create Pool`, `Confirm` and `Continue`

## Network Share

Create Dataset & Share

- Datasets > `Add Dataset`
- Name: This is the folder name that will be the root of the share. e.g. `data` or `media`
  - Dataset Preset: `SMB`
  - Leave `Create SMB Share` checked
  - SMB Name: The actual name of the share that will be presented on the network. e.g. `Data` or `Media`
  - Click `Save`
  - For the "Start SMB Service" popup, click `Start`
- Create 3 more Datasets under `data` using the `Generic` Dataset Preset. When prompted to "Set ACL for this dataset" select `Return to pool list`.
  - `config`
  - `downloads`
  - `media`

Configure Permissions

- Select the `data` Dataset
- On the right side in the "Permissions" section click `Edit`
- Under "Access Control List" click `+ Add Item`
  - Set "Who" to `Group` and "Group" to `apps`
  - Make sure "Permissions" at the bottom are set to `Modify`
- Check `Apply permissions recursively`
- Click `Confirm` and `Continue`
- Check `Apply permissions to child datasets`
- Lastly click `Save Access Control List`

To connect to the network share, enter: `\\Server.IP.Address\<ShareName>` in Windows Explorer and then enter your TrueNAS USername and Password

## Replace a Drive


- Navigate to Storage
- Select `Manage Devices` under the ZFS pool the drive is located in
- Expand the VDEVs and select the drive to be replaced
- Under "ZFS Info" select `Offline`
  - Confirm and select `Offline` again
- If you have a Hot Spare ready continue to the next step. Otherwise power down the system and swap the defective disk.
  - After swapping the drive in the system, login and navigate to Storage > `Disks` to verify the new disk is present
  - After confirming the disk is present, navigate back to the `Manage Devices` section of your ZFS pool and expand the view for VDEVs to see all the disks that are members
- Select the failed or missing disk and under "Disk Info" select `Replace`
- Select the replacement disk in the drop down and click `Replace Disk`

Note: Replacing a disk will trigger a Resilvering operation on the pool. This can take many hours and potentially days to complete depending on the amount of data in the pool.

