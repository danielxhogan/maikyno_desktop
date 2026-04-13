import QtQuick
import QtQuick.Controls
import Player

Item {
    Rectangle {
        anchors.fill: parent

        Player {
            id: player
            src: app.src
            v_stream_idx: app.v_stream_idx
            a_stream_idx: app.a_stream_idx
            anchors.fill: parent
        }

        Shortcut {
            sequence: "Space"
            onActivated: player.pause_play()
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
            sequence: "w"
            onActivated: player.seek(-60)
        }

        Shortcut {
            sequence: "t"
            onActivated: player.seek(60)
        }

        Shortcut {
            sequence: "y"
            onActivated: player.seek_start()
        }

        Shortcut {
            sequence: "a"
            onActivated: player.prev_chapter()
        }

        Shortcut {
            sequence: "g"
            onActivated: player.next_chapter()
        }

        Shortcut {
            sequence: "f"
            onActivated: player.prev_v_stream()
        }

        Shortcut {
            sequence: "j"
            onActivated: player.next_v_stream()
        }

        Shortcut {
            sequence: "d"
            onActivated: player.prev_a_stream()
        }

        Shortcut {
            sequence: "k"
            onActivated: player.next_a_stream()
        }

        Shortcut {
            sequence: "s"
            onActivated: player.prev_s_stream()
        }

        Shortcut {
            sequence: "l"
            onActivated: player.next_s_stream()
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
