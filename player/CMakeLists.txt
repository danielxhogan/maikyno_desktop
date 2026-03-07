qt_add_library(player STATIC)

qt_add_qml_module(player
  URI "player"
  QML_FILES
    "Main.qml"
)
