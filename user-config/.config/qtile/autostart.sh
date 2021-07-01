#! /bin/bash 
#lxsession &
#picom --experimental-backend &
#xss-lock -- /home/dominik/.local/bin/screensaver &
pasystray &
#cmst &
##nm-applet &
#blueman-applet &
#xfce4-power-manager &
gnome-keyring &
nitrogen --restore &
#nextcloud &
#xclickroot -r xmenu/xmenu.sh &
#v4l2-ctl -v width=1920,height=1080,pixelformat=H264 &
sysctl kernel.unprivileged_userns_clone=1q &
setcap cap_net_bind_service=+ep `readlink -f \`which node\`` &
#systemctl start wpa_supplicant &
#system-config-printer-applet
#rfkill unblock wlan 
