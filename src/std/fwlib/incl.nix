# SPDX-FileCopyrightText: 2022 The Standard Authors
# SPDX-FileCopyrightText: 2022 Michael Fellinger <https://manveru.dev/>
#
# SPDX-License-Identifier: MIT
{lib}: let
  l = lib.lib // builtins;
in
  # Keep the string-based API; filesets require paths and omit empty directories.
  l.warn "std.incl is deprecated; use lib.fileset.toSource instead." {
    debug = false;
    __functor = {debug, ...}: src: allowedPaths: let
      src' = l.unsafeDiscardStringContext (toString src);
      paths = map (path: let
        path' = l.unsafeDiscardStringContext (toString path);
      in
        if l.hasPrefix l.storeDir path'
        then path'
        else src' + "/${path'}")
      allowedPaths;
    in
      l.cleanSourceWith {
        name = "incl";
        inherit src;
        filter = path: type:
          l.traceIf debug "incl: ${type} ${path}" (
            l.any (prefix:
              path
              == prefix
              || l.hasPrefix "${prefix}/" path
              || (type == "directory" && l.hasPrefix "${path}/" prefix))
            paths
          );
      };
  }
