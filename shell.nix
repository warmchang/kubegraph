{
  pkgs,
  ...
}:
rec {
  default = pkgs.mkShell {
    nativeBuildInputs = [
      # keep-sorted start
      (pkgs.mkGoEnv { pwd = ./.; })
      pkgs.goreleaser
      pkgs.remake
      pkgs.unstable.go
      # keep-sorted end
    ];
  };

  ci = default.overrideAttrs (
    final: prev: {
      nativeBuildInputs = [
        # keep-sorted start
        # keep-sorted end
      ]
      ++ prev.nativeBuildInputs;
    }
  );

  terminal = default.overrideAttrs (
    final: prev: {
      nativeBuildInputs = [
        # keep-sorted start
        pkgs.gomod2nix
        pkgs.gotestdox
        pkgs.nix-update
        pkgs.unstable.golangci-lint
        pkgs.unstable.gotests
        pkgs.unstable.gotools
        # keep-sorted end
      ]
      ++ prev.nativeBuildInputs;
    }
  );
}
