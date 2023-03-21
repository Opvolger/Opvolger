# Ubuntu on VisionFive 2

added ssh key, enabled sshd root inlog

`autorized_keys`

## Kernel stuuf for snap

Device Drivers -> 
    Block devices -> 
      <*> RAM block device support
File systems  -> 
    Miscellaneous filesystems ->
      <*> SquashFS 4.0 - Squased file system support
      <*> Squashfs XATTR support
      <*> Include support for ZLIB compressed file systems
      <*> Include support for LZ4 compressed file systems
      <*> Include support for LZO compressed file systems
      <*> Include support for XZ compressed file systems
      <*> Include support for ZSTD compressed file systems

## fix ubuntu-advantage-tools hang

```bash
rm /var/lib/dpkg/info/ubuntu-advantage-tools.postinst
```

## Network

Fix network manager in KDE

```bash
nano /etc/netplan/01-network-manager-all.yaml
```

```yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
```

## kde install and other stuff

```bash
sudo apt install kde-standard,libsdl2-dev,libxml2,libcurl4-gnutls-dev,libopenal-dev,neofetch,ubuntu-dev-tools
```

## fix snapd

```bash
sudo apt purge snapd
sudo apt install snapd plasma-discover-backend-snap
```
