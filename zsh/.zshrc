alias code="/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron"
alias dev="nix develop --command zellij"
export EDITOR="hx"
export PATH="$PATH:$HOME/.orbstack/bin"

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(mise activate zsh)"
