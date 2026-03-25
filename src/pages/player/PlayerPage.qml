import QtQuick
import QtQuick.Controls
import Player

Item {
    Rectangle {
        anchors.fill: parent

        Player {
            id: player
            backend: Player.PLAYER_BACKEND_TYPE_MPV
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: player.play_file("http://192.168.1.209:8080/media/tha_movies/mk_movies/collections/The Terminator Series/01 - The Terminator/The Terminator.mkv")
            }
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

        Row {
            id: osc
            anchors.bottom: player.bottom
            anchors.left: player.left
            anchors.right: player.right
            padding: 20

            Button {
                text: "Back"; onClicked: pages_stack.pop();
            }
        }
    }
}
