{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    handlr-regex
  ];

  xdg.configFile."handlr/handlr.toml".text = ''
      [[handlers]]
      exec = "chromium --profile-directory=\"Profile 1\" %u"
      regexes = [
        '(https://)?(.*\.)?figma\.com/*.',
        '${builtins.readFile config.sops.secrets.link_regex_dl1.path}',
        '${builtins.readFile config.sops.secrets.link_regex_dl2.path}',
      ]

      [[handlers]]
      exec = "chromium --profile-directory=\"Default\" %u"
      regexes = [
        '(https://)?(.*\.)?atlassian\.net/*.',
        '(https://)?(.*\.)?azure\.com/*.',
        '(https://)?(.*\.)?clickup\.com/*.',
        '(https://)?(.*\.)?slack\.com/*.',
        '${builtins.readFile config.sops.secrets.link_regex_sc.path}',
        '${builtins.readFile config.sops.secrets.link_regex_lw.path}',
      ]

      [[handlers]]
      exec = "orca-slicer %u"
      regexes = ['.+\.step']
  '';
}
