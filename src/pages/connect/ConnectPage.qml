import QtQuick
import QtQuick.Controls
import Server

Item {
    id: connect_root
    property bool loading: false

    Connections {
        target: Server

        function onReq_libraries_success()
        {
            connect_root.loading = false
            connect_err_msg.text = ""
            Server.ip = ip_field.text
            pages_stack.push(libraries_component)
        }

        function onReq_libraries_error(message)
        {
            connect_root.loading = false
            connect_err_msg.text = message
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Column {
            id: main_col
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 40
            spacing: 20

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connect to server"
                font.bold: true
                font.pixelSize: 24
            }

            Text {
                id: connect_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
            }

            TextField {
                id: ip_field;
                anchors.horizontalCenter: parent.horizontalCenter
                text: Server.ip
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connect"
                enabled: !connect_root.loading
                onClicked: {
                    connect_root.loading = true
                    Server.req_libraries(ip_field.text)
                }
            }
        }
    }
}
