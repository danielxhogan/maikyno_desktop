import QtQuick
import QtQuick.Controls
import Player

Item {
    Rectangle {
        anchors.fill: parent

        Player {
            id: player
            src: app.src
            anchors.fill: parent
        }

        Shortcut {
            sequence: "Space"
            onActivated: player.pause_play()
        }

        Shortcut {
            sequence: "w"
            onActivated: player.seek(-60)
        }

        Shortcut {
            sequence: "e"
            onActivated: player.seek(-5)
        }

        Shortcut {
            sequence: "r"
            onActivated: player.seek(5)
        }

        Shortcut {
            sequence: "t"
            onActivated: player.seek(60)
        }

        Column {
            id: osc
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20

            Button {
                text: "Back"; onClicked: pages_stack.pop();
            }
        }
    }
}
