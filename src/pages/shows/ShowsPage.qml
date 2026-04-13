import QtQuick
import QtQuick.Controls

Item {
    id: shows_root
    property bool loading: false

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Connections {
            target: server

            function onReq_seasons_success()
            {
                shows_root.loading = false
                shows_err_msg.text = ""
                pages_stack.push(media_dir_component)
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
                text: "Select a Show"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: shows_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: server.shows

                delegate: Button {
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !shows_root.loading
                    onClicked: {
                        shows_root.loading = true
                        server.req_seasons(modelData.id)
                    }
                }

            }
        }
    }
}
