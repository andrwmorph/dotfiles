#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#Merge dem resources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#BDF  LICENSE.txt  PCF  PSF  README.rst
twmnd &

xset +fp /home/andrew/.fonts/Meslo/
xset +fp /home/andrew/.fonts/Terminus/BDF
xset +fp /home/andrew/.fonts/Terminus/PCF
xset +fp /home/andrew/.fonts/Terminus/PSF
for dir in /usr/share/fonts/ ; do if [  -d  "$dir"  ];then xset +fp "$dir" ;fi; done && xset fp rehash


#echo "Starting at $(date)" >> ~/.config/i3/logfile
#exec /usr/bin/i3 -V -d all >> ~/.config/i3/logfile
#exec compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc -b
#eval $(cat ~/.fehbg)
#exec xset dpms 600

#exec compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc -b
#exec compton -c -f -b
exec herbstluftwm --locked
#exec dbus-launch --exit-with-session herbstluftwm --locked
