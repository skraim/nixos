{ config, ... }:

{
  programs.git = {
    enable = true;
    userName = "Artem";
    userEmail = builtins.readFile config.sops.secrets.personal_email.path;
    includes = [
      {
        condition = "gitdir:~/projects/lw/";
        contents = {
          user.name = builtins.readFile config.sops.secrets.git_name_lw.path;
          user.email = builtins.readFile config.sops.secrets.git_email_lw.path;
        };
      }
      {
        condition = "gitdir:~/projects/dl/";
        contents = {
          user.name = builtins.readFile config.sops.secrets.git_name_dl.path;
          user.email = builtins.readFile config.sops.secrets.git_email_dl.path;
        };
      }
      {
        condition = "gitdir:~/projects/bb/";
        contents = {
          user.name = builtins.readFile config.sops.secrets.git_name_dh.path;
          user.email = builtins.readFile config.sops.secrets.git_email_dh.path;
        };
      }
      {
        condition = "gitdir:~/projects/dh/";
        contents = {
          user.name = builtins.readFile config.sops.secrets.git_name_dh.path;
          user.email = builtins.readFile config.sops.secrets.git_email_dh.path;
        };
      }
      {
        condition = "gitdir:~/projects/sc/";
        contents = {
          user.name = builtins.readFile config.sops.secrets.git_name_sc.path;
          user.email = builtins.readFile config.sops.secrets.git_email_sc.path;
        };
      }
    ];
  };
}
