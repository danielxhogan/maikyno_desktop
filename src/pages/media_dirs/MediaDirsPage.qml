import QtQuick
import QtQuick.Controls
import Server

Item {
    id: media_dirs_root
    property bool loading: false
    property string collection_name

    Connections {
        target: Server

        function onScan_library_success()
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = "Library successfully scanned"
            Server.req_library_contents(app.library_id,
                Server.LIBRARY_TYPE_MOVIE, Server.CALLEE_MEDIA_DIRS)
        }

        function onScan_library_error(message)
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = message
        }

        function onReq_collection_movies_success()
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = ""
            app.viewing_collection = true
        }

        function onReq_collection_movies_error(message)
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = message
        }

        function onMedia_dirs_req_videos_success()
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = ""
            pages_stack.push(videos_component)
        }

        function onMedia_dirs_req_videos_error(message)
        {
            media_dirs_root.loading = false
            media_dirs_err_msg.text = message
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
                anchors.left: parent.left
                onClicked: {
                    if (app.movie_library && app.viewing_collection) {
                        app.viewing_collection = false
                    } else {
                        pages_stack.pop()
                    }
                }
            }

            Button {
                text: "Scan Library"
                visible: app.movie_library && !app.viewing_collection
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10
                enabled: !media_dirs_root.loading

                onClicked: {
                    media_dirs_root.loading = true
                    media_dirs_err_msg.text = "Scanning library"
                    Server.scan_library(app.library_id, Server.CALLEE_MEDIA_DIRS)
                }
            }
        }

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.topMargin: 20
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
                id: media_dirs_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            Text {
                id: collections_title
                visible: app.movie_library
                    && !app.viewing_collection
                    && Server.collections.length > 0

                height: app.movie_library
                    && !app.viewing_collection
                    && Server.collections.length > 0
                    ? contentHeight
                    : 0

                text: app.movie_library
                    && !app.viewing_collection
                    && Server.collections.length > 0
                    ? "Collections"
                    : ""

                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 20
            }

            ListView {
                model: Server.collections
                width: parent.width
                height: app.movie_library && !app.viewing_collection
                    ? contentHeight
                    : 0

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true

                delegate: Button {
                    text: modelData.name
                    enabled: !media_dirs_root.loading
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent?.horizontalCenter

                    onClicked: {
                        collection_name = modelData.name
                        Server.req_collection_movies(modelData.id)
                    }
                }
            }

            Text {
                id: media_dirs_title
                text: app.movie_library ? "Movies" : "Seasons"
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 20
            }

            ListView {
                id: media_dirs_list_view
                model: Server.media_dirs
                width: parent.width
                height: app.movie_library && app.viewing_collection
                    ? 0
                    : contentHeight

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true

                delegate: Button {
                    text: modelData.name
                    enabled: !media_dirs_root.loading
                    width: 250
                    height: 35
                    anchors.horizontalCenter: parent?.horizontalCenter

                    onClicked: {
                        media_dirs_root.loading = true
                        app.media_dir_id = modelData.id
                        app.media_dir_name = modelData.name
                        Server.req_videos(modelData.id, Server.CALLEE_MEDIA_DIRS)
                    }
                }
            }

            ListView {
                model: Server.collection_movies
                width: parent.width
                height: app.movie_library && app.viewing_collection
                    ? contentHeight
                    : 0

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true

                delegate: Button {
                    text: modelData.name
                    enabled: !media_dirs_root.loading
                    width: 250
                    height:35
                    anchors.horizontalCenter: parent?.horizontalCenter

                    onClicked: {
                        media_dirs_root.loading = true
                        app.media_dir_id = modelData.movie_id
                        app.media_dir_name = modelData.name
                        Server.req_videos(modelData.movie_id, Server.CALLEE_MEDIA_DIRS)
                    }
                }
            }
        }
    }
}
