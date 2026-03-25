import QtQuick
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { text: "Play a video" }
        Button {
            text: "The Terminator - Director's Cut"
            onClicked: {
                app.src = "http://192.168.1.209:8080/media/tha_movies/mk_movies/collections/The Terminator Series/01 - The Terminator/The Terminator.mkv"
                pages_stack.push(player_component)
            }
        }
        Button {
            text: "Back"; onClicked: pages_stack.pop();
        }
    }
}
