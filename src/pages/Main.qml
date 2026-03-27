import QtQuick
import QtQuick.Controls
import Server

ApplicationWindow {
    id: app
    width: 1600
    height: 900
    visible: true
    title: qsTr("maikyno")
    property string src;

    Server { id: server }

    StackView {
        id: pages_stack
        anchors.fill: parent
        initialItem: connect_component

        pushEnter: Transition {}
        pushExit: Transition {}
        popEnter: Transition {}
        popExit: Transition {}
    }

    Component {
        id: connect_component
        ConnectPage { id: connect_page }
    }
    Component {
        id: libraries_component
        LibrariesPage { id: libraries_page }
    }
    Component {
        id: media_dir_component
        MediaDirPage { id: media_dir_page }
    }
    Component {
        id: videos_component
        VideosPage { id: videos_page }
    }
    Component {
        id: player_component
        PlayerPage { id: player_page }
    }
}
