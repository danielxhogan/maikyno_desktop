import QtQuick
import QtQuick.Controls
import Player
import Server

Item {
    id: player_root
    property bool loading: false

    Rectangle {
        anchors.fill: parent

        Player {
            id: player
            anchors.fill: parent

            server: Server

            src: app.src
            video_id: app.video_id
            ts: app.ts
            v_stream_idx: app.v_stream_idx
            a_stream_idx: app.a_stream_idx
            s_stream_idx: app.s_stream_idx
            s_pos: app.s_pos
        }

        Connections {
            target: Server

            function onSave_state_success()
            {
                Server.req_videos(app.media_dir_id, Server.CALLEE_PLAYER);
            }

            function onSave_state_error(message)
            {
                player_root.loading = false
                pages_stack.pop()
            }

            function onPlayer_req_videos_success()
            {
                player_root.loading = false
                pages_stack.pop()
            }

            function onPlayer_req_videos_error(message)
            {
                player_root.loading = false
                pages_stack.pop()
            }
        }

        Column {
            id: osc
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20

            Button {
                text: "Back";
                enabled: !player_root.loading

                onClicked: {
                    player_root.loading = true
                    player.save_state();
                }
            }
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

        Shortcut {
            sequence: "u"
            onActivated: player.sub_pos_up()
        }

        Shortcut {
            sequence: "m"
            onActivated: player.sub_pos_down()
        }
    }
}
