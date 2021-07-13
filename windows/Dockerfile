
FROM ubuntu:latest
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN  echo "deb http://deb.debian.org/debian/ bullseye main non-free" | tee -a /etc/apt/sources.list \
 &  echo "deb-src http://deb.debian.org/debian/ bullseye main non-free"  | tee -a /etc/apt/sources.lists

RUN apt-get update -y && apt-get upgrade -y \
      apt-get install -y qemu-kvm  \
      libvirt-daemon-system \
      libvirt-dev \
      curl \
      net-tools \
      jq \
      autoclean \
      autoremove

RUN apt-get -y  install rdesktop

      qemu-system-x86_64 \
      -append 'root=/dev/vda console=ttyS0' \
      -drive file='rootfs.ext2.qcow2,if=virtio,format=qcow2'  \
      -enable-kvm \
      -kernel 'bzImage' \
      -nographic


RUN qemu-img create -f qcow2 hdd.img 40G

RUN sudo qemu-system-x86_64 -enable-kvm \
        -machine q35 -smp sockets=1,cores=1,threads=2 -m 2048 \
        -usb -device usb-kbd -device usb-tablet -rtc base=localtime \
        -net nic,model=virtio -net user,hostfwd=tcp::4444-:4444 \
        -drive file=hdd.img,media=disk,if=virtio \
        -drive file=Win10_1809Oct_English_x32.iso,media=cdrom \
        -drive file=virtio-win-0.1.141.iso,media=cdrom 

COPY startup.sh
ENTRYPOINT ["/startup.sh"]

#exec qemu-system-x86_64 -m 3000 \
# -cpu Penryn,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check,\
# -machine q35,accel=kvm:tcg -smp 4,cores=4 \
# -usb -device usb-kbd -device usb-tablet \ 
# -device 'isa-applesmc,osk=ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc' \
# -drive if=pflash,format=raw,readonly,file=/home/arch/OSX-KVM/OVMF_CODE.fd \
# -drive if=pflash,format=raw,file=/home/arch/OSX-KVM/OVMF_VARS-1024x768.fd \
# -smbios type=2 -audiodev alsa,id=hda -device ich9-intel-hda \
# -device hda-duplex,audiodev=hda \
# -device ich9-ahci,id=sata \
# -drive id=OpenCoreBoot,if=none,snapshot=on,format=qcow2,file=/home/arch/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2 \
# -device ide-hd,bus=sata.2,drive=OpenCoreBoot \
# -device ide-hd,bus=sata.3,drive=InstallMedia \
# -drive id=InstallMedia,if=none,file=/home/arch/OSX-KVM/BaseSystem.img,format=qcow2 \
# -drive id=MacHDD,if=none,file=/home/arch/OSX-KVM/mac_hdd_ng.img,format=qcow2 \
# -device ide-hd,bus=sata.4,drive=MacHDD -netdev user,id=net0,hostfwd=tcp::10022-:22,hostfwd=tcp::5900-:5900, \
# -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:09:49:17 \
# -monitor stdio -vga vmware '"-display' none -vnc '0.0.0.0:99,password='\''on'\''"'

# sudo docker run --privileged -it --name ubuntukvm --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN ubuntu:18.04 /bin/bash

# sudo qemu-system-x86_64 -enable-kvm \
#        -machine q35 -smp sockets=1,cores=1,threads=2 -m 2048 \
#        -usb -device usb-kbd -device usb-tablet -rtc base=localtime \
#        -net nic,model=virtio -net user,hostfwd=tcp::4444-:4444 \
#        -drive file=snapshot.img,media=disk,if=virtio \
#        -loadvm windows

#qemu-system-x86_64  \
#-m 1024  \
#-cpu qemu64  \
#-smp 2  \
#-netdev vde,id=t0,sock=/tmp/myswitch  \
#-device e1000,netdev=t0,mac=52:54:00:12:34:50  \
#-drive file=/qnx/qnx_vm_x86_64-qemu.img  \
#-D /var/log/qemu_err.log \
#-serial file:/var/log/qemu_out.log  \
#-display none -daemonize


#apt-get update -y
#apt-get install -y qemu-system-x86
#qemu-system-x86_64 \
#  -append 'root=/dev/vda console=ttyS0' \
#  -drive file='rootfs.ext2.qcow2,if=virtio,format=qcow2'  \
#  -enable-kvm \
#  -kernel 'bzImage' \
#  -nographic 
