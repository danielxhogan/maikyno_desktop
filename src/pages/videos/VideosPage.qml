import QtQuick
import QtQuick.Controls
import QtQml.Models
import Server

Item {
    id: videos_root

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: parent.width
            spacing: 40

            Button {
                text: "Back"; onClicked: pages_stack.pop();
            }

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Play a video"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: media_dir_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                model: Server.videos

                delegate: Item {
                    visible: !modelData.extra
                    width: modelData.extra ? 0 : 250
                    height: modelData.extra ? 0 : 45
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: modelData.name
                        visible: !modelData.extra
                        width: modelData.extra ? 0 : 250
                        height: modelData.extra ? 0 : 35
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked: {
                            app.src = "http://192.168.1.209:8080/media/" + modelData.static_path
                            app.video_id = modelData.id
                            app.ts = modelData.ts
                            app.v_stream_idx = modelData.v_stream
                            app.a_stream_idx = modelData.a_stream
                            app.s_stream_idx = modelData.s_stream
                            app.s_pos = modelData.s_pos
                            pages_stack.push(player_component)
                        }
                    }
                }
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                model: Server.videos

                delegate: Item {
                    visible: modelData.extra
                    width: modelData.extra ? 250 : 0
                    height: modelData.extra ? 45 : 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: modelData.name
                        visible: modelData.extra
                        width: modelData.extra ? 250 : 0
                        height: modelData.extra ? 35 : 0
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked: {
                            app.src = "http://192.168.1.209:8080/media/" + modelData.static_path
                            app.video_id = modelData.id
                            app.ts = modelData.ts
                            app.v_stream_idx = modelData.v_stream
                            app.a_stream_idx = modelData.a_stream
                            app.s_stream_idx = modelData.s_stream
                            app.s_pos = modelData.s_pos
                            pages_stack.push(player_component)
                        }
                    }
                }
            }
        }
    }
}
