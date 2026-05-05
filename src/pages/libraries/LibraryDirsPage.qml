import QtQuick
import QtQuick.Controls
import Server

Item {
    id: library_dirs_root
    property bool loading: false
    property string new_library_dir: ""

    Connections {
        target: Server

        function onCreate_library_dir_success()
        {

        }

        function onCreate_library_dir_error(message)
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
                text: "Library Dirs"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: create_library_dir_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            Text {
                id: library_type_title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Add Library Directory"
                font.bold: true
                font.pixelSize: 18
            }

            TextField {
                anchors.horizontalCenter: parent.horizontalCenter
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
                    Server.create_library_dir(null,
                        library_dirs_root.new_library_dir)
                }
            }
        }
    }
}
