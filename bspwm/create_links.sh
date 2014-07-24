#!/bin/bash
#Creates symlinks for all the dotfiles

CONFIGS_D="config/bspwm|.config/bspwm 
		 config/dwb|.config/dwb
		 config/interrobang|.config/interrobang
		 config/sxhkd|.config/sxhkd
		 config/termite|.config/termite
		 config/twmn|.config/twmn
		 panel|panel"
CONFIGS_F="config/compton.conf|.config/compton.conf
		 zsh/zshrc|.zshrc
		 xinitrc|.xinitrc
		 Xresources|.Xresources"

for FILE in $CONFIGS_D; do
		SRC="`pwd`/$(echo $FILE | cut -d'|' -f1)"
		DEST="$HOME/$(echo $FILE | cut -d'|' -f2)"
		[[ -d "$DEST" ]] && mv $DEST $DEST.orig
		ln -sf $SRC $DEST
done

for FILE in $CONFIGS_F; do
		SRC="`pwd`/$(echo $FILE | cut -d'|' -f1)"
		DEST="$HOME/$(echo $FILE | cut -d'|' -f2)"
		[[ -f "$DEST" ]] && mv $DEST $DEST.orig
		ln -sf $SRC $DEST
done
