qt_add_library(player STATIC
    "Player.cpp"
    "PlayerRenderNode.cpp"
    "MpvBackend.cpp"
)

pkg_check_modules(MPV REQUIRED IMPORTED_TARGET mpv)

target_link_libraries(player PRIVATE
    Qt6::Core
    Qt6::Quick
    PkgConfig::MPV
)
