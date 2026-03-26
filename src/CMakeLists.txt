qt_add_executable(maikyno_desktop
    "main.cpp"
    "network/Server.cpp"
    "player/Player.cpp"
    "player/MpvBackend.cpp"
)

qt_add_qml_module(maikyno_desktop
    URI "pages"
    QML_FILES
        "pages/Main.qml"
        "pages/connect/ConnectPage.qml"
        "pages/libraries/LibrariesPage.qml"
        "pages/media_dir/MediaDirPage.qml"
        "pages/videos/VideosPage.qml"
        "pages/player/PlayerPage.qml"
)

pkg_check_modules(MPV REQUIRED IMPORTED_TARGET mpv)

target_link_libraries(maikyno_desktop PRIVATE
    Qt6::Core
    Qt6::Quick
    PkgConfig::MPV
)
