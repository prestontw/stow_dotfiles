# After editing this file, run `just apply` on the host.
{ pkgs }:
with pkgs; [
  atuin
  difftastic
  ghostty.terminfo
  git
  helix
  jujutsu
  mise
  nil
  nixpkgs-fmt
  nodejs_24
  stow
  watchexec
  zellij
]

