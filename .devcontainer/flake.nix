{
  inputs = {
    # 1. Defined a "systems" inputs that maps to only ["x86_64-linux"]
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.url = "github:numtide/flake-utils";
    # 2. Override the flake-utils default to your version
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    # Now eachDefaultSystem is only using ["x86_64-linux"], but this list can also
    # further be changed by users of your flake.
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        formatter = pkgs.nixfmt;
        packages = {
          default = import ./shell.nix { inherit nixpkgs system; };
          image = pkgs.dockerTools.buildLayeredImage {
            name = "devcontainer";
            tag = "dev";
            fromImage = pkgs.dockerTools.pullImage {
              imageName = "docker.io/debian";
              imageDigest =
                "sha256:d365f4920711a9074c4bcd178e8f457ee59250426441ab2a5f8106ed8fe948eb";
              sha256 = "sha256-XTOxjlTJ1ov8a0hsxVqhkKyny+rRVph3L12JSJrSSiQ=";
            };
            config = {
              Cmd = [ "${pkgs.nushell}/bin/nu" ];
              User = "dev";
            };
            fakeRootCommands = ''
              #!${pkgs.bash}
              set -euo pipefail

              for file in /usr/bin/*; do
                ln -s $file "/bin/$(/bin/basename $file)"
              done

              for file in /usr/lib/*; do
                ln -s $file "/lib/$(/bin/basename $file)"
              done

              ${pkgs.dockerTools.shadowSetup}
              useradd --create-home --user-group --shell ${pkgs.nushell}/bin/nu dev
            '';
            enableFakechroot = true;
            contents = with pkgs; [
              bashInteractive
              bat
              bat-extras.batman
              diff-so-fancy
              fd
              ripgrep
              nushell
              starship
              vim
              zsh
              zsh-completions
            ];
          };
        };
      });
}
