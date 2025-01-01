{ nixpkgs, system }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    bat
    bat-extras.batman
    diff-so-fancy
    fd
    ripgrep
    nushell
    starship
    vim
  ];
}
