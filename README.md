# hardwareAudit
Write a bash script to audit the following hardware spec in RHEL. The script should print out following specifications and also audit report should highlight specifications if they are not matching expected specifications

This script audits the hardware specifications of a RHEL system and highlights deviations from expected specifications.

#########Features###########3

---->Server Uptime
---->Last Server Reboot Timestamp
----> Server Local Time Zone
----> Last 10 Installed Packages with Dates
----> OS Version
----> Kernel Version
----->CPU - Virtual Cores
----> CPU - Clock Speed
----> CPU - Architecture
----> Disk - Mounted/Unmounted Volumes, Type, Storage
----->Private and Public IP
----> Private and Public DNS or Hostname
----> Networking - Bandwidth
----> Networking - OS Firewall (Allowed Ports & Protocols)
----> Networking - Network Firewall (Allowed Ports & Protocols)
----> CPU - Utilization
----> RAM - Utilization
---->Storage Utilization
---->Current User Password Expiry

## Prerequisites

Ensure you have the following commands available:
- `uptime`
- `last`
- `timedatectl`
- `rpm`
- `uname`
- `nproc`
- `lscpu`
- `lsblk`
- `hostname`
- `curl`
- `iftop`
- `firewall-cmd`
- `top`
- `free`
- `df`
- `chage`

## Usage

1. Make the script executable:
   ----> chmod +x hardware_audit.sh
    

2. Run the script:
   ----> sudo ./hardware_audit.sh


   Note: Running the script with `sudo` ensures it has the necessary permissions to gather all required information.

## Output

The script prints the audited hardware specifications to the console, highlighting any deviations from expected specifications.

## Notes

- The script uses `sudo` for some commands that require elevated permissions.
- Bandwidth usage requires running `iftop` manually as it provides real-time data.

