import QtQuick
import QtQuick.Controls.Fusion
import QtMultimedia

ApplicationWindow {
  id: root
  width: 1280
  height: 720
  visible: true
  title: qsTr("maikyno")
  required property url source

  function play_media() {
    console.log(`root.source: ${root.source}`)
    media_player.play()
  }

  Component.onCompleted: {
    play_media()
  }

  MediaPlayer {
    id: media_player
    videoOutput: video_output
    audioOutput: AudioOutput {
      id: audio_output
    }
    source: root.source
  }

  VideoOutput {
    id: video_output
    anchors.fill: parent
  }
}
