import QtQuick
import QtQuick.Controls
import QtQml.Models
import Server

Item {
    id: process_jobs_root
    property bool loading: false

    Connections {
        target: Server

        function onAbort_batch_success()
        {
            process_jobs_root.loading = false;
        }

        function onAbort_batch_error(message)
        {
            videos_root.loading = false
            vidoes_err_msg.text = message
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
                text: "Process Jobs"
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
                font.pixelSize: 30
            }

            ListView {
                model: Server.process_job_batches
                width: parent.width
                height: contentHeight
                spacing: 60

                delegate: Column {
                    spacing: 20
                    readonly property int batch_idx: index

                    Text {
                        id: batch_title
                        text: "Batch " + (batch_idx + 1)
                        font.bold: true
                        font.pixelSize: 30
                    }

                    Button {
                        text: "Abort"
                        visible: modelData.active

                        onClicked: {
                            process_jobs_root.loading = true
                            Server.abort_batch(modelData.batch_id)
                        }
                    }

                    ListView {
                        model: modelData.process_jobs
                        width: parent.width
                        height: contentHeight
                        spacing: 40

                        delegate: Column {
                            spacing: 20

                            Row {
                                spacing: 20

                                Text {
                                    text: modelData.process_job.video_name
                                    font.bold: true
                                    font.pixelSize: 24
                                }

                            }

                            Row {
                                spacing: 15

                                Text {
                                    text: "Created: "
                                        + modelData.process_job.created.slice(0, 10)
                                        + " "
                                        + modelData.process_job.created.slice(11, 19)

                                    font.bold: true
                                    font.pixelSize: 20
                                }
                                Text {

                                    text: "Status: "
                                        + modelData.process_job.job_status

                                    font.bold: true
                                    font.pixelSize: 20
                                }
                            }
                        }
                    }

                }
            }
        }
    }
}
