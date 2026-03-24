import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Select a library" }
        Button {
            text: "Movies library"
            onClicked: pages_stack.push(media_dir_component)
        }
        Button {
            text: "Back"; onClicked: pages_stack.pop();
        }
    }
}
