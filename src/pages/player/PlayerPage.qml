import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Player coming soon" }
        Button {
            text: "Back"; onClicked: pages_stack.pop();
        }
    }
}
