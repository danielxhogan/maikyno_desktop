import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: app
    width: 1600
    height: 900
    visible: true
    title: qsTr("maikyno")

    property string library_id;
    property string library_name;
    property bool viewing_collection;
    property bool movie_library;
    property string show_name;
    property string media_dir_id;
    property string media_dir_name;
    property string video_id;

    property string src;
    property string ts;
    property string a_stream_idx;
    property string v_stream_idx;
    property string s_stream_idx;
    property string s_pos;

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
        id: shows_component
        ShowsPage { id: shows_page }
    }
    Component {
        id: media_dirs_component
        MediaDirsPage { id: media_dirs_page }
    }
    Component {
        id: videos_component
        VideosPage { id: videos_page }
    }
    Component {
        id: configurator_component
        ConfiguratorPage { id: configurator_page }
    }
    Component {
        id: player_component
        PlayerPage { id: player_page }
    }
}
