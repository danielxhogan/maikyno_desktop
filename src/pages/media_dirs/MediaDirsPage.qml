import QtQuick
import QtQuick.Controls
import Server

Item {
    id: media_dir_root
    property bool loading: false

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Connections {
            target: Server

            function onMedia_dirs_req_videos_success()
            {
                media_dir_root.loading = false
                media_dir_err_msg.text = ""
                pages_stack.push(videos_component)
            }

            function onMedia_dirs_req_videos_error(message)
            {
                media_dir_root.loading = false;
                media_dir_err_msg.text = message
            }
        }

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: parent.width
            spacing: 40

            Button {
                text: "Back";
                enabled: !media_dir_root.loading
                onClicked: pages_stack.pop();
            }

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Select a movie"
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
                spacing: 10
                clip: true
                model: Server.media_dirs

                delegate: Button {
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !media_dir_root.loading

                    onClicked: {
                        media_dir_root.loading = true
                        app.media_dir_id = modelData.id
                        Server.req_videos(modelData.id, "media_dirs")
                    }
                }
            }
        }
    }
}
