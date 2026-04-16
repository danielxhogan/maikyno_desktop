import QtQuick
import QtQuick.Controls
import Server

Item {
    id: shows_root
    property bool loading: false

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Connections {
            target: Server

            function onScan_library_success()
            {
                shows_root.loading = false;
                shows_err_msg.text = ""
                Server.req_library_contents(app.library_id, "show")
            }

            function onScan_library_error(message)
            {
                shows_root.loading = false;
                shows_err_msg.text = message
            }

            function onReq_seasons_success()
            {
                shows_root.loading = false
                shows_err_msg.text = ""
                app.movie_library = false
                pages_stack.push(media_dirs_component)
            }

            function onReq_seasons_error(message)
            {
                shows_root.loading = false;
                shows_err_msg.text = message
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
                text: "Back"; onClicked: pages_stack.pop();
            }

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: app.library_name
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: shows_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            Button {
                width: 250
                height: 35
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Scan Library"
                enabled: !shows_root.loading
                onClicked: {
                    shows_root.loading = true
                    Server.scan_library(app.library_id)
                }
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: Server.shows

                delegate: Button {
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !shows_root.loading
                    onClicked: {
                        shows_root.loading = true
                        app.show_name = modelData.name
                        Server.req_seasons(modelData.id)
                    }
                }

            }
        }
    }
}
