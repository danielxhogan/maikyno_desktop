import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Server

Item {
    id: library_dirs_root
    property bool loading: false
    property string new_library_dir: ""

    Connections {
        target: Server

        function onCreate_library_dir_success()
        {
            library_dirs_root.loading = false
            create_library_dir_err_msg.text = ""
            Server.req_library_dirs(app.library_id, Server.CALLEE_LIBRARY_DIRS)
        }

        function onCreate_library_dir_error(message)
        {
            library_dirs_root.loading = false
            create_library_dir_err_msg.text = message
        }

        function onLibrary_dirs_req_library_dirs_success()
        {
            library_dirs_root.loading = false
            create_library_dir_err_msg.text = ""
        }

        function onLibrary_dirs_req_library_dirs_error(message)
        {
            library_dirs_root.loading = false
            create_library_dir_err_msg.text = message
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
                    pages_stack.pop()
                    if (app.creating_library) {
                        pages_stack.pop()
                    }
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
                text: "Library Folders"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: create_library_dir_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            ListView {
                model: Server.library_dirs
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true

                delegate: RowLayout {
                    height: 45
                    spacing: 25
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: modelData.real_path
                        font.pixelSize: 18
                        height: 45
                    }

                    Button {
                        text: "Remove"
                    }
                }
            }

            Text {
                id: library_type_title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Add Library Folder"
                font.bold: true
                font.pixelSize: 18
            }

            TextField {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                onTextEdited: {
                    library_dirs_root.new_library_dir = text
                }
            }

            Button {
                text: "Submit"
                leftPadding: 10
                rightPadding: 10
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    library_dirs_root.loading = true
                    if (app.creating_library) {
                        Server.create_library_dir(null,
                            library_dirs_root.new_library_dir)
                    } else {
                        Server.create_library_dir(app.library_id,
                            library_dirs_root.new_library_dir)
                    }
                }
            }
        }
    }
}
