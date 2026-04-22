import QtQuick
import QtQuick.Controls
import Server

Item {
    id: shows_root
    property bool loading: false
    property string collection_name

    Connections {
        target: Server

        function onScan_library_success()
        {
            shows_root.loading = false;
            shows_err_msg.text = "Library Successfully Scanned"
            Server.req_library_contents(app.library_id,
                Server.LIBRARY_TYPE_SHOW, Server.CALLEE_SHOWS)
        }

        function onScan_library_error(message)
        {
            shows_root.loading = false;
            shows_err_msg.text = message
        }

        function onReq_collection_shows_success()
        {
            shows_root.loading = false
            shows_err_msg.text = ""
            app.viewing_collection = true;
        }

        function onReq_collection_shows_error(message)
        {
            shows_root.loading = false
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
                onClicked: {
                    if (app.viewing_collection) {
                        app.viewing_collection = false;
                    } else {
                        pages_stack.pop();
                    }
                }
            }

            Button {
                text: "Scan Library"
                visible: !app.viewing_collection
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10
                enabled: !shows_root.loading

                onClicked: {
                    shows_root.loading = true
                    Server.scan_library(app.library_id, Server.CALLEE_SHOWS)
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
                text: app.viewing_collection ? collection_name : app.library_name
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: shows_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            Text {
                id: collections_title
                visible: Server.collections.length > 0
                    && !app.viewing_collection

                height: Server.collections.length > 0
                    && !app.viewing_collection
                    ? contentHeight
                    : 0

                text: Server.collections.length > 0
                    && !app.viewing_collection
                    ? "Collections"
                    : ""

                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 20
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: Server.collections

                delegate: Button {
                    width: 250
                    height: app.viewing_collection ? 0 : 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !shows_root.loading
                    onClicked: {
                        collection_name = modelData.name
                        Server.req_collection_shows(modelData.id)
                    }
                }
            }

            Text {
                id: shows_title
                text: "Shows"
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 20
            }

            ListView {
                width: parent.width
                height: app.viewing_collection ? 0 : contentHeight
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

            ListView {
                width: parent.width
                height: app.viewing_collection ? contentHeight : 0
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: Server.collection_shows

                delegate: Button {
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    enabled: !shows_root.loading
                    onClicked: {
                        shows_root.loading = true
                        app.show_name = modelData.name
                        Server.req_seasons(modelData.show_id)
                    }
                }

            }
        }
    }
}
