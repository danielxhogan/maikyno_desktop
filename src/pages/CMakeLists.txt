qt_add_library(pages STATIC)

qt_add_qml_module(pages
    URI "pages"
    QML_FILES
        "Main.qml"
        "connect/ConnectPage.qml"
        "libraries/LibrariesPage.qml"
        "media_dir/MediaDirPage.qml"
        "videos/VideosPage.qml"
        "player/PlayerPage.qml"
)
