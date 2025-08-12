{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile."swaync/style.css".text = ''
    @define-color bg rgba(0, 0, 0, 0.67);
    @define-color bg-hover rgba(0, 0, 0, 0.8);
    @define-color text rgba(216, 216, 216, 1);
    @define-color text-dim rgba(216, 216, 216, 0.4);
    @define-color border #efefef;
    @define-color red rgba(238, 46, 36, 1);

    .notification-row {
      outline: none;
    }

    .notification-row:focus,
    .notification-row:hover {
      background: @bg-hover;
    }

    .notification {
      border-radius: 12px;
      margin: 8px;
      padding: 0;
      background: @bg;
      border: 2px solid @border;
    }

    .critical {
      border: 2px solid @red;
    }

    .notification-content {
      background: transparent;
      padding: 10px;
      border-radius: 12px;
    }

    .close-button {
      background: transparent;
      color: @text;
      text-shadow: none;
      padding: 0;
      border-radius: 100%;
      margin-top: 10px;
      margin-right: 10px;
      box-shadow: none;
      border: none;
      min-width: 24px;
      min-height: 24px;
    }

    .close-button:hover {
      box-shadow: none;
      background: @bg-hover;
      transition: all 0.15s ease-in-out;
      border: none;
    }

    .notification-default-action,
    .notification-action {
      padding: 4px;
      margin: 0;
      box-shadow: none;
      background: @bg;
      border: none;
      color: @text;
      transition: all 200ms ease-in-out;
    }

    .notification-default-action:hover,
    .notification-action:hover {
      -gtk-icon-effect: none;
      background: @bg-hover;
    }

    .notification-default-action {
      border-radius: 12px;
      margin: 4px;
    }

    .notification-default-action:not(:only-child) {
      border-bottom-left-radius: 0px;
      border-bottom-right-radius: 0px;
      margin-bottom: 0;
    }

    .notification-action {
      border-radius: 0px;
      margin: 0 4px;
      border-top: 1px solid @border;
    }

    .notification-action:first-child {
      border-bottom-left-radius: 12px;
    }

    .notification-action:last-child {
      border-bottom-right-radius: 12px;
      margin-bottom: 4px;
    }

    .summary {
      font-size: 16px;
      font-weight: bold;
      background: transparent;
      color: @text;
      text-shadow: none;
    }

    .time {
      font-size: 12px;
      font-weight: bold;
      background: transparent;
      color: @text;
      text-shadow: none;
      margin-right: 18px;
    }

    .body {
      font-size: 14px;
      font-weight: normal;
      background: transparent;
      color: @text;
      text-shadow: none;
    }

    .control-center {
      background: @bg;
      border: 2px solid @border;
      border-radius: 12px;
      margin: 8px;
    }

    .control-center-list {
      background: transparent;
    }

    .control-center-list-placeholder {
      opacity: 0.5;
    }

    .floating-notifications {
      background: transparent;
    }

    .blank-window {
      background: alpha(black, 0.25);
    }

    .widget-title {
      margin: 8px;
      font-size: 16px;
      font-weight: bold;
      color: @text;
    }

    .widget-title > button {
      font-size: initial;
      color: @text;
      text-shadow: none;
      background: @bg;
      border: 2px solid @border;
      box-shadow: none;
      border-radius: 12px;
    }

    .widget-title > button:hover {
      background: @bg-hover;
    }

    .widget-dnd {
      margin: 8px;
      font-size: 16px;
      color: @text;
    }

    .widget-dnd > switch {
      font-size: initial;
      border-radius: 12px;
      background: @bg;
      border: 2px solid @border;
      box-shadow: none;
    }

    .widget-dnd > switch:checked {
      background: @bg-hover;
    }

    .widget-dnd > switch slider {
      background: @border;
      border-radius: 12px;
    }
  '';

  xdg.configFile."swaync/config.json".text = ''
    {
      "$schema": "/etc/xdg/swaync/configSchema.json",
      "positionX": "right",
      "positionY": "top",
      "layer": "overlay",
      "control-center-layer": "top",
      "layer-shell": true,
      "cssPriority": "application",
      "control-center-margin-top": 8,
      "control-center-margin-bottom": 8,
      "control-center-margin-right": 8,
      "control-center-margin-left": 8,
      "notification-2fa-action": true,
      "notification-inline-replies": false,
      "notification-icon-size": 64,
      "notification-body-image-height": 100,
      "notification-body-image-width": 200,
      "timeout": 10,
      "timeout-low": 5,
      "timeout-critical": 0,
      "fit-to-screen": true,
      "control-center-width": 500,
      "control-center-height": 600,
      "notification-window-width": 500,
      "keyboard-shortcuts": true,
      "image-visibility": "when-available",
      "transition-time": 200,
      "hide-on-clear": false,
      "hide-on-action": true,
      "script-fail-notify": true,
      "notification-visibility": {},
      "widgets": [
        "inhibitors",
        "title",
        "dnd",
        "notifications"
      ],
      "widget-config": {
        "inhibitors": {
          "text": "Inhibitors",
          "button-text": "Clear All",
          "clear-all-button": true
        },
        "title": {
          "text": "Notifications",
          "clear-all-button": true,
          "button-text": "Clear All"
        },
        "dnd": {
          "text": "Do Not Disturb"
        }
      }
    }
  '';
}
