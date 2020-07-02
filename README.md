# ZMOS - A small desktop operating system

Regards to Zilog Z80 and MOS 6502, experiment to see how usable a
FreeBSD based desktop operating system could be with some suckless
software.

## Philosophy and Principle

* No live CD, no OS installer, just a simple shell script to install required software
* As less system level customization as possible, the DE experience is limited to single user
* Balance between usability and disk & memory size, pick as suckless software as possible

## Run on VirtualBox

1. Adjust screen resolution for XDE:
    1. macOS: Check `System Preferences -> Displays -> Display` for your screen resolution, it's 1680x1050 by default on MacBook Pro 15-inch screen. If you use different resolution, you need customize `XDE/xde.conf` by `XDE/xde.conf.local`, notice the resolution for ZMOS is doubled because Apple Retina display runs "pixel doubled".
2. Install VirtualBox 6.1.10
3. To avoid conflict with X window manager hot keys, change Virtual Machine host key to not use <kbd>Command</kbd> or <kbd>Win</kbd>, you may use <kbd>Right_Command</kbd> + <kbd>Right_Option</kbd>.
4. Create FreeBSD 64bit VM, change machine settings:
   1. System -> Motherboard:
      * Base Memory: 2048 MB
      * Enable EFI
      * Hardware Clock in UTC Time
   2. System -> Processor:
      * Processor: 2
      * Enable Nested VT-x/AMD-V
   3. Display -> Screen
      * Video Memory: 128 MB
      * Graphics Controller: VMSVGA
      * Enable 3D Acceleration
5. Install FreeBSD 12.1, create a normal user
6. Download ZMOS/ to home directory, run commands below:
   ```sh
   ## as root
   ./XDE/install-xde.sh
   pw groupmod wheel -m YOUR-NON-ROOT-USER  # for VirtualBox clipboard sharing, window scaling
   pw groupmod video -m YOUR-NON-ROOT-USER  # access /dev/dri for Xorg 3D acceleration

   ## as your non-root user
   ./XDE/user-xde.sh

   reboot
   ```
