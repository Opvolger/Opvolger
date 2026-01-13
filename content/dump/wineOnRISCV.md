# WINE on RISC-V

[link](https://www.jeffgeerling.com/blog/2025/build-box64-box32-x86-emulation-on-risc-v-linux#comments)

```bash
cd ~/Downloads
wget https://github.com/Kron4ek/Wine-Builds/releases/download/10.0/wine-10.0-amd64-wow64.tar.xz
tar -xvf wine-10.0-amd64-wow64.tar.xz
mv wine-10.0-amd64-wow64 wine

sudo ln -s ~/Downloads/wine/bin/wine /usr/local/bin/wine
sudo ln -s ~/Downloads/wine/bin/wineserver /usr/local/bin/wineserver
sudo ln -s ~/Downloads/wine/bin/wineboot /usr/local/bin/wineboot
sudo ln -s ~/Downloads/wine/bin/wine64 /usr/local/bin/wine64

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/bin/winetricks

sudo apt install cabextract
winetricks corefonts dxvk vkd3d
# or ??
box64 winetricks corefonts dxvk vkd3d
```
