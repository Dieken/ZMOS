# ZMOS - A small desktop operating system

Hats off to the Zilog Z80 and MOS 6502, experiment and see how usable a
FreeBSD based desktop operating system can be with some good small software.

## Philosophy and Principle

* No live CD, no OS installer, just a simple shell script to install required software
* As less system level customization as possible, the DE experience is limited to single user
* Balance between usability and disk & memory size, pick as suckless software as possible

## Run on VirtualBox/VMWare/Parallels

1. Adjust screen resolution for XDE:
    1. macOS: Check `System Preferences -> Displays -> Display` for your screen resolution, it's 1680x1050 by default on MacBook Pro 15-inch screen. If you use different resolution, you need customize `XDE/xde.conf` by `XDE/xde.conf.local`, notice the resolution for ZMOS is doubled because Apple Retina display runs "pixel doubled".
2. Install VirtualBox 6.1.10 or VMWare Fusion 11.5.5
3. To avoid conflict with X window manager hot keys, change Virtual Machine host key to not use <kbd>Command</kbd> or <kbd>Win</kbd>, you may use <kbd>Right_Command</kbd> + <kbd>Right_Option</kbd>.
4. Create FreeBSD 64bit VM, use UEFI firmware, change machine settings:
   * **VirtualBox**
      1. System -> Motherboard
         * Base Memory: >= 2048 MB
         * Enable EFI
         * Hardware Clock in UTC Time
      2. System -> Processor
         * Processor: >= 2
         * Enable Nested VT-x/AMD-V
      3. Display -> Screen
         * Video Memory: 128 MB
         * Graphics Controller: VMSVGA
         * Enable 3D Acceleration
   * **VMWare Fusion**
      1. Processors & Memory
         * Processors: >= 2
         * Memory: >= 2048 MB
         * Enable hypervisor applications in this virtual machine
         * Enable code profiling application in this virtual machine
         * Enable IOMMU in this virtual machine
      2. Keyboard & Mouse
         * select "Mac Profile" because "Profile - Default" has too many conflicts with i3 window manager
      3. Display
         * Enable "Accelerate 3D Graphics", select "Always Use High Performance Graphics" for "Battery life"
         * Enable "Use full resolutions for Retina display"
      4. Isolation
         * Enable Drag and Drop
         * Enable Copy and Paste
      5. Advanced
         * Cancel "Synchronize time" because FreeBSD has ntpd running
         * Enable "Pass power status to VM"
         * Fimware type: UEFI
   * **Parallels Desktop**
      1. At the last step of creating virtual machine, make sure to select "Customize settings before installation"
      2. In the configuration window:
         * Hardware -> Boot Order: Advanced Settings -> BIOS "EFI 64-bit"
         * Hardware -> CPU & Memory: Processors "2", Memory "2048 MB"
         * Hardware -> Graphics: Memory "512MB(Recommended)", Resolution "More Space"
      3. Parallels Desktop -> Preferences
         * Shortcuts -> macOS System Shortcuts: Send macOS system shortcuts "Always" (so that Ctrl-Space will be sent to FreeBSD)
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
7. After login X session, run `fcitx5-configtool` and select `Rime` to enable RIME for Fcitx.
