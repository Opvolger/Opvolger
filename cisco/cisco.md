# Cisco switch

type: cisco ws-c3650-48ts

Cisco Catalyst 3650-48TS-?

Get current image:
https://community.cisco.com/t5/switching/copying-ios-from-switch-to-usb-drive/td-p/4447090

re-pack:
https://github.com/nccgroup/asafw/tree/master

https://www.ismoothblog.com/2019/07/access-cisco-switch-serial-console-linux.html

9600 rate

https://www.reddit.com/r/Cisco/comments/18jen3k/catalyst_3650_switches_bricked_cisco_wont_honor/

https://community.cisco.com/t5/switching/catalyst-3650-stuck-on-boot-loader/td-p/2804188

Hold the MODE button while you power it on

https://www.lrqa.com/en/cyber-labs/cve-2024-20356-jailbreaking-a-cisco-appliance-to-run-doom/

Crash mode:
https://github.com/Fz3r0/Fz3r0/blob/main/Networking/Knowledge/Troubleshooting/Boot-From-Init-BIN_&_Restore_Device_from_crash.md


```bash
Booting...
Interface GE 0 link down***ERROR: PHY link is down
Reading full image into memory...........................................................................................................................................................................................................................................................................................................................................................................................................done
Bundle Image
--------------------------------------
Kernel Address    : 0x5342d674
Kernel Size       : 0x365e6a/3563114
Initramfs Address : 0x537934de
Initramfs Size    : 0x16dc292/23970450
Compression Format: mzip

Bootable image at @ ram:0x5342d674
Bootable image segment 0 address range [0x81100000, 0x81bffb30] is in range [0x80180000, 0x90000000].
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
File "flash:cat3k_caa-universalk9.16.06.04a.SPA.bin" uncompressed and installed, entry point: 0x816e02d0
Loading Linux kernel with entry point 0x816e02d0 ...
Bootloader: Done loading app on core_mask: 0xf

### Launching Linux Kernel (flags = 0x5)

Inst 0 Get kvaddr 0x80011c00f0000000
If this is not emulator, STOP, check ERS for new asic revid
Inst 0 Get kvaddr 0x80011c00f0000000
Inst 0 Get kvaddr 0x80011c00f0000000
Inst 1 Get kvaddr 0x80011c00f8000000
If this is not emulator, STOP, check ERS for new asic revid
Inst 1 Get kvaddr 0x80011c00f8000000
Inst 1 Get kvaddr 0x80011c00f8000000
oobnd:
/scratch/mcpre/release/BLD-V16_06_04A_FC3/binos/drivers/kernel/obj-mips64_cge7-edison/doppler/oobnd/src/oobnd.c:oobnd_module_init: silent roll checkpoint

/scratch/mcpre/release/BLD-V16_06_04A_FC3/binos/drivers/kernel/obj-mips64_cge7-edison/doppler/oobnd/src/oobhal.c:oobhal_init_module: silent roll checkpoint
contdev.ko loaded. Date Oct 27 2018 00:38:15
Copyright (c) 2011, 2014-2015 by cisco Systems, Inc. All rights reserved
contdev: reg: lsmpi_contdev_register_handlers dereg: lsmpi_contdev_deregister_handlers
contdev: reg: lsmpi_contdev_register_handlers dereg: lsmpi_contdev_deregister_handlers
contdev driver initialized.
ccccccetjid
Waiting for 120 seconds for other switches to boot                                                                                                                
                                                                                                                                                                  
Both links down, accelerating discovery and not waiting for other switches                                                                                        
Switch number is 2                                                                                                                                                
                                                                                                                                                                  
              Restricted Rights Legend                                                                                                                            
                                                                                                                                                                  
Use, duplication, or disclosure by the Government is                                                                                                              
subject to restrictions as set forth in subparagraph                                                                                                              
(c) of the Commercial Computer Software - Restricted                                                                                                              
Rights clause at FAR sec. 52.227-19 and subparagraph                                                                                                              
(c) (1) (ii) of the Rights in Technical Data and Computer                                                                                                         
Software clause at DFARS sec. 252.227-7013.                                                                                                                       
                                                                                                                                                                  
           cisco Systems, Inc.                                                                                                                                    
           170 West Tasman Drive                                                                                                                                  
           San Jose, California 95134-1706                                                                                                                        
                                                                                                                                                                  
                                                                                                                                                                  
                                                                                                                                                                  
Cisco IOS Software [Everest], Catalyst L3 Switch Software (CAT3K_CAA-UNIVERSALK9-M), Version 16.6.4a, RELEASE SOFTWARE (fc3)                                      
Technical Support: http://www.cisco.com/techsupport                                                                                                               
Copyright (c) 1986-2018 by Cisco Systems, Inc.                                                                                                                    
Compiled Fri 26-Oct-18 18:32 by mcpre



Cisco IOS-XE software, Copyright (c) 2005-2018 by cisco Systems, Inc.                                                                                             
All rights reserved.  Certain components of Cisco IOS-XE software are                                                                                             licensed under the GNU General Public License ("GPL") Version 2.0.  The                                                                                           software code licensed under GPL Version 2.0 is free software that comes                                                                                          with ABSOLUTELY NO WARRANTY.  You can redistribute and/or modify such                                                                                             GPL code under the terms of GPL Version 2.0.  For more details, see the                                                                                           documentation or "License Notice" file accompanying the IOS-XE software,                                                                                          or the applicable URL provided on the flyer accompanying the IOS-XE                                                                                               software.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             % Checking backup nvram                                                                                                                                           % No config present. Using default config                                                                                                                                                                                                                                                                                                                                                                                                                                                             FIPS: Flash Key Check : Begin                                                                                                                                     FIPS: Flash Key Check : End, Not Found, FIPS Mode Not Enabled                                                                                                                                                                                                                                                                       This product contains cryptographic features and is subject to United                                                                                             States and local country laws governing import, export, transfer and                                                                                              use. Delivery of Cisco cryptographic products does not imply                                                                                                      third-party authority to import, export, distribute or use encryption.                                                                                            Importers, exporters, distributors and users are responsible for                                                                                                  compliance with U.S. and local country laws. By using this product you                                                                                            agree to comply with applicable laws and regulations. If you are unable                                                                                           to comply with U.S. and local laws, return this product immediately.                                                                                                                                                                                                                                                                A summary of U.S. laws governing Cisco cryptographic products may be found at:                                                                                    http://www.cisco.com/wwl/export/crypto/tool/stqrg.html                                                                                                                                                                                                                                                                              If you require further assistance please contact us by sending email to                                                                                           export@cisco.com.                      

.....


Would you like to enter basic management setup? [yes/no]: yes                                                                                                     
Configuring global parameters:                                                                                                                                    
                                                                                                                                                                  
  Enter host name [Switch]: opvolger                                                                                                                              
                                                                                                                                                                  
  The enable secret is a password used to protect access to                                                                                                       
  privileged EXEC and configuration modes. This password, after                                                                                                   
  entered, becomes encrypted in the configuration.                                                                                                                
  Enter enable secret: ikkehier                                                                                                                                   
                                                                                                                                                                  
  The enable password is used when you do not specify an                                                                                                          
  enable secret password, with some older software versions, and                                                                                                  
  some boot images.                                                                                                                                               
  Enter enable password: ikkehier                                                                                                                                 
% Please choose a password that is different from the enable secret                                                                                               
  Enter enable password: Ab12345!                                                                                                                                 
                                                                                                                                                                  
  The virtual terminal password is used to protect                                                                                                                
  access to the router over a network interface.                                                                                                                  
  Enter virtual terminal password: Ab12345!                                                                                                                       
Setup account for accessing HTTP server? [yes]:                                                                                                                   
    Username  [admin]:                                                                                                                                            
    Password  [cisco]:                                                                                                                                            
    Password is UNENCRYPTED.                                                                                                                                      
  Configure SNMP Network Management? [no]: yes                                                                                                                    
    Community string [public]:                                                                                                                                    
                                                                                                                                                                  
Current interface summary      

Enter interface name used to connect to the                                                                                                                       management network from the above interface summary: Vlan1                                                                                                        

Configuring interface Vlan1:
  Configure IP on this interface? [yes]: 
    IP address for this interface: 192.168.6.1
    Subnet mask for this interface [255.255.255.0] : 
    Class C network is 192.168.6.0, 24 subnet bits; mask is /24

The following configuration command script was created:

hostname opvolger
enable secret 5 $1$sFq.$EQlZMG9kXWikIiaY2UhvJ0
enable password Ab12345!
line vty 0 15
password Ab12345!
username admin privilege 15 password cisco
snmp-server community public
!
no ip routing

!
interface Vlan1
no shutdown
ip address 192.168.6.1 255.255.255.0
!
interface GigabitEthernet0/0
shutdown
no ip address
!

```
