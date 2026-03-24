import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Play a video" }
        Button {
            text: "The Terminator - Director's Cut"
            onClicked: pages_stack.push(player_component)
        }
        Button {
            text: "Back"; onClicked: pages_stack.pop();
        }
    }
}
