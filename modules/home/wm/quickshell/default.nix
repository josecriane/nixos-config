{
  config,
  lib,
  pkgs,
  inputs,
  machineOptions,
  ...
}:
{
  config = lib.mkIf (machineOptions.wm == "niri") {
    xdg.configFile."quickshell/shell/shell.qml".text = 
      let
        colors = config.lib.stylix.colors.withHashtag;
        fonts = config.stylix.fonts;
      in
      ''
      import QtQuick
      import Quickshell

      ShellRoot {
        id: root
        
        property bool powerMenuVisible: false

        PanelWindow {
          id: panel
          anchors {
            left: true
            right: true
            top: true
          }
          implicitHeight: 40

          Rectangle {
            id: barBackground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 40
            color: "${colors.base00}"
            opacity: 0.95
            
            // Bottom border accent
            Rectangle {
              anchors.bottom: parent.bottom
              width: parent.width
              height: 2
              color: "${colors.base0D}"
              opacity: 0.6
            }

            Row {
              anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 10
              }
              spacing: 15

              Text {
                text: "󰣇"
                color: "${colors.base0B}" 
                font.pixelSize: 16
                font.family: "${fonts.emoji.name}"
              }

              Text {
                text: "Quickshell"
                color: "${colors.base05}"
                font.pixelSize: 14
                font.bold: true
              }
            }

            Rectangle {
              anchors.centerIn: parent
              width: timeText.width + 20
              height: 30
              color: "${colors.base02}"
              radius: 15
              
              Text {
                id: timeText
                anchors.centerIn: parent
                text: new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
                color: "${colors.base05}"
                font.pixelSize: 13
                font.family: "${fonts.monospace.name}"

                Timer {
                  interval: 1000
                  repeat: true
                  running: true
                  onTriggered: parent.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
                }
              }
            }

            Row {
              anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 10
              }
              spacing: 10

              Text {
                text: "󰍛"
                color: "${colors.base0A}"
                font.pixelSize: 16
                font.family: "${fonts.emoji.name}"
                
                MouseArea {
                  anchors.fill: parent
                  onClicked: console.log("Network clicked")
                }
              }

              Text {
                text: "󰕾"
                color: "${colors.base0D}"
                font.pixelSize: 16
                font.family: "${fonts.emoji.name}"
                
                MouseArea {
                  anchors.fill: parent
                  onClicked: console.log("Audio clicked")
                }
              }

              Text {
                id: powerButton
                text: "󰐥"
                color: "${colors.base08}"
                font.pixelSize: 16
                font.family: "${fonts.emoji.name}"
                
                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    console.log("Power button clicked, current visibility:", root.powerMenuVisible)
                    root.powerMenuVisible = !root.powerMenuVisible
                    console.log("New visibility:", root.powerMenuVisible)
                  }
                }
              }
            }
          }
        }
        
        // Power menu as a separate panel that doesn't push windows
        PanelWindow {
          id: powerMenu
          visible: root.powerMenuVisible
          color: "transparent"
          
          // Don't reserve space - float over content
          exclusiveZone: 0
          
          // Position at top right corner
          anchors {
            top: true
            right: true
            left: false
            bottom: false
          }
          
          margins.top: 0
          margins.right: 10
          
          implicitWidth: 200
          implicitHeight: powerColumn.height + 20
          
          Rectangle {
            anchors.fill: parent
            color: "${colors.base00}"
            radius: 12
            opacity: 0.95
            
            Column {
              id: powerColumn
              anchors.centerIn: parent
              spacing: 5
              width: parent.width - 20
              
              PowerMenuItem {
                icon: "󰍃"
                label: "Logout"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["loginctl", "terminate-session", "self"])
                }
              }
              
              PowerMenuItem {
                icon: "󰐥"
                label: "Shutdown"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["systemctl", "poweroff"])
                }
              }
              
              PowerMenuItem {
                icon: "󰜉"
                label: "Reboot"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["systemctl", "reboot"])
                }
              }
              
              PowerMenuItem {
                icon: "󰒲"
                label: "Suspend"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["systemctl", "suspend"])
                }
              }
              
              PowerMenuItem {
                icon: "󰤄"
                label: "Hibernate"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["systemctl", "hibernate"])
                }
              }
              
              PowerMenuItem {
                icon: "󰌾"
                label: "Lock"
                onClicked: {
                  root.powerMenuVisible = false
                  Quickshell.execDetached(["swaylock"])
                }
              }
            }
            
            // Component for power menu items
            component PowerMenuItem: Rectangle {
              property string icon
              property string label
              signal clicked()
              
              width: parent.width
              height: 35
              color: menuMouseArea.containsMouse ? "${colors.base02}" : "transparent"
              radius: 8
              
              Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                spacing: 10
                
                Text {
                  text: parent.parent.icon
                  color: "${colors.base08}"
                  font.pixelSize: 18
                  font.family: "${fonts.emoji.name}"
                }
                
                Text {
                  text: parent.parent.label
                  color: "${colors.base05}"
                  font.pixelSize: 13
                  font.family: "${fonts.monospace.name}"
                }
              }
              
              MouseArea {
                id: menuMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: parent.clicked()
              }
            }
          }
        }
      }
    '';

    home.packages = [ inputs.quickshell.packages.${pkgs.system}.default ];

    xdg.configFile."quickshell/start-quickshell" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # Kill any existing quickshell processes
        pkill -f quickshell

        # Wait a moment for processes to terminate
        sleep 1

        # Start quickshell with shell config
        quickshell -c shell &

        # Save the PID for later reference
        echo $! > /tmp/quickshell.pid

        echo "Quickshell started with PID $!"
      '';
    };

    # Enable QML language server support
    home.sessionVariables = {
      QML2_IMPORT_PATH = "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml";
    };
  };
}