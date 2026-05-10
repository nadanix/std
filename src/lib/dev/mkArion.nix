let
  inherit (inputs.cells.std.errors) requireInput;
  inherit (requireInput "arion" "github:hercules-ci/arion" "std.lib.dev.mkArion") arion nixpkgs;

  inherit (nixpkgs) lib;

  arionDockerComposeModule = arion + /src/nix/modules/composition/docker-compose.nix;
  arionEvalComposition = arion + /src/nix/eval-composition.nix;

  disabledNotice = ''
    divnix/std disabled arion's nixos instrumentation.

    Standard being the horizontal integration layer it would be a layer violation
    to delegate integration to a commissioned tool.

    Doing this would reduce the mental clarity of std since a foreign integration
    pattern would have to be supported.

    If you want to create a container that uses NixOS + systemd as its init-system,
    please find out how it's done here:
      ${arion}/src/nix/modules/service/nixos-init.nix

    You can then use the normal container block type to create your image and
    pass it to your arion configuration.
  '';

  disabledArionModules = [
    # This warning-only module uses a Nix string form that is deprecated in
    # newer Nix. std disables Arion's NixOS instrumentation anyway, so avoid
    # importing it instead of merely disabling it after module loading.
    (arion + /src/nix/modules/service/check-sys_admin.nix)
    (arion + /src/nix/modules/service/nixos.nix)
    (arion + /src/nix/modules/service/nixos-init.nix)
    (arion + /src/nix/nixos/container-systemd.nix)
    (arion + /src/nix/nixos/default-shell.nix)
  ];

  disableNixosModule = {
    disabledModules = disabledArionModules;
    imports = [
      (lib.mkRemovedOptionModule ["nixos" "configuration"] disabledNotice)
      (lib.mkRemovedOptionModule ["nixos" "build"] disabledNotice)
      (lib.mkRemovedOptionModule ["nixos" "evaluatedConfig"] disabledNotice)
      (lib.mkRemovedOptionModule ["nixos" "useSystemd"] disabledNotice)
    ];
  };

  disabledArionModulePaths = map toString disabledArionModules;

  serviceModules =
    builtins.filter
    (module: !(builtins.elem (toString module) disabledArionModulePaths))
    (import (arion + /src/nix/modules/service/all-modules.nix));

  dockerComposeModule = compositionArgs @ {
    lib,
    config,
    pkgs,
    ...
  }: let
    service = {
      imports = [argsModule] ++ serviceModules;
    };
    argsModule = {name, ...}: {
      _file = toString arionDockerComposeModule;
      key = arionDockerComposeModule;

      config._module.args.pkgs = lib.mkDefault compositionArgs.pkgs;
      config.host = compositionArgs.config.host;
      config.composition = compositionArgs.config;
      config.service.name = name;
    };
  in {
    imports = [
      (arion + /src/nix/modules/lib/assert.nix)
      (lib.mkRenamedOptionModule ["docker-compose" "services"] ["services"])
    ];
    options = {
      out.dockerComposeYaml = lib.mkOption {
        type = lib.types.package;
        description = "A derivation that produces a docker-compose.yaml file for this composition.";
        readOnly = true;
      };
      out.dockerComposeYamlText = lib.mkOption {
        type = lib.types.str;
        description = "The text of out.dockerComposeYaml.";
        readOnly = true;
      };
      out.dockerComposeYamlAttrs = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        description = "The text of out.dockerComposeYaml.";
        readOnly = true;
      };
      docker-compose.raw = lib.mkOption {
        type = lib.types.attrs;
        description = "Attribute set that will be turned into the docker-compose.yaml file, using Nix's toJSON builtin.";
      };
      docker-compose.extended = lib.mkOption {
        type = lib.types.attrs;
        description = "Attribute set that will be turned into the x-arion section of the docker-compose.yaml file.";
      };
      services = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule service);
        description = "An attribute set of service configurations. A service specifies how to run an image as a container.";
      };
      docker-compose.volumes = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        description = "A attribute set of volume configurations.";
        default = {};
      };
    };
    config = {
      out.dockerComposeYaml = pkgs.writeText "docker-compose.yaml" config.out.dockerComposeYamlText;
      out.dockerComposeYamlText = builtins.toJSON config.out.dockerComposeYamlAttrs;
      out.dockerComposeYamlAttrs = config.assertWarn config.docker-compose.raw;

      docker-compose.raw = {
        services = lib.mapAttrs (_: c: c.out.service) config.services;
        x-arion = config.docker-compose.extended;
        volumes = config.docker-compose.volumes;
      };
    };
  };

  arionBuiltinModules =
    [dockerComposeModule]
    ++ builtins.filter
    (module: toString module != toString arionDockerComposeModule)
    (import (arion + /src/nix/modules.nix));

  evalArion = {
    modules ? [],
    uid ? "0",
    pkgs,
    hostNixStorePrefix ? "",
  }: let
    pkgs' =
      if builtins.typeOf pkgs == "path"
      then import pkgs
      else if builtins.typeOf pkgs == "set"
      then pkgs
      else builtins.abort "The pkgs argument must be an attribute set or a path to an attribute set.";

    composition = lib.evalModules {
      modules = [argsModule] ++ arionBuiltinModules ++ modules;
    };

    argsModule = {
      _file = toString arionEvalComposition;
      key = arionEvalComposition;
      config._module.args.pkgs = lib.mkIf (pkgs' != null) (lib.mkForce pkgs');
      config._module.args.check = true;
      config.host.nixStorePrefix = hostNixStorePrefix;
      config.host.uid = lib.toInt uid;
    };
  in
    composition
    // {
      inherit lib;
      inherit (composition._module.args) pkgs;
    };
in
  module:
    evalArion {
      modules = [disableNixosModule module];
      pkgs = nixpkgs;
    }
