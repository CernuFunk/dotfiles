# Script per far partire sway alla login

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	export _JAVA_AWT_WM_NONREPARENTING=1
	exec mako
	exec sway
fi
