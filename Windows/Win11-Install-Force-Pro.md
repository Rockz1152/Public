# Force Install Professional Edition

- Sometimes an OEM BIOS contains a Home Edition key and makes it difficult to clean install Professional Edition.
- You can create two files on the Windows install media to force install Professional Edition.
- The two files must go inside the `sources` folder on the USB drive.

File: `ei.cfg.`
```
[EditionID]
Professional

[Channel]
Retail

[VL]
0
```

File: `FID.txt`
```
[PID]
Value=VK7JG-NPHTM-C97JM-9MPGT-3V66T
```

Boot the USB drive and install Windows.
