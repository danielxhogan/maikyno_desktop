import QtQuick
import QtQuick.Controls
import Server

Item {
    id: media_dirs_root
    property bool loading: false

    Connections {
        target: Server

        function onScan_library_success()
        {
            media_dirs_root.loading = false
            media_dir_err_msg.text = "Library successfully scanned"
            Server.req_library_contents(app.library_id,
                Server.LIBRARY_TYPE_MOVIE, Server.CALLEE_MEDIA_DIRS)
        }

        function onScan_library_error(message)
        {
            media_dirs_root.loading = false;
            media_dir_err_msg.text = message
        }

        function onMedia_dirs_req_videos_success()
        {
            media_dirs_root.loading = false
            media_dir_err_msg.text = ""
            pages_stack.push(videos_component)
        }

        function onMedia_dirs_req_videos_error(message)
        {
            media_dirs_root.loading = false;
            media_dir_err_msg.text = message
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
                text: "Back";
                anchors.left: parent.left
                onClicked: pages_stack.pop();
            }

            Button {
                text: "Scan Library"
                visible: app.movie_library
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10
                enabled: !media_dirs_root.loading

                onClicked: {
                    media_dirs_root.loading = true
                    media_dir_err_msg.text = "Scanning library"
                    Server.scan_library(app.library_id)
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
            spacing: 40

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: app.movie_library ? app.library_name : app.show_name
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
                    enabled: !media_dirs_root.loading

                    onClicked: {
                        media_dirs_root.loading = true
                        app.media_dir_id = modelData.id
                        app.media_dir_name = modelData.name
                        Server.req_videos(modelData.id, Server.CALLEE_MEDIA_DIRS)
                    }
                }
            }
        }
    }
}
