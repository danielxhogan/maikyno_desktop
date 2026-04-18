import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import Server

Item {
    id: videos_root
    property bool loading: false

    Connections {
        target: Server

        function onReq_video_streams_success()
        {
            videos_root.loading = false
            vidoes_err_msg.text = ""
            pages_stack.push(configurator_component)
        }

        function onReq_video_streams_error(message)
        {
            videos_root.loading = false
            vidoes_err_msg.text = message
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Button {
                text: "Back"
                enabled: !videos_root.loading
                anchors.left: parent.left
                onClicked: pages_stack.pop();
            }

            Button {
                text: "Process Videos"
                enabled: !videos_root.loading
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10

                onClicked: {
                    videos_root.loading = true
                    Server.req_video_streams(app.media_dir_id);
                }
            }
        }

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: parent.width
            spacing: 20

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: app.movie_library
                    ? app.media_dir_name
                    : app.show_name + " " + app.media_dir_name
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: vidoes_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 16
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
                        enabled: !videos_root.loading
                        visible: !modelData.extra
                        width: modelData.extra ? 0 : 250
                        height: modelData.extra ? 0 : 35
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked: {
                            videos_root.loading = true
                            app.src = "http://" + Server.ip + ":8080/media/"
                                + modelData.static_path

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

            Text {
                id: extras
                text: "Extras"
                font.bold: true
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
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
                        enabled: !videos_root.loading
                        visible: modelData.extra
                        width: modelData.extra ? 250 : 0
                        height: modelData.extra ? 35 : 0
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked: {
                            app.src = "http://" + Server.ip + ":8080/media/"
                                + modelData.static_path

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
