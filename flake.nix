{
  description = "Shell of Former Self - A shell CLI tool with various commands.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages = {
        default = pkgs.stdenv.mkDerivation {
          pname = "shellOfFormerSelf";
          version = "1.0.0";
          src = self;

          buildInputs = [ pkgs.bash pkgs.tmux pkgs.fzf ];
          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin
            cp $src/*.sh $out/bin/
            chmod +x $out/bin/*.sh
            mv $out/bin/cli.sh $out/bin/shellOfFormerSelf

            # Wrap the main script to include dependencies in PATH
            ${pkgs.makeWrapper}/bin/makeWrapper $out/bin/shellOfFormerSelf $out/bin/shellOfFormerSelf \
              --prefix PATH : "${pkgs.coreutils}/bin:${pkgs.bash}/bin:${pkgs.tmux}/bin:${pkgs.fzf}/bin"
          '';
        };
      };

      apps = {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/shellOfFormerSelf";
        };
      };
    });
}
