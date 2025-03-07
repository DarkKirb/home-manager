{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.ripgrep;
in {
  meta.maintainers =
    [ lib.maintainers.khaneliman lib.hm.maintainers.pedorich-n ];

  options = {
    programs.ripgrep = {
      enable = mkEnableOption "Ripgrep";

      package = mkPackageOption pkgs "ripgrep" { nullable = true; };

      arguments = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = [ "--max-columns-preview" "--colors=line:style:bold" ];
        description = ''
          List of arguments to pass to ripgrep. Each item is given to ripgrep as
          a single command line argument verbatim.

          See <https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file>
          for an example configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home = let configPath = "${config.xdg.configHome}/ripgrep/ripgreprc";
    in mkMerge [
      { packages = lib.mkIf (cfg.package != null) [ cfg.package ]; }
      (mkIf (cfg.arguments != [ ]) {
        file."${configPath}".text = lib.concatLines cfg.arguments;

        sessionVariables."RIPGREP_CONFIG_PATH" = configPath;
      })
    ];
  };
}
