---
date: 2025-01-31
author: Bas Magré
categories: ["RISC-V"]
tags: ["starfive-visionfive-2", "RISC-V"]
title: Compile halflife on RISC-V
---
## Intro

for more information see:

- [xash3d-fwgs](https://github.com/FWGS/xash3d-fwgs)
- [hlsdk-portable](https://github.com/FWGS/hlsdk-portable)

I have a StarFive VisionFive 2 with an AMD GPU (m2 -> PCI-e). This is running Ubuntu 24.10 with own build kernel 6.13.0. (default RISC-V + AMDGPU drivers). How i maked the kernel see [OpenSUSEATIRadeonR9_290_mainline.md](OpenSUSEATIRadeonR9_290_mainline.md). How my build is running [video](https://www.youtube.com/watch?v=Jp0ZPA4IQGw).

command i used (maybe you need to install some packages):

```bash
# install some dev packages
sudo apt install git build-essential python3 libsdl2-dev libfontconfig-dev libfreetype-dev libopus-dev libbz2-dev

# get the code (incl. sub repo's)
git clone --recursive https://github.com/FWGS/xash3d-fwgs.git
git clone --recursive https://github.com/FWGS/hlsdk-portable.git

# create dir where we will install hl
mkdir /home/ubuntu/hl

# build Xash3D (compatibility with Half-Life Engine/GoldSource)
cd xash3d-fwgs/
./waf configure -8
./waf build
./waf install --destdir=/home/ubuntu/hl
cd ..

# build the game hl game
cd hlsdk-portable
./waf configure -T release -8
./waf
cd ..

# now copy the valve folder of the half-Life install from your steam isntall i have it installed on my main machine and copy it with scp. You can also copy the folder with a usb stick from a windows machine for example.
scp -r opvolger@192.168.2.41:/home/opvolger/.steam/steam/steamapps/common/Half-Life/valve /home/ubuntu/hl

# we have build are own hl game (code only), we need to copy it OVER the value dir we just copied.

cp -r hlsdk-portable/build/* /home/ubuntu/hl/valve/

# the new builded libs are in dir cl_dll but must be in cl_dlls.
# So we delete the copied cl_dlls from steam and rename the cl_dll to cl_dlls
rm hl/valve/cl_dlls -rf
mv hl/valve/cl_dll hl/valve/cl_dlls

# now start the game!
cd hl
./xash3d 
```

end result: [video of playing hl on RISC-V](https://youtu.be/5Yo_sljTSBQ)
