# After editing this file, run `just apply` on the host.
{ pkgs, ... }:
{
  # Program modules below add their own packages; list other tools here.
  environment.systemPackages = with pkgs; [
    atuin
    difftastic
    ghostty.terminfo
    git
    helix
    jujutsu
    just
    mise
    nil
    nixpkgs-fmt
    nodejs_24
    stow
    watchexec
    zellij
  ];

  # Upstream binaries installed by mise use the conventional Linux loader.
  programs.nix-ld.enable = true;

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    mise activate fish | source
    # Keep Atuin reading the user config managed by Stow.
    atuin init fish | source
  '';
  programs.starship.enable = true;
  programs.direnv.enable = true;

  # Shims also make the agents available to non-interactive SSH commands.
  environment.extraInit = ''
    export PATH="''${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
  '';

  # limactl shell forwards TERM with its pseudo-terminal, but not COLORTERM.
  # Declare the VM's true-color support so Helix uses its full default theme.
  environment.sessionVariables = {
    COLORTERM = "truecolor";
    EDITOR = "hx";
    VISUAL = "hx";
    # Let mise own Claude Code updates, including the selected version.
    DISABLE_AUTOUPDATER = "1";
  };
}
