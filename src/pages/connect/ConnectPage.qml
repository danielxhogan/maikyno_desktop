import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Connect to server" }
        TextField {
            id: ip_field;
            text: config.ip
        }
        Button {
            text: "Connect"
            onClicked: {
                config.ip = ip_field.text
                pages_stack.push(libraries_component)
            }
        }
    }
}
