qt_add_executable(mkd
    "main.cpp"
    "network/Server.cpp"
    "player/Player.cpp"
)

qt_add_qml_module(mkd
    URI "pages"
    QML_FILES
        "pages/Main.qml"
        "pages/connect/ConnectPage.qml"
        "pages/libraries/LibrariesPage.qml"
        "pages/shows/ShowsPage.qml"
        "pages/media_dirs/MediaDirsPage.qml"
        "pages/videos/VideosPage.qml"
        "pages/player/PlayerPage.qml"
)

target_link_libraries(mkd PRIVATE
    Qt6::Core
    Qt6::Quick
)

option(USE_MKP_BACKEND "Use the custom mkp library instead of mpv" OFF)
add_subdirectory(player)
