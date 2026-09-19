{ pkgs, lib, ... }:

let 
  lua = lib.generators.mkLuaInline;
  mainMod = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.variables = ["--all"];

    settings = {
      monitor = [
        {
          output   = "eDP-1";
          mode     = "1920x1200";
          position = "0x0";
          scale    = 1.2;
        }
        {
          output   = "desc:Xiaomi Corporation Mi Monitor";
          mode     = "3440x1440@100Hz";
          position = "1600x-50";
          scale    = "auto";
        }
      ];
      on = [
        {
          _args = ["hyprland.start"
            (lua ''
            function ()
              hl.exec_cmd("dbus-update-activation-environment --all --systemd")
              hl.exec_cmd("hyprland-per-window-layout")
              hl.exec_cmd("udiskie & ydotoold & kanshi & awww-daemon")
              hl.exec_cmd("systemctl --user start hyprpolkitagent")
              hl.exec_cmd("quickshell > ~/qs.log")
              hl.exec_cmd("sleep 1; matugen image \"$(find ~/Pictures/wallpapers -type f | shuf -n 1)\" --source-color-index 0")
              hl.exec_cmd("Telegram")
              hl.exec_cmd("wl-paste --type text --watch cliphist store")
              hl.exec_cmd("wl-paste --type image --watch cliphist store")
              hl.exec_cmd("wl-clip-persist --clipboard regular")
              hl.exec_cmd("rm \"$HOME/.cache/cliphist/db\"")
              hl.exec_cmd("brightnessctl -s set 50%")
              hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
              hl.exec_cmd("pkill kanshi; kanshi")
            end
            '')
          ];
        }
        {
          _args = ["window.active"
            (lua ''
              function (window, reason)
                if reason == 1 then
                  hl.timer(function()
                    if window.address == hl.get_active_window().address then
                      hl.dispatch(hl.dsp.layout("fit_into_view"))
                    end
                  end, { timeout = 1000, type = "oneshot" })
                end
              end
            '')
          ];
        }
        # {
        #   _args = ["layer.opened"
        #     (lua ''
        #     function (lay)
        #       local data = string.format(
        #         "address=%s\nnamespace=%s\npid=%s\nlayer=%s\nmapped=%s\ninteractivity=%s\ngeometry=%dx%d+%d+%d\nmonitor=%s",
        #         lay.address, lay.namespace, lay.pid, lay.layer, lay.mapped,
        #         lay.interactivity, lay.w, lay.h, lay.x, lay.y,
        #         lay.monitor and lay.monitor.name or "nil"
        #       )
        #       hl.exec_cmd("notify-send -a Hyprland -t 5000 " .. string.format("%q", "Layer opened") .. " " .. string.format("%q", data))
        #     end
        #     '')
        #   ];
        # }
        # {
        #   _args = ["layer.closed"
        #     (lua ''
        #     function (lay)
        #       local data = string.format(
        #         "address=%s\nnamespace=%s\npid=%s\nlayer=%s\nmapped=%s\ninteractivity=%s\ngeometry=%dx%d+%d+%d\nmonitor=%s",
        #         lay.address, lay.namespace, lay.pid, lay.layer, lay.mapped,
        #         lay.interactivity, lay.w, lay.h, lay.x, lay.y,
        #         lay.monitor and lay.monitor.name or "nil"
        #       )
        #       hl.exec_cmd("notify-send -a Hyprland -t 5000 " .. string.format("%q", "Layer closed") .. " " .. string.format("%q", data))
        #     end
        #     '')
        #   ];
        # }
        # {
        #   _args = [
        #       "keybinds.submap" 
        #       (lua ''
        #       function(str)
        #           qs ipc submap str
        #       end
        #     '')
        #   ];
        # }
      ];

      env = [
        {_args = ["HYPRCURSOR_THEME" "Bibata-Modern-Ice"];}
        # {_args = ["HYPRCURSOR_SIZE" "28"];}
        {_args = ["XCURSOR_THEME" "Bibata-Modern-Ice"];}
        # {_args = ["XCURSOR_SIZE" "28"];}
        {_args = ["WLR_DRM_NO_ATOMIC" "1"];}
        {_args = ["EDITOR" "nvim"];}
        {_args = ["XDG_CURRENT_DESKTOP" "Hyprland"];}
        {_args = ["XDG_SESSION_TYPE" "wayland"];}
        {_args = ["XDG_SESSION_DESKTOP" "Hyprland"];}
        {_args = ["AWWW_TRANSITION" "random"];}
        {_args = ["AWWW_TRANSITION_FPS" "120"];}
      ];
      config = {
        general = {
          gaps_out = 15;
          border_size = 2;
          resize_on_border = false;
          layout = "scrolling";
          allow_tearing = false;
        };
        input = {
          kb_layout    = "us,ua-graph-rev";
          kb_options   = "grp:caps_toggle";
          repeat_delay = 250;
          sensitivity  = -0.2;

          touchpad     = {
            natural_scroll = true;
            scroll_factor = 0.2;
          };
        };
        cursor = {
          inactive_timeout = 20;
        };
        debug = {
          disable_logs = false;
        };
        ecosystem = {
          no_donation_nag = true;
        };
        # layout = {
        #   single_window_aspect_ratio = "17 9";
        # };
        decoration = {
          active_opacity     = 0.9;
          inactive_opacity   = 0.85;
          fullscreen_opacity = 0.9;
          shadow             = {
            range = 4;
          };
          blur               = {
            size   = 2;
            passes = 3;
          };
        };
        animations = {
          enabled = true;
        };
        scrolling = {
          explicit_column_widths = "0.32833, 0.4925, 0.6566";
          follow_min_visible = 0.99;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        misc = {
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          on_focus_under_fullscreen = 2;
          disable_splash_rendering = true;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
        };
        binds = {
          allow_pin_fullscreen = true;
        };
        render = {
          expand_undersized_textures = false;
        };
      };
      curve = {
        _args = [
          "fast-stiff"
          {
            type = "spring";
            mass = 1;
            stiffness = 700;
            dampening = 50;
          }
        ];
      };
      animation = [
        { leaf = "global"; enabled = true; speed = 1; spring = "fast-stiff"; }
        { leaf = "windows"; enabled = true; speed = 1; spring = "fast-stiff"; }
        { leaf = "windowsOut"; enabled = true; speed = 1; spring = "fast-stiff"; style = "popin 80%"; }
        { leaf = "fade"; enabled = true; speed = 1; spring = "fast-stiff"; }
        { leaf = "workspaces"; enabled = true; speed = 1; spring = "fast-stiff"; style = "slidefadevert 20%"; }
        { leaf = "specialWorkspace"; enabled = true; speed = 1; spring = "fast-stiff"; style = "fade"; }
        { leaf = "layers"; enabled = false; }
        { leaf = "layersIn"; enabled = false; }
      ];
    window_rule = [
      { name = "suppress-maximize-events"; match.class = ".*"; suppress_event = "maximize"; }
      { name = "librewolf-workspace"; match.class = "[lL]ibrewolf"; workspace = "1"; opacity = "1 override"; scrolling_width = 0.7; }
      { name = "kitty-workspace"; match.class = "kitty"; workspace = "2"; }
      { name = "chromium-workspace"; match.class = "[cC]hromium.*"; workspace = "3"; opacity = "1 override"; scrolling_width = 0.7; }
      { name = "telegram-workspace"; match.class = "org.telegram.desktop"; match.initial_title = "^Telegram.*$"; tag = "+chat"; }
      { name = "slack-workspace"; match.class = "[sS]lack"; tag = "+chat"; }
      { name = "jetbrains-workspace"; match.class = "jetbrains-.*"; match.float = false; workspace = "5"; scrolling_width = 1; }
      { name = "teams-workspace"; match.class = "teams-for-linux"; workspace = "6"; opacity = "1 override"; scrolling_width = 0.7; }
      { name = "orcaslicer-workspace"; match.class = "orca-slicer"; match.float = false; tag = "+cad"; }
      { name = "freecad-workspace"; match.class = "org.freecad.FreeCAD"; match.float = false; tag = "+cad"; }
      { name = "steam-workspace"; match.class = "steam"; workspace = "9"; opacity = "1 override"; }
      { name = "spotify-workspace"; match.class = "[sS]potify"; workspace = "10"; }
      { name = "portal-file-dialog"; match.class = "xdg\-desktop\-portal\-gtk"; match.initial_title = "All Files"; tag = "+file-picker"; }
      { name = "chromium-save-file"; match.initial_class = "[cC]hromium.*"; match.initial_title = "Save File"; tag = "+file-picker"; }
      { name = "chromium-open-file"; match.initial_class = "[cC]hromium.*"; match.initial_title = "Open File"; tag = "+file-picker"; }
      { name = "chromium-open-files"; match.initial_class = "[cC]hromium.*"; match.initial_title = "Open Files"; tag = "+file-picker"; }
      { name = "loupe-float"; match.class = "org\.gnome\.Loupe"; float = true; center = true; size = "(monitor_w*0.6) (monitor_h*0.8)"; }
      { name = "telegram-opacity"; match.class = "org.telegram.desktop"; match.initial_title = "^Telegram.*$"; opacity = "0.95 override 0.9 override 0.95 override"; no_screen_share = true; }
      { name = "telegram-media-fs-opacity"; match.initial_class = "org.telegram.desktop"; match.initial_title = "Media viewer"; opacity = "1 override"; float = true; fullscreen = true; }
      { name = "telegram-media-opacity"; match.initial_class = "org.telegram.desktop"; match.initial_title = "TelegramDesktop"; opacity = "1 override"; float = true; }
      { name = "sharing-ws-opacity"; match.class = ".*"; match.workspace = "8"; opacity = "1 override"; }
      { name = "thunar-opacity"; match.class = "thunar"; opacity = "0.9"; }
      { name = "pavucontrol-float"; match.class = "org.pulseaudio.pavucontrol"; float = true; size = "monitor_w*0.3 monitor_h*0.8"; center = true; opacity = "0.85"; }
      { name = "satty-float"; match.class = "com.gabm.satty"; float = true; center = true; }
      { name = "spotify-opacity"; match.class = "[sS]potify"; opacity = "0.9 override"; }
      { name = "thunar-progress-float"; match.class = "thunar"; match.title = "File Operation Progress"; float = true; center = true; }
      { name = "picture-in-picture"; match.title = "Picture[- ]in[- ]?[Pp]icture"; float = true; pin = true; size = "960 540"; move = "monitor_w-970 monitor_h-550"; keep_aspect_ratio = true; no_initial_focus = true; }
      { name = "jetbrains-popups"; match.class = "jetbrains-.*"; float = true; no_initial_focus = true; no_follow_mouse = true; }
      { name = "noita-immediate"; match.class = "steam_app_881100"; tag = "+game"; }
      { name = "teams-windows"; match.class = "teams-for-linux"; match.initial_title = ".* Screen is being shared"; float = true; size = "960 540"; move = "monitor_w-970 monitor_h-550"; keep_aspect_ratio = true; no_initial_focus = true; }
      { name = "sharepicker"; match.initial_title = "Select what to share"; float = true; center = true; }

      { name = "chatting-ws"; match.tag = "chat"; workspace = "4"; }
      { name = "cad-ws"; match.tag = "cad"; workspace = "7"; opacity = "1 override"; scrolling_width = 1; }
      { name = "picker-layout"; match.tag = "file-picker"; float = true; center = true; size = "(monitor_w*0.5) (monitor_h*0.8)"; }
      { name = "game-tearing"; match.tag = "game"; immediate = true; }
    ];
    workspace_rule = [
      { workspace = "s[true]"; gaps_in = 30; gaps_out = 50; }
    ];
      bind = [
        {
          _args = [
            "${mainMod} + SHIFT + Q"
            (lua "hl.dsp.exec_cmd(\"qs ipc call powermenu toggle\")")
          ];
        }
        {
          _args = [
            "${mainMod} + Return"
            (lua "hl.dsp.exec_cmd(\"kitty\")")
          ];
        }
        {
          _args = [
            "${mainMod} + B"
            (lua "hl.dsp.exec_cmd(\"qs ipc call whichkey toggle browser\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + C"
            (lua "hl.dsp.exec_cmd(\"qs ipc call whichkey toggle window\")")
          ];
        }
        {
          _args = [
            "${mainMod} + F"
            (lua "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + F"
            (lua "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            "${mainMod} + P"
            (lua "hl.dsp.window.pin()")
          ];
        }
        {
          _args = [
            "${mainMod} + V"
            (lua "hl.dsp.window.float()")
          ];
        }
        {
          _args = [
            "${mainMod} + Q"
            (lua "hl.dsp.exec_cmd(\"qs ipc call whichkey toggle bar\")")
          ];
        }
        {
          _args = [
            "${mainMod} + Space"
            (lua "hl.dsp.exec_cmd(\"qs ipc call launcher toggle; hyprctl switchxkblayout current 0\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Space"
            (lua "hl.dsp.exec_cmd(\"qs ipc call run toggle; hyprctl switchxkblayout current 0\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + comma"
            (lua "hl.dsp.workspace.move({ monitor = \"+1\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + V"
            (lua "hl.dsp.exec_cmd(\"qs ipc call cliphist toggle; hyprctl switchxkblayout current 0\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + P"
            (lua "hl.dsp.exec_cmd(\"qs ipc call whichkey toggle picker; hyprctl switchxkblayout current 0\")")
          ];
        }
        {
          _args = [
            "Print"
            (lua "hl.dsp.exec_cmd(\"qs ipc call whichkey toggle screen\")")
          ];
        }
        {
          _args = [
            "${mainMod} + A"
            (lua "hl.dsp.focus({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + H"
            (lua "hl.dsp.focus({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + Up"
            (lua "hl.dsp.focus({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + Down"
            (lua "hl.dsp.focus({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + bracketright"
            (lua "hl.dsp.window.move({ direction = \"right\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + bracketleft"
            (lua "hl.dsp.window.move({ direction = \"left\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + A"
            (lua "hl.dsp.window.move({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + H"
            (lua "hl.dsp.window.move({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Up"
            (lua "hl.dsp.window.move({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Down"
            (lua "hl.dsp.window.move({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + N"
            (lua "hl.dsp.exec_cmd(\"qs ipc call notifications dismissOldestPopup\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + N"
            (lua "hl.dsp.exec_cmd(\"qs ipc call notifications dismissAllPopups\")")
          ];
        }
        {
          _args = [
            "${mainMod} + S"
            (lua "hl.dsp.workspace.toggle_special(\"\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + S"
            (lua "hl.dsp.window.move({ workspace = \"special\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + mouse:272"
            (lua "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "${mainMod} + mouse:273"
            (lua "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lua "hl.dsp.exec_cmd(\"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lua "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "SHIFT + XF86AudioRaiseVolume"
            (lua "hl.dsp.exec_cmd(\"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 5%+\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "SHIFT + XF86AudioLowerVolume"
            (lua "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lua "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "SHIFT + XF86AudioMute"
            (lua "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lua "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lua "hl.dsp.exec_cmd(\"hyprctl hyprsunset gamma -10; qs ipc call osd brightness\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lua "hl.dsp.exec_cmd(\"hyprctl hyprsunset gamma +10; qs ipc call osd brightness\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioPlay"
            (lua "hl.dsp.exec_cmd(\"playerctl play-pause\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lua "hl.dsp.exec_cmd(\"playerctl next\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lua "hl.dsp.exec_cmd(\"playerctl previous\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "switch:on:Lid Switch"
            (lua "hl.dsp.exec_cmd([[hyprctl keyword monitor \"eDP-1,disable\"]])")
            { locked = true; }
          ];
        }
        {
          _args = [
            "switch:off:Lid Switch"
            (lua "hl.dsp.exec_cmd([[hyprctl keyword monitor \"eDP-1,1920x1200,0x0,1.2\"]])")
            { locked = true; }
          ];
        }
        {
          _args = [
            "${mainMod} + Tab"
            (lua ''
              function()
                hl.dispatch(hl.dsp.window.cycle_next())
                hl.dispatch(hl.dsp.window.bring_to_top())
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + R"
            (lua ''
              function()
                if hl.get_active_window().fullscreen == 1 then
                  hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "unset" }))
                elseif hl.get_active_window().fullscreen == 2 then
                  hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
                else
                  hl.dispatch(hl.dsp.layout("colresize +conf"))
                end
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + E"
            (lua ''
              function()
                if hl.get_active_window().floating then
                  hl.dispatch(hl.dsp.window.move({ direction = "right" }))
                else
                  hl.dispatch(hl.dsp.layout("swapcol r"))
                end
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Y"
            (lua ''
              function()
                if hl.get_active_window().floating then
                  hl.dispatch(hl.dsp.window.move({ direction = "left" }))
                else
                  hl.dispatch(hl.dsp.layout("swapcol l"))
                end
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + E"
            (lua "hl.dsp.layout(\"focus r\")")
          ];
        }
        {
          _args = [
            "${mainMod} + Y"
            (lua "hl.dsp.layout(\"focus l\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Right"
            (lua ''
              function()
                if hl.get_active_window().floating then
                  hl.dispatch(hl.dsp.window.move({ direction = "right" }))
                else
                  hl.dispatch(hl.dsp.layout("swapcol r"))
                end
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + Left"
            (lua ''
              function()
                if hl.get_active_window().floating then
                  hl.dispatch(hl.dsp.window.move({ direction = "left" }))
                else
                  hl.dispatch(hl.dsp.layout("swapcol l"))
                end
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + Right"
            (lua "hl.dsp.layout(\"focus r\")")
          ];
        }
        {
          _args = [
            "${mainMod} + Left"
            (lua "hl.dsp.layout(\"focus l\")")
          ];
        }
        {
          _args = [
            "${mainMod} + C"
            (lua ''
              function()
                local win = hl.get_active_window()
                hl.config({ scrolling = { focus_fit_method = 0 } })
                hl.dispatch(hl.dsp.focus({ window = win }))
                hl.config({ scrolling = { focus_fit_method = 1 } })
              end
            '')
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + R"
            (lua "hl.dsp.submap(\"resize\")")
          ];
        }
        {
          _args = [
            "${mainMod} + M"
            (lua "hl.dsp.submap(\"move\")")
          ];
        }
      ]
      ++ builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
            [
            {
              _args = [
                "${mainMod} + code:1${toString i}"
                (lua "hl.dsp.focus({ workspace = ${toString ws} })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + code:1${toString i}"
                (lua "hl.dsp.window.move({ workspace = ${toString ws} })")
              ];
            }
          ]
        ) 10
      );
    };
    submaps = {
      resize = {
        settings = {
          bind = [
            {_args = ["E" (lua "hl.dsp.window.resize({ x = 20, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Y" (lua "hl.dsp.window.resize({ x = -20, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["H" (lua "hl.dsp.window.resize({ x = 0, y = -20, relative = true })") { repeating = true; }];}
            {_args = ["A" (lua "hl.dsp.window.resize({ x = 0, y = 20, relative = true })") { repeating = true; }];}
            {_args = ["Right" (lua "hl.dsp.window.resize({ x = 20, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Left" (lua "hl.dsp.window.resize({ x = -20, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Down" (lua "hl.dsp.window.resize({ x = 0, y = -20, relative = true })") { repeating = true; }];}
            {_args = ["Up" (lua "hl.dsp.window.resize({ x = 0, y = 20, relative = true })") { repeating = true; }];}
            {_args = ["escape" (lua "hl.dsp.submap(\"reset\")")];}
          ];
        };
      };
      move = {
        settings = {
          bind = [
            {_args = ["E" (lua "hl.dsp.window.move({ x = 30, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Y" (lua "hl.dsp.window.move({ x = -30, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["H" (lua "hl.dsp.window.move({ x = 0, y = 30, relative = true })") { repeating = true; }];}
            {_args = ["A" (lua "hl.dsp.window.move({ x = 0, y = -30, relative = true })") { repeating = true; }];}
            {_args = ["Right" (lua "hl.dsp.window.move({ x = 30, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Left" (lua "hl.dsp.window.move({ x = -30, y = 0, relative = true })") { repeating = true; }];}
            {_args = ["Down" (lua "hl.dsp.window.move({ x = 0, y = 30, relative = true })") { repeating = true; }];}
            {_args = ["Up" (lua "hl.dsp.window.move({ x = 0, y = -30, relative = true })") { repeating = true; }];}
            {_args = ["escape" (lua "hl.dsp.submap(\"reset\")")];}
          ];
        };
      };
    };

    extraConfig = ''
      local colors = require "colors"
      hl.config({
        general = {
          col = {
            active_border = { colors = { "rgba(" .. colors.primary .. "ee)", "rgba(" .. colors.secondary .. "ee)" }, angle = 45 },
            inactive_border = "rgba(" .. colors.background .. "aa)",
          },
        },
      })
    '';
  };

  home.packages = with pkgs; [
    # hypridle
    # hyprsunset
    hyprland-per-window-layout
    hyprshutdown
  ];

  services = {
    hyprpolkitagent.enable = true;
    hypridle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "hyprctl hyprsunset gamma 10";
            on-resume = "hyprctl hyprsunset gamma 80";
          }
          {
            timeout = 900;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })' && hyprctl hyprsunset gamma 80";
          }
        ];
      };
    };
    hyprsunset = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = {
        max-gamma = 100;
        profile = [
          {
            gamma = 0.8;
            time = "7:30";
            identity = true;
          }
          {
            time = "20:00";
            temperature = 5000;
            gamma = 0.7;
          }
        ];
      };
    };
  };
}
