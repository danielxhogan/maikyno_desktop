import QtQuick
import QtQuick.Controls
import Server

Item {
    id: libraries_root
    property bool loading: false

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Connections {
            target: Server

            function onReq_shows_success()
            {
                libraries_root.loading = false
                libraries_err_msg.text = ""
                pages_stack.push(shows_component)
            }

            function onReq_shows_error(message)
            {
                libraries_root.loading = false;
                libraries_err_msg.text = message
            }

            function onReq_movies_success()
            {
                libraries_root.loading = false
                libraries_err_msg.text = ""
                app.movie_library = true
                pages_stack.push(media_dirs_component)
            }

            function onReq_movies_error(message)
            {
                libraries_root.loading = false;
                libraries_err_msg.text = message
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
                text: "Select a library"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: libraries_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: Server.libraries

                delegate: Button {
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !libraries_root.loading

                    onClicked: {
                        libraries_root.loading = true
                        app.library_id = modelData.id
                        Server.req_library_contents(modelData.id,
                            modelData.media_type)
                    }
                }

            }
        }
    }
}
