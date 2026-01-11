# ls aliases
if [ "$(command -v eza)" ]
    alias ls='eza'
end

export EDITOR="hx"

if status is-interactive
    starship init fish | source
    [ "$(command -v atuin)" ] && eval "$(atuin init fish)"
    mise activate fish | source
end
