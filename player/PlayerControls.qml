import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
  id: root

  required property MediaPlayer media_player

  Item {
    anchors.fill: root

    RowLayout {
      id: buttons

      PlayerButton {
        id: play_button
        icon.source: "icons/play.svg"
        onClicked: root.media_player.play()
      }

      PlayerButton {
        id: paused_button
        icon.source: "icons/stop.svg"
        onClicked: root.media_player.pause()
      }
    }
  }
}