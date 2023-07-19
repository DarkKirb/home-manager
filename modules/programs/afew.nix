{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.afew;

in {
  options.programs.afew = {
    enable = mkEnableOption "the afew initial tagging script for Notmuch";

    extraConfig = mkOption {
      type = types.lines;
      default = ''
        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]
        [InboxFilter]
      '';
      example = ''
        [SpamFilter]

        [Filter.0]
        query = from:pointyheaded@boss.com
        tags = -new;+boss
        message = Message from above

        [InboxFilter]
      '';
      description = ''
        Extra lines added to afew configuration file. Available
        configuration options are described in the afew manual:
        <https://afew.readthedocs.io/en/latest/configuration.html>.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.afew ];

    xdg.configFile."afew/config".text = ''
      # Generated by Home Manager.
      # See https://afew.readthedocs.io/

      ${cfg.extraConfig}
    '';
  };
}
