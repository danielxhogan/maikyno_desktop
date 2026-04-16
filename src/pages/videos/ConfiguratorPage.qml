import QtQuick
import QtQuick.Controls
import Server

Item {
    id: configurator_root
    readonly property var codecs: ({ "H264": 27, "H265": 173 })

    ScrollView {
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        contentHeight: main_col.implicitHeight + 60

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Button {
                text: "Back";
                anchors.left: parent.left
                onClicked: pages_stack.pop();
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

            ListView {
                width: parent.width
                height: contentHeight
                clip: true
                model: Server.video_streams

                delegate: Item {
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

                        ListView {
                            width: parent.width
                            height: contentHeight
                            clip: true
                            model: modelData.streams
                            spacing: 15

                            delegate: Column {
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

                                Text {
                                    text: "New Title"
                                    font.bold: true
                                    font.pixelSize: 14
                                }

                                Text {
                                    text: "Passthrough"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type != 3
                                    height: modelData.stream_type == 3
                                        ? 0
                                        : contentHeight
                                }

                                Text {
                                    text: "Codec"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 0
                                    height: modelData.stream_type == 0
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Hardware Acceleration"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 0
                                    height: modelData.stream_type == 0
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Deinterlace"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 0
                                    height: modelData.stream_type == 0
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Boost Gain"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 1
                                    height: modelData.stream_type == 1
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Burn In"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 3
                                    height: modelData.stream_type == 3
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Create Renditions"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type != 3
                                    height: modelData.stream_type == 3
                                        ? 0
                                        : contentHeight
                                }

                                Text {
                                    text: " "
                                    font.bold: true
                                    font.pixelSize: 18

                                    visible: modelData.stream_type != 3
                                    height: modelData.stream_type == 3
                                        ? 0
                                        : 5
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

                                Text {
                                    text: "Title"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type != 3
                                    height: modelData.stream_type == 3
                                        ? 0
                                        : contentHeight
                                }

                                Text {
                                    text: "Codec"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 0
                                    height: modelData.stream_type == 0
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Hardware Acceleration"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 0
                                    height: modelData.stream_type == 0
                                        ? contentHeight
                                        : 0
                                }

                                Text {
                                    text: "Boost Gain"
                                    font.bold: true
                                    font.pixelSize: 14

                                    visible: modelData.stream_type == 1
                                    height: modelData.stream_type == 1
                                        ? contentHeight
                                        : 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}