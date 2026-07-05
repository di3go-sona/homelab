#!/bin/bash
# Setup NFS automount for macOS
# Run with: sudo ./scripts/setup-nfs-macos.sh
set -e
MOUNT_NAME="HDD0"
NFS_SERVER="192.168.8.13"
NFS_PATH="/mnt/hdd0"
LOCAL_PATH="/Volumes/${MOUNT_NAME}"
echo "Setting up NFS automount for ${NFS_SERVER}:${NFS_PATH}"
# Add to auto_master if not present
if ! grep -q "auto_nfs" /etc/auto_master; then
    echo "/- auto_nfs -nobrowse,nosuid" | tee -a /etc/auto_master
    echo "Added auto_nfs to /etc/auto_master"
fi
# Create auto_nfs with Catalina+/Sonoma path trick
tee /etc/auto_nfs << EOF
/System/Volumes/Data/../Data/Volumes/${MOUNT_NAME} -fstype=nfs,noowners,nolockd,noresvport,hard,bg,intr,rw,tcp,nfc,resvport ${NFS_SERVER}:${NFS_PATH}
EOF
chmod 644 /etc/auto_nfs
echo "Created /etc/auto_nfs"
# Create mount point
mkdir -p "${LOCAL_PATH}"
echo "Created mount point: ${LOCAL_PATH}"
# Reload automount
automount -vc
echo ""
echo "Done! Access the share at: ${LOCAL_PATH}"
echo "Note: After macOS updates, you may need to re-run this script"
