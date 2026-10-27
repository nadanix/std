{
  l,
  yants,
  paths,
}: {
  Cell = import ./cell.nix {
    inherit l;
    inherit (paths) cellPath cellBlockPath;
  };
  Target = log:
    with yants log;
    # unfortunately eval during check can cause infinite recursions
    # if blockType == "runnables" || blockType == "installables"
    # then attrs drv
    # else if blockType == "functions"
    # then attrs function
    # else throw "unreachable";
      attrs any;
  Systems = log: with yants log; list (enum "System" l.systems.doubles.all);
  BlockTypes = log:
    with yants log;
      list (struct "Cell Block" {
        name = string;
        type = string;
        __functor = option function;
        ci = option (attrs bool);
        cli = option bool;
        actions = option (functionWithArgs {
          inputs = false;
          target = false;
          fragment = false;
          fragmentRelPath = false;
          currentSystem = false;
        });
      });
  # Yants also accepts callable attrsets as functions; Cell Blocks do not.
  Block = log: block:
    if !l.isFunction block
    then throw "${log}: expected a Cell Block function, got ${l.typeOf block}."
    else
      with yants log;
        functionWithArgs {
          inputs = false;
          cell = false;
        }
        block;
  ActionCommand = log: with yants log; drv;
}
