import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Server

Item {
    id: create_library_root
    property bool loading: false
    property string library_type: "movie"
    property string library_name

    Connections {
        target: Server

        function onCreate_library_success()
        {
            create_library_root.loading = false
            create_library_err_msg.text = ""
            app.creating_library = true
            pages_stack.push(library_dirs_component)
        }

        function onCreate_library_error(message)
        {
            create_library_root.loading = false
            create_library_err_msg.text = message
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
                text: "Create Library"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: create_library_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            Text {
                id: library_type_title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Library Type"
                font.bold: true
                font.pixelSize: 18
            }

            RowLayout {
                width: 200
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                ButtonGroup {
                    id: library_type_group
                }

                RadioButton {
                    id: movie_radio_btn
                    text: "Movie"
                    checked: true
                    ButtonGroup.group: library_type_group
                    Layout.fillWidth: true

                    onCheckedChanged: {
                        if (checked) {
                            create_library_root.library_type = "movie"
                        }
                    }
                }

                RadioButton {
                    id: show_radio_btn
                    text: "Show"
                    checked: false
                    ButtonGroup.group: library_type_group
                    Layout.fillWidth: true

                    onCheckedChanged: {
                        if (checked) {
                            create_library_root.library_type = "show"
                        }
                    }
                }
            }

            Text {
                id: library_name_title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Library Name"
                font.bold: true
                font.pixelSize: 18
            }

            TextField {
                anchors.horizontalCenter: parent.horizontalCenter
                onTextEdited: {
                    create_library_root.library_name = text
                }
            }

            Button {
                text: "Create Library"
                leftPadding: 10
                rightPadding: 10
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    create_library_root.loading = true
                    Server.create_library(create_library_root.library_type,
                        create_library_root.library_name)
                }
            }
        }
    }
}
