## NixOS Lima config

My NixOS lima config based on <https://github.com/nixos-lima/nixos-lima-config-sample/tree/e452960dc46fef34435b3b14279d88a7f460156e>.
I want this config to be within my config/dotfiles directory, so I didn't fork their repo.
Inspiration and information also comes from:

- <https://www.joshkasuboski.com/posts/nix-dev-environment/>
- <https://jvns.ca/blog/2023/07/10/lima--a-nice-way-to-run-linux-vms-on-mac/>
- <https://www.metachris.dev/2025/11/sandbox-your-ai-dev-tools-a-practical-guide-for-vms-and-lima/>

### Installation

Install `lima` and `just`.
With `brew`, this would be

```sh
brew install lima just
```

Additionally, enable the VM to see specific directories by replacing `mounts` in `nixos.yaml` with paths on the host and VM.
Example:

```yaml
mounts:
  - location: "~/git/datastar-f-sharp-experiment"
    mountPoint: "/home/{{.User}}.guest/git/datastar-f-sharp-experiment"
    writable: true
  - location: "~/.dotfiles"
    mountPoint: "/home/{{.User}}.guest/.dotfiles"
    writable: false
```

### VM creation

Run

```sh
just create
just shell
```

### Convenient VM and Ghostty integration

As much as I like zellij and tmux, I like [Aerospace](https://github.com/nikitabobko/AeroSpace) more.
I want to open new tabs and windows as actual tabs and windows rather than virtual panes and windows within a multiplexer.
However, the default Ghostty new tab and new window behaviors open on my host machine rather than within the VM.

`just ty` opens up a new Ghostty window configured such that new tabs and windows all start within the VM and within a specified directory if given.
One difference from a native experience: if I move to a sub-directory and hit Command+n, the new window will open in the sub-directory.
In this setup, the new window will open up in the original specified path, not the sub-directory.
(This is good enough to me, and is similar to what the Codex desktop app does when connected to a remote computer.)

### Coding agents and updates

This setup uses a pinned stable nix version.
I tried using unstable nixpkgs to get the latest and greatest coding agents, but it was still behind the most recent releases, regrettably resulting in GPT-6 being available locally on my host machine but not when remoting into this dev box.

To try to get the latest and greatest agent harnesses earlier than nixpkgs, I download and manage them through `mise` (which I also like to use to manage language servers (or other tooling that Nix doesn't exactly have right for me, like when I tried to use [typeshare](https://github.com/1Password/typeshare) in a project and only Go was supported in nix's version)).

To update tools managed by `mise`, edit either the files on the host and run `just update-mise-tools` or run `mise upgrade` from within the VM.
Note that you will need to edit the appropriate config file if there are version constraints for your tools: `guest-mise.toml` if running from the host; or the VM user's global mise config (normally `~/.config/mise/config.toml`) if already shell'ed into the VM.

### Adding and configuring packages

I've tried to arrange this so you really only need to edit `packages.nix`.
There's a simple list to add programs that don't need major integrations (`helix` or `jj`, for example), but there's also space to configure programs that need to integrate with other programs.
For example, my configuration customizes the default shell experience with `fish`, `atuin`, `starship`, etc.
This require some integration points, so we usually `.enable` them instead of adding them to the flat list.

Search the [package list](https://search.nixos.org/packages) and the [options list](https://search.nixos.org/options) for package names and options to configure them if they require more integrations to function properly.

### Differences from the sample config

- Rather than using home-manager, I rely on `stow` for a majority of my dotfile management, which is what I use in other environments.
- `just` rather than setup shell scripts for provisioning and updates
- Focuses on my user, name, and architecture rather than being more general purpose.
- Only share specific directories (none by default) rather than giving access to all of my computer.
- Packages and their shell integration are together in `packages.nix`.
