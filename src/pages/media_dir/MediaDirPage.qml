import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Select a movie" }
        Button {
            text: "The Terminator"
            onClicked: pages_stack.push(videos_component)
        }
        Button {
            text: "Back"; onClicked: pages_stack.pop();
        }
    }
}
