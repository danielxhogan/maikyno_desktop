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
    media_player.play()
  }

  function open_file(path) {
    media_player.source = path
    media_player.play();
  }

  MediaPlayer {
    id: media_player
    videoOutput: video_output
    audioOutput: AudioOutput {
      id: audio_output
    }
  }

  VideoOutput {
    id: video_output
    anchors.fill: parent
  }

  PlayerControls {
    id: playback_control
    media_player: media_player
  }

  Component.onCompleted: {
    if (source.toString().length > 0)
      open_file(source)
  }
}
