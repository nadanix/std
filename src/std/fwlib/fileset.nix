{
  lib ? null,
  trivial,
  ...
}: let
  nixlib =
    if trivial ? lib && trivial.lib ? fileset
    then trivial.lib
    else if lib != null && lib ? lib && lib.lib ? fileset
    then lib.lib
    else throw "std.fileset: nixpkgs lib.fileset is required";

  inherit (builtins) storeDir trace unsafeDiscardStringContext;
  inherit (nixlib) cleanSourceWith fileset traceIf;
  inherit (nixlib.strings) hasPrefix;

  pretty = nixlib.generators.toPretty {};

  include = root: paths:
    fileset.toSource {
      inherit root;
      fileset = fileset.unions paths;
    };

  # Compatibility shim for the old divnix/incl API. New code should use
  # lib.fileset.toSource directly, or std.fileset.include for the common
  # root + union case. This shim intentionally preserves incl's permissive
  # string/sourceInfo API while removing the external divnix/incl input.
  compatIncl = debug: src: allowedPaths: let
    src' = unsafeDiscardStringContext (toString src);
    normalizedPaths =
      builtins.map (
        path: let
          path' = unsafeDiscardStringContext (toString path);
        in
          if hasPrefix storeDir path'
          then path'
          else src' + "/${path'}"
      )
      allowedPaths;
    patterns = traceIf debug "allowedPaths: ${pretty normalizedPaths}" (
      traceIf debug "src: \"${src'}\"" {
        prefixes = normalizedPaths;
      }
    );
    filter = path: fileType: let
      traceCandidate = traceIf debug "candidate ${fileType}: ${path}";
    in
      traceCandidate (
        builtins.any (
          prefix: let
            contains = fileType == "directory" && hasPrefix "${path}/" prefix;
            hit = prefix == path;
            child = hasPrefix "${prefix}/" path;
          in
            traceIf (debug && (hit || child || contains)) (
              if contains && !(hit || child)
              then "\trecurse as container for: ${prefix}"
              else if fileType == "directory"
              then "\trecurse on prefix: ${prefix}"
              else if fileType == "regular" && hit
              then "\tinclude on hit: ${prefix}"
              else if fileType == "regular" && child
              then "\tinclude on prefix: ${prefix}/"
              else "\tfile type '${fileType}' - will fail"
            )
            (hit || child || contains)
        )
        patterns.prefixes
      );
  in
    trace "std.incl is deprecated; use lib.fileset.toSource or std.fileset.include instead" (cleanSourceWith {
      name = "incl";
      inherit src filter;
    });

  incl = {
    debug = false;
    __functor = self: compatIncl (self.debug or false);
  };
in
  fileset
  // {
    inherit include incl;
  }
