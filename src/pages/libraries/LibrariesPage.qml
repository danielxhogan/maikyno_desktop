import QtQuick
import QtQuick.Controls
import Server

Item {
    id: libraries_root
    property bool loading: false
    property string media_type

    Connections {
        target: Server

        function onReq_collections_success()
        {
            Server.req_library_contents(app.library_id,
                Server.library_type_qstring_to_enum(media_type),
                Server.CALLEE_LIBRARIES)
        }

        function onReq_collections_error(message)
        {
            libraries_root.loading = false
            libraries_err_msg.text = message
        }

        function onInitial_req_shows_success()
        {
            libraries_root.loading = false
            libraries_err_msg.text = ""
            app.movie_library = false
            app.viewing_collection = false
            pages_stack.push(shows_component)
        }

        function onInitial_req_shows_error(message)
        {
            libraries_root.loading = false
            libraries_err_msg.text = message
        }

        function onInitial_req_movies_success()
        {
            libraries_root.loading = false
            libraries_err_msg.text = ""
            app.movie_library = true
            app.viewing_collection = false
            pages_stack.push(media_dirs_component)
        }

        function onInitial_req_movies_error(message)
        {
            libraries_root.loading = false
            libraries_err_msg.text = message
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
                onClicked: pages_stack.pop()
            }

            Button {
                text: "Create Library"
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10
                onClicked: pages_stack.push(create_library_component)
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
                text: "Libraries"
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
                        app.library_name = modelData.name
                        media_type = modelData.media_type
                        Server.req_collections(modelData.id)
                    }
                }

            }
        }
    }
}
