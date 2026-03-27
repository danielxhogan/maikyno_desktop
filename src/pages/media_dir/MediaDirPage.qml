import QtQuick
import QtQuick.Controls

Item {
    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: parent.width
            spacing: 40

            Button {
                text: "Back"; onClicked: pages_stack.pop();
            }

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Select a movie"
                font.bold: true
                font.pixelSize: 24
            }

            ListView {
                width: parent.width
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                clip: true
                model: server.media_dirs

                delegate: Button {
                    width: 175
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    // enabled: !libraries_root.loading
                    // onClicked: {
                    //     libraries_root.loading = true
                    //     server.req_library_contents(modelData.id, modelData.media_type)
                    // }
                }
            }

            // Button {
            //     text: "The Terminator"
            //     onClicked: pages_stack.push(videos_component)
            // }
        }
    }
}
