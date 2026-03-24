qt_add_library(pages STATIC)

qt_add_qml_module(pages
    URI "pages"
    QML_FILES
        "Pages.qml"
)

add_subdirectory(player)
