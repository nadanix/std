{
  std,
  nixpkgs,
}: let
  # augmented std from the local cell
  inherit (std.lib) ops dev;
in
  assert !(ops ? lazyDerivation);
    builtins.mapAttrs (
      n: f:
        rec {
          mkMicrovm = let
            target = f {microvm.hypervisor = "qemu";};
          in
            target.config.microvm.runner.${target.config.microvm.hypervisor};
          mkOCI = let
            target = f {
              name = "docker.io/hello";
              entrypoint = nixpkgs.hello;
              meta = {
                description = "hello image";
                tags = ["test" "latest"];
              };
            };
            lazy = f {
              name = "docker.io/lazy-hello";
              entrypoint = throw "mkOCI evaluated its entrypoint";
              tag = "test";
              meta.description = "lazy image";
            };
          in {
            derivation = target;
            inherit (target) image meta;
            lazy = {
              drvType = lazy.type;
              inherit (lazy) image meta;
              forcesDerivation = !(builtins.tryEval lazy.drvPath).success;
            };
          };
          mkOperable = let
            target = f {
              package = nixpkgs.hello;
              runtimeScript = "exec ${nixpkgs.hello}/bin/hello";
              runtimeInputs = [nixpkgs.hello];
              debugInputs = [nixpkgs.coreutils];
              livenessProbe = nixpkgs.hello;
              readinessProbe = nixpkgs.hello;
              meta.description = "hello operable";
            };
            lazy = f {
              package = nixpkgs.hello;
              runtimeScript = throw "mkOperable evaluated its runtime script";
              meta.description = "lazy operable";
            };
          in {
            derivation = target;
            inherit (target) meta package runtime runtimeInputs debug debugInputs livenessProbe readinessProbe;
            runtimeShellPreserved = target.runtimeShell == nixpkgs.runtimeShell;
            lazy = {
              drvType = lazy.type;
              inherit (lazy) meta package;
              forcesDerivation = !(builtins.tryEval lazy.drvPath).success;
            };
          };
          mkStandardOCI = f {
            name = "docker.io/hello";
            operable = ops.mkOperable {
              package = nixpkgs.hello;
              runtimeScript = "exec ${nixpkgs.hello}/bin/hello";
            };
          };
          mkDevOCI = f {
            name = "docker.io/hello-dev";
            devshell = dev.mkShell {name = "Test";};
          };
          writeScript = let
            target = f {
              name = "hello-script";
              text = "exec ${nixpkgs.hello}/bin/hello";
            };
            lazy = f {
              name = "lazy-script";
              text = throw "writeScript evaluated its text";
            };
          in {
            derivation = target;
            inherit (target) meta;
            lazy = {
              drvType = lazy.type;
              inherit (lazy) meta;
              forcesDerivation = !(builtins.tryEval lazy.drvPath).success;
            };
          };
        }
      .${
          n
        }
      or "missing-test"
    )
    ops
