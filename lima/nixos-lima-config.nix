# After editing this file, run `just apply` on the host.
{ lib
, modulesPath
, pkgs
, ...
}:
let
  configureLimaUser = pkgs.writeShellScript "configure-lima-user" ''
    set -eu

    # Activation can run before Lima creates its user on the first boot.
    if [ ! -r /mnt/lima-cidata/lima.env ]; then
      exit 0
    fi
    lima_user="$(${pkgs.gnused}/bin/sed -n 's/^LIMA_CIDATA_USER=//p' /mnt/lima-cidata/lima.env)"
    if ! ${pkgs.coreutils}/bin/id "$lima_user" >/dev/null 2>&1; then
      exit 0
    fi

    # Reserve a stable range for rootless containers in this single-user VM.
    # usermod does not duplicate ranges that are already present.
    ${pkgs.shadow}/bin/usermod \
      --shell /run/current-system/sw/bin/fish \
      --add-subuids 100000-165535 \
      --add-subgids 100000-165535 \
      "$lima_user"
  '';
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "nix-dev";

  # lima-init creates the login user from Lima's boot-time metadata.
  users.mutableUsers = true;

  # Enable lima-init, lima-guestagent, other config needed for Lima support (via `nixos-lima.nixosModules.lima`)
  services.lima.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ssh
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # The Lima user already exists before this configuration is installed. Read
  # its name from Lima's metadata so this configuration works for any host user.
  systemd.services.lima-init.postStart = ''
    ${configureLimaUser}
  '';

  # NixOS rewrites /etc/subuid and /etc/subgid during activation, including for
  # mutable users. Restore Lima's mappings after the declarative user setup.
  system.activationScripts.limaUser = {
    deps = [ "users" ];
    text = ''
      ${configureLimaUser}
    '';
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      # limit entries so repeated `just apply`'s don't fill up boot
      configurationLimit = 1;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  system.stateVersion = "26.05";
}
