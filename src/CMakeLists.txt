qt_add_executable(mkd
    "main.cpp"
    "network/Server.cpp"
    "player/Player.cpp"
    "player/MpvBackend.cpp"
    "player/MkpBackend.cpp"
)

qt_add_qml_module(mkd
    URI "pages"
    QML_FILES
        "pages/Main.qml"
        "pages/connect/ConnectPage.qml"
        "pages/libraries/LibrariesPage.qml"
        "pages/media_dir/MediaDirPage.qml"
        "pages/videos/VideosPage.qml"
        "pages/player/PlayerPage.qml"
)

target_link_libraries(mkd PRIVATE
    Qt6::Core
    Qt6::Quick
)

option(USE_MKP_BACKEND "Use the custom mkp library instead of mpv" OFF)

if(USE_MKP_BACKEND)
    message(STATUS "Building with MKP backend")
    add_definitions(-DUSE_MKP)
    # pkg_check_modules(LIBMKP REQUIRED IMPORTED_TARGET libmkp)
    # target_link_libraries(mkd PRIVATE PkgConfig::LIBMKP)
else()
    message(STATUS "Building with MPV backend")
    add_definitions(-DUSE_MPV)
    # pkg_check_modules(MPV REQUIRED IMPORTED_TARGET mpv)
    # target_link_libraries(mkd PRIVATE PkgConfig::MPV)
endif()

pkg_check_modules(LIBMKP REQUIRED IMPORTED_TARGET libmkp)
target_link_libraries(mkd PRIVATE PkgConfig::LIBMKP)
pkg_check_modules(MPV REQUIRED IMPORTED_TARGET mpv)
target_link_libraries(mkd PRIVATE PkgConfig::MPV)
