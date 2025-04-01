{ pkgs, config, lib, ... }:
let
  cfg = config.programs.cava;

  iniFmt = pkgs.formats.ini { };
in {
  meta.maintainers = [ lib.maintainers.bddvlpr ];

  options.programs.cava = {
    enable = lib.mkEnableOption "Cava audio visualizer";

    package = lib.mkPackageOption pkgs "cava" { nullable = true; };

    settings = lib.mkOption {
      type = iniFmt.type;
      default = { };
      example = lib.literalExpression ''
        {
          general.framerate = 60;
          input.method = "alsa";
          smoothing.noise_reduction = 88;
          color = {
            background = "'#000000'";
            foreground = "'#FFFFFF'";
          };
        }
      '';
      description = ''
        Settings to be written to the Cava configuration file. See
        <https://github.com/karlstav/cava/blob/master/example_files/config> for
        all available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile."cava/config" = lib.mkIf (cfg.settings != { }) {
      text = ''
        ; Generated by Home Manager

        ${lib.generators.toINI { } cfg.settings}
      '';
    };
  };
}
