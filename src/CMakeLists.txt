qt_add_executable(maikyno_desktop
  "main.cpp"
)

add_subdirectory(pages)
add_subdirectory(player)

target_link_libraries(maikyno_desktop PRIVATE
    Qt6::Core
    Qt6::Quick
    pagesplugin
    player
)
