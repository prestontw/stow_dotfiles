alias code="/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron"
alias dev="nix develop --command zellij"
export PATH="$PATH:~/.docker/bin"

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
