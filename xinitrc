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

twmnd &

#echo "Starting at $(date)" >> ~/.config/i3/logfile
#exec /usr/bin/i3 -V -d all >> ~/.config/i3/logfile
#exec compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc -b
#eval $(cat ~/.fehbg)
#exec xset dpms 600

#exec compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc -b
#exec compton -c -f -b
exec herbstluftwm --locked
