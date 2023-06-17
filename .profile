# Script per far partire sway alla login

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	export _JAVA_AWT_WM_NONREPARENTING=1
     # aggiunto -d > sway.log 2>&1 per problema di tastiera non funzionante
     # da capire se deve rimanere oppure no
	exec sway -d > sway.log 2>&1
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
