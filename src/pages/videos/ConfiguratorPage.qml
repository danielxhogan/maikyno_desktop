import QtQuick
import QtQuick.Controls
import Server

Item {
    id: configurator_root
    property bool loading: false
    property var cfg_state: ({ "media_dir_id": "", "videos": [] })
    property var idx_maps: ([])
    readonly property var codecs: ({ "h264": 27, "h265": 173 })

    function initialize_cfg_state()
    {
        let videos = []

        for (let i = 0; i < Server.video_streams.length; i++) {
            let idx_map = []
            let video_streams_element = Server.video_streams[i];
            let process_video_info = {
                "video_id": video_streams_element.video.id,
                "title": video_streams_element.video.suggested_title,
                "video_stream": null,
                "audio_streams": [],
                "subtitle_streams": []
            }

            let found_v_stream = false
            for (let j = 0; j < video_streams_element.streams.length; j++) {
                let stream = video_streams_element.streams[j]

                if (stream.stream_type == 0) {
                    if (found_v_stream) continue;
                    found_v_stream = true;

                    idx_map.push(-1)
                    let uhd = false;
                    if (stream.width >= 3840 && stream.height >= 2160) {
                        uhd = true;
                    }

                    process_video_info.video_stream = {
                        "id": stream.id,
                        "title": uhd ? "4K" : null,
                        "passthrough": false,
                        "codec": codecs["h265"],
                        "hwaccel": uhd ? false : true,
                        "deinterlace": stream.interlaced ? true : false,
                        "create_renditions": uhd ? true : false,
                        "title2": uhd ? "HD" : null,
                        "codec2": codecs["h265"],
                        "hwaccel2": true,
                        "tonemap": true
                    }
                } else if (stream.stream_type == 1) {
                    idx_map.push(process_video_info.audio_streams.length)

                    let lossless = stream.codec == "DTS-HD MA"
                        || stream.codec == "DTS-HD MA + DTS:X"
                        || stream.codec == "Dolby TrueHD"
                        || stream.codec == "Dolby TrueHD + Dolby Atmos"

                    process_video_info.audio_streams.push({
                        "id": stream.id,
                        "title": lossless ? stream.title : "Stereo",
                        "passthrough": lossless ? true : false,
                        "gain_boost": 8,
                        "create_renditions": false,
                        "title2": "Stereo",
                        "gain_boost2": 0,
                        "ignore": false
                    })
                } else if (stream.stream_type == 3) {
                    idx_map.push(process_video_info.subtitle_streams.length)
                    process_video_info.subtitle_streams.push({
                        "id": stream.id,
                        "title": stream.title,
                        "burn_in": false,
                        "ignore": false
                    })
                }
            }

            videos.push(process_video_info)
            idx_maps.push(idx_map)
        }

        cfg_state = {
            "media_dir_id": app.media_dir_id,
            "videos": videos
        }
    }

    Component.onCompleted: {
        initialize_cfg_state();
    }

    Connections {
        target: Server

        function onProcess_media_success()
        {
            configurator_root.loading = false
            configurator_err_msg.text = "Processing Media"
        }

        function onProcess_media_error(message)
        {
            configurator_root.loading = false
            configurator_err_msg.text = message
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Button {
                text: "Back"
                enabled: !configurator_root.loading
                anchors.left: parent.left
                onClicked: pages_stack.pop();
            }

            Button {
                text: "Start processing"
                enabled: !configurator_root.loading
                anchors.right: parent.right
                leftPadding: 10
                rightPadding: 10

                onClicked: {
                    configurator_root.loading = true
                    Server.process_media(configurator_root.cfg_state);
                }
            }
        }

        Column {
            id: main_col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: parent.width
            spacing: 20

            Text {
                id: title1
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Process Job Configurator"
                font.bold: true
                font.pixelSize: 20
            }

            Text {
                id: title2
                anchors.horizontalCenter: parent.horizontalCenter
                text: app.movie_library
                    ? app.media_dir_name
                    : app.show_name + " " + app.media_dir_name
                font.bold: true
                font.pixelSize: 28
            }

            Text {
                id: configurator_err_msg
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 16
                text: ""
            }

            ListView {
                model: Server.video_streams
                width: parent.width
                height: contentHeight
                spacing: 45
                clip: true

                delegate: Item {
                    readonly property int video_idx: index
                    width: parent.width
                    height: outer_list_col.height + 20

                    Column {
                        id: outer_list_col
                        width: parent.width

                        Text {
                            text: modelData.video.name
                            height: contentHeight + 10
                            font.bold: true
                            font.pixelSize: 24
                        }

                        Row {
                            spacing: 10

                            Text {
                                text: " New Title"
                                height: contentHeight + 25
                                font.bold: true
                                font.pixelSize: 16
                            }

                            TextField {
                                text: cfg_state.videos[video_idx].title
                                width: 300

                                onTextEdited: {
                                    cfg_state.videos[video_idx].title = text
                                }
                            }
                        }

                        ListView {
                            model: modelData.streams
                            width: parent.width
                            height: contentHeight
                            spacing: 35
                            clip: true

                            delegate: Column {
                                spacing: 15
                                readonly property int stream_idx: index

                                Row {
                                    Text {
                                        text: "Stream "  + modelData.stream_idx
                                        height: contentHeight + 5
                                        font.bold: true
                                        font.pixelSize: 20
                                    }

                                    Text {
                                        text: "    Title: " + modelData.title
                                        visible: modelData.title
                                        width: modelData.title ? contentWidth : 0
                                        font.bold: true
                                        font.pixelSize: 20
                                    }

                                    Text {
                                        text: "    Codec: "  + modelData.codec
                                        font.bold: true
                                        font.pixelSize: 20
                                    }

                                    Text {
                                        text: "    Height: "  + modelData.height
                                        visible: modelData.height
                                        width: modelData.height ? contentWidth : 0
                                        font.bold: true
                                        font.pixelSize: 20
                                    }

                                    Text {
                                        text: "    Width: "  + modelData.width
                                        visible: modelData.width
                                        width: modelData.width ? contentWidth : 0
                                        font.bold: true
                                        font.pixelSize: 20
                                    }

                                    Text {
                                        text: "    Interlaced"
                                        visible: modelData.interlaced
                                        width: modelData.interlaced ? contentWidth : 0
                                        font.bold: true
                                        font.pixelSize: 20
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "New Title"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200
                                    }

                                    TextField {
                                        text: modelData.stream_type == 0
                                            ? cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .title
                                            : modelData.stream_type == 1
                                            ? cfg_state
                                                .videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .title
                                            : cfg_state
                                                .videos[video_idx]
                                                .subtitle_streams[idx_maps[video_idx][stream_idx]]
                                                .title

                                        onTextEdited: {
                                            if (modelData.stream_type == 0) {
                                                cfg_state
                                                    .videos[video_idx]
                                                    .video_stream
                                                    .title
                                                    = text
                                            } else if (modelData.stream_type == 1) {
                                                cfg_state
                                                    .videos[video_idx]
                                                    .audio_streams[idx_maps[video_idx][stream_idx]]
                                                    .title
                                                    = text
                                            } else {
                                                cfg_state
                                                    .videos[video_idx]
                                                    .subtitle_streams[idx_maps[video_idx][stream_idx]]
                                                    .title
                                                    = text
                                            }
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Passthrough"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : contentHeight
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : parent.height

                                        checked: modelData.stream_type == 0
                                            ? cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .passthrough
                                            : modelData.stream_type == 1
                                            ? cfg_state
                                                .videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .passthrough
                                            : false

                                        onCheckedChanged: {
                                            let temp = cfg_state
                                            if (modelData.stream_type == 0) {
                                                temp.videos[video_idx]
                                                    .video_stream
                                                    .passthrough
                                                    = checked
                                            } else if (modelData.stream_type == 1) {
                                                temp.videos[video_idx]
                                                    .audio_streams[idx_maps[video_idx][stream_idx]]
                                                    .passthrough
                                                    = checked
                                            }
                                            cfg_state = temp
                                        }
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "Codec"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? contentHeight
                                            : 0
                                    }

                                    ComboBox {
                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? parent.height
                                            : 0

                                        model: Object.keys(codecs)

                                        currentIndex: {
                                            let current_val = cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .codec

                                            return model
                                                .indexOf(Object
                                                    .keys(codecs)
                                                    .find(key => codecs[key] == current_val))
                                        }

                                        onActivated: (index) => {
                                            let selected_codec_name =
                                                model[index]

                                            let selected_codec_id =
                                                codecs[selected_codec_name]

                                            let temp = cfg_state

                                            temp.videos[video_idx]
                                                .video_stream
                                                .codec
                                                = selected_codec_id

                                            cfg_state = temp
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Hardware Acceleration"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? contentHeight
                                            : 0
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? parent.height
                                            : 0

                                        checked: cfg_state
                                            .videos[video_idx]
                                            .video_stream
                                            .hwaccel

                                        onCheckedChanged: {
                                            cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .hwaccel
                                                = checked
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Deinterlace"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? contentHeight
                                            : 0
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? parent.height
                                            : 0

                                        checked: cfg_state
                                            .videos[video_idx]
                                            .video_stream
                                            .deinterlace

                                        onCheckedChanged: {
                                            cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .deinterlace
                                                = checked
                                        }
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "Boost Gain"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 1
                                        height: modelData.stream_type == 1
                                            ? contentHeight
                                            : 0
                                    }

                                    SpinBox {
                                        visible: modelData.stream_type == 1
                                        height: modelData.stream_type == 1
                                            ? parent.height
                                            : 0

                                        from: 0
                                        to: 10
                                        stepSize: 1
                                        editable: true

                                        value: modelData.stream_type == 1
                                        ? cfg_state
                                            .videos[video_idx]
                                            .audio_streams[idx_maps[video_idx][stream_idx]]
                                            .gain_boost
                                        : 0

                                        onValueModified: {
                                            if (modelData.stream_type != 1) return

                                            let temp = cfg_state

                                            temp.videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .gain_boost
                                                = value

                                            cfg_state = temp
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Burn In"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 3
                                        height: modelData.stream_type == 3
                                            ? contentHeight
                                            : 0
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type == 3
                                        height: modelData.stream_type == 3
                                            ? parent.height
                                            : 0

                                        checked: modelData.stream_type == 3
                                        ? cfg_state
                                            .videos[video_idx]
                                            .subtitle_streams[idx_maps[video_idx][stream_idx]]
                                            .burn_in
                                        : false

                                        onCheckedChanged: {
                                            cfg_state
                                                .videos[video_idx]
                                                .subtitle_streams[idx_maps[video_idx][stream_idx]]
                                                .burn_in
                                                = checked
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Create Renditions"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : contentHeight
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : parent.height

                                        checked: modelData.stream_type == 0
                                            ? cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .create_renditions
                                            : modelData.stream_type == 1
                                            ? cfg_state
                                                .videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .create_renditions
                                            : false

                                        onCheckedChanged: {
                                            let temp = cfg_state
                                            if (modelData.stream_type == 0) {
                                                temp.videos[video_idx]
                                                    .video_stream
                                                    .create_renditions
                                                    = checked
                                            } else if (modelData.stream_type == 1) {
                                                temp.videos[video_idx]
                                                    .audio_streams[idx_maps[video_idx][stream_idx]]
                                                    .create_renditions
                                                    = checked
                                            }
                                            cfg_state = temp
                                        }
                                    }
                                }

                                Text {
                                    text: "Second Rendition"
                                    font.bold: true
                                    font.pixelSize: 18

                                    visible: modelData.stream_type != 3
                                    height: modelData.stream_type == 3
                                        ? 0
                                        : contentHeight
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "New Title"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : contentHeight
                                    }

                                    TextField {
                                        visible: modelData.stream_type != 3
                                        height: modelData.stream_type == 3
                                            ? 0
                                            : contentHeight + 5

                                        text: modelData.stream_type == 0
                                            ? cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .title2
                                            : modelData.stream_type == 1
                                            ? cfg_state
                                                .videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .title2
                                            : null

                                        onTextEdited: {
                                            if (modelData.stream_type == 0) {
                                                cfg_state
                                                    .videos[video_idx]
                                                    .video_stream
                                                    .title
                                                    = text
                                            } else if (modelData.stream_type == 1) {
                                                cfg_state
                                                    .videos[video_idx]
                                                    .audio_streams[idx_maps[video_idx][stream_idx]]
                                                    .title
                                                    = text
                                            }
                                        }
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "Codec"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? contentHeight
                                            : 0
                                    }

                                    ComboBox {
                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? parent.height
                                            : 0

                                        model: Object.keys(codecs)

                                        currentIndex: {
                                            let current_val = cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .codec2

                                            return model
                                                .indexOf(Object
                                                .keys(codecs)
                                                .find(key => codecs[key] == current_val))
                                        }

                                        onActivated: (index) => {
                                            let selected_codec_name
                                                = model[index]

                                            let selected_codec_id
                                                = codecs[selected_codec_name]

                                            let temp = cfg_state

                                            temp.videos[video_idx]
                                                .video_stream
                                                .codec2
                                                = selected_codec_id

                                            cfg_state = temp
                                        }
                                    }
                                }

                                Row {
                                    Text {
                                        text: "Hardware Acceleration"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? contentHeight
                                            : 0
                                    }

                                    CheckBox {
                                        visible: modelData.stream_type == 0
                                        height: modelData.stream_type == 0
                                            ? parent.height
                                            : 0

                                        checked: cfg_state
                                            .videos[video_idx]
                                            .video_stream
                                            .hwaccel2

                                        onCheckedChanged: {
                                            cfg_state
                                                .videos[video_idx]
                                                .video_stream
                                                .hwaccel2
                                                = checked
                                        }
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: "Boost Gain"
                                        font.bold: true
                                        font.pixelSize: 14
                                        width: 200

                                        visible: modelData.stream_type == 1
                                        height: modelData.stream_type == 1
                                            ? contentHeight
                                            : 0
                                    }

                                    SpinBox {
                                        visible: modelData.stream_type == 1
                                        height: modelData.stream_type == 1
                                            ? parent.height
                                            : 0

                                        from: 0
                                        to: 10
                                        stepSize: 1
                                        editable: true

                                        value: modelData.stream_type == 1
                                        ? cfg_state
                                            .videos[video_idx]
                                            .audio_streams[idx_maps[video_idx][stream_idx]]
                                            .gain_boost2
                                        : 0

                                        onValueModified: {
                                            if (modelData.stream_type != 1) return
                                            let temp = cfg_state

                                            temp.videos[video_idx]
                                                .audio_streams[idx_maps[video_idx][stream_idx]]
                                                .gain_boost2
                                                = value

                                            cfg_state = temp
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}