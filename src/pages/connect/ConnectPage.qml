import QtQuick
import QtQuick.Controls

Item {
    id: connect_root
    property bool loading: false

    Connections {
        target: server

        function onGet_libraries_response_sucess()
        {
            connect_root.loading = false;
            config.ip = ip_field.text
            pages_stack.push(libraries_component)
        }

        function onGet_libraries_response_error(message)
        {
            connect_root.loading = false;
            error_message.text = message
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Connect to server" }
        Text {
            id: error_message
            text: ""
        }
        TextField {
            id: ip_field;
            text: config.ip
        }
        Button {
            text: "Connect"
            enabled: !connect_root.loading
            onClicked: {
                connect_root.loading = true
                server.get_libraries(ip_field.text)
            }
        }
    }
}
