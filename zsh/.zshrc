
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias code="/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron"
alias dev="nix develop --command zellij"

eval "$(starship init zsh)"
