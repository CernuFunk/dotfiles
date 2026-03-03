# Pipenv path
export PATH="$HOME/.local/bin:$PATH"
# Rbenv path
export PATH="$HOME/.rvm/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Secrets (token, chiavi API, ecc.)
[[ -f ~/.secrets ]] && source ~/.secrets


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
