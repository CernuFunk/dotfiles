# Script per far partire sway alla login

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	export _JAVA_AWT_WM_NONREPARENTING=1
	exec sway
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
