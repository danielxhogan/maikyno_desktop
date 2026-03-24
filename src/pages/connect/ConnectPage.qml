import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Connect to server" }
        TextField { id: ip; }
        Button {
            text: "Connect"
            onClicked: pages_stack.push(libraries_component)
        }
    }
}
