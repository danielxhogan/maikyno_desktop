qt_add_library(player STATIC)

qt_add_qml_module(player
  URI "player"
  QML_FILES
    "Main.qml"
    "PlayerControls.qml"
    "PlayerButton.qml"
  RESOURCES
    "icons/play.svg"
    "icons/stop.svg"
)
