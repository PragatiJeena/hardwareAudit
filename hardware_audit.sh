#!/bin/bash

EXPECTED_TIMEZONE="IST"
EXPECTED_OS_FAMILY="Red Hat"
EXPECTED_CPU_ARCH="x86_64"
EXPECTED_CPU_UTILIZATION_THRESHOLD=60
EXPECTED_RAM_UTILIZATION_THRESHOLD=60
EXPECTED_STORAGE_UTILIZATION_THRESHOLD=60

# Function to highlight output
highlight() {
  echo -e "\033[1;31m$1\033[0m"
}

######Server Uptime######
echo "Server Uptime:"
uptime

####### Last Server Reboot Timestamp#######3
echo -e "\nLast Server Reboot Timestamp:"
last reboot | head -n 1

######### Server Local Time Zone ########33
echo -e "\nServer Local Time Zone:"
TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3}')
if [[ $TIMEZONE == *"$EXPECTED_TIMEZONE"* ]]; then
  echo "$TIMEZONE"
else
  highlight "$TIMEZONE (NON-IST)"
fi

########### Last 10 installed packages with dates##########
echo -e "\nLast 10 Installed Packages with Dates:"
rpm -qa --last | head -n 10

# OS version
echo -e "\nOS Version:"
OS_VERSION=$(cat /etc/redhat-release)
if [[ $OS_VERSION == *"$EXPECTED_OS_FAMILY"* ]]; then
  echo "$OS_VERSION"
else
  highlight "$OS_VERSION (Different OS)"
fi

# Kernel version
echo -e "\nKernel Version:"
uname -r

# CPU - Virtual cores
echo -e "\nCPU - Virtual Cores:"
nproc

# CPU - Clock speed
echo -e "\nCPU - Clock Speed (MHz):"
lscpu | grep "CPU MHz" | awk '{print $3}'

# CPU - Architecture
echo -e "\nCPU - Architecture:"
CPU_ARCH=$(lscpu | grep "Architecture" | awk '{print $2}')
if [[ $CPU_ARCH == "$EXPECTED_CPU_ARCH" ]]; then
  echo "$CPU_ARCH"
else
  highlight "$CPU_ARCH (Different Architecture)"
fi

# Disk - Mounted/Unmounted volumes, type, storage
echo -e "\nDisk - Mounted/Unmounted Volumes, Type, Storage:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT

# Private and Public IP
echo -e "\nPrivate and Public IP:"
PRIVATE_IP=$(hostname -I)
PUBLIC_IP=$(curl -s ifconfig.me)
echo "Private IP: $PRIVATE_IP"
echo "Public IP: $PUBLIC_IP"

# Private and Public DNS or Hostname
echo -e "\nPrivate and Public DNS or Hostname:"
echo "Private DNS/Hostname: $(hostname)"
echo "Public DNS/Hostname: $(curl -s https://api.ipify.org)"

# Networking - Bandwidth
echo -e "\nNetworking - Bandwidth (using iftop):"
echo "Run 'sudo iftop' to view bandwidth usage"

# Networking - OS Firewall (Allowed Ports & Protocols)
echo -e "\nNetworking - OS Firewall (Allowed Ports & Protocols):"
sudo firewall-cmd --list-all

# Networking - Network Firewall (Allowed Ports & Protocols)
echo -e "\nNetworking - Network Firewall (Allowed Ports & Protocols):"
echo "Please refer to your network firewall documentation or tools"

# CPU - Utilization
echo -e "\nCPU - Utilization:"
CPU_UTILIZATION=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPU_UTILIZATION < $EXPECTED_CPU_UTILIZATION_THRESHOLD" | bc -l) )); then
  echo "$CPU_UTILIZATION% (Under threshold)"
else
  highlight "$CPU_UTILIZATION% (Exceeds threshold)"
fi

# RAM - Utilization
echo -e "\nRAM - Utilization:"
RAM_UTILIZATION=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$RAM_UTILIZATION < $EXPECTED_RAM_UTILIZATION_THRESHOLD" | bc -l) )); then
  echo "$RAM_UTILIZATION% (Under threshold)"
else
  highlight "$RAM_UTILIZATION% (Exceeds threshold)"
fi

#########Storage Utilization###########3
echo -e "\nStorage Utilization:"
df -h | awk '$NF=="/"{print $5}' | while read OUTPUT
do
  STORAGE_UTILIZATION=${OUTPUT%?}
  if (( STORAGE_UTILIZATION < EXPECTED_STORAGE_UTILIZATION_THRESHOLD )); then
    echo "$OUTPUT (Under threshold)"
  else
    highlight "$OUTPUT (Exceeds threshold)"
  fi
done

########### Highlight when current user password expiring###########
echo -e "\nCurrent User Password Expiry:"
chage -l $USER | grep "Password expires"

echo -e "\nAudit Completed!"

