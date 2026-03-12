import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects

Button {
  id: button
  flat: true

  contentItem: Image {
    id: image
    source: button.icon.source
  }

  background: MultiEffect {
    source: image
    anchors.fill: button
    visible: button.down
    opacity: 0.5
    shadowEnabled: true
    blurEnabled: true
    blur: 0.5
  }
}