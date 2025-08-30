# Steganography & Forensics (Week 7)

## Objective
Hide text inside a JPG, store on NTFS partition, delete it, and recover using FTK Imager/Autopsy. Extract hidden data from the recovered file.

## Create Disk & Partition (Lab)
```bash
# Create a 2GB raw image
qemu-img create -f raw /tmp/ntfs2g.img 2G
sudo losetup -fP /tmp/ntfs2g.img
LOOP=$(losetup -j /tmp/ntfs2g.img | cut -d: -f1)
sudo mkfs.ntfs -F ${LOOP}
sudo mkdir -p /mnt/ntfs2g && sudo mount ${LOOP} /mnt/ntfs2g
```

## Embed Data
```bash
sudo apt install -y steghide
echo "SECRET_MESSAGE" > hidden.txt
steghide embed -cf cover.jpg -ef hidden.txt -p pass123
cp cover.jpg /mnt/ntfs2g/cover.jpg
sync
rm -f /mnt/ntfs2g/cover.jpg
sudo umount /mnt/ntfs2g && sudo losetup -d ${LOOP}
```

## Forensics
- Load `/tmp/ntfs2g.img` in FTK Imager or Autopsy.
- Recover deleted `cover.jpg`, then:
```bash
steghide extract -sf cover.jpg -p pass123
cat hidden.txt
```

## Deliverables
- Recovered file + extracted message screenshots.

