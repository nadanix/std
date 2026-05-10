{nixpkgs}: currentSystem: name: description: deps: command: args: let
  inherit (nixpkgs.${currentSystem}) pkgs;
  inherit (pkgs) lib;

  application = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = deps;
    text =
      ''
        if test -z "''${PRJ_ROOT:-}"; then
          echo "All Standard Block Type Actions require an environment that fulfills the PRJ Base Directiory Specification"
          echo "see: https://github.com/numtide/prj-spec"
          echo "Tip: To achieve that, you can enter a Standard direnv environment or run the action via the Standard CLI/TUI"
          exit 1
        fi

        # Action Code follows ...
      ''
      + command;
  };

  # `std` actions are executed through the derivation output path itself. Keep
  # that stable shape while delegating shell wrapping, runtime inputs, shell
  # dry-run, and shellcheck to nixpkgs' `writeShellApplication`.
  executable = pkgs.runCommandLocal name {} ''
    ln -s ${lib.getExe application} "$out"
  '';
in
  args
  // {
    inherit name description;
    command = executable;
  }
