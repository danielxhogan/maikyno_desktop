cmake_minimum_required(VERSION 3.28)
project(maikyno_desktop LANGUAGES CXX)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Quick)
qt_standard_project_setup(REQUIRES 6.5)
qt_policy(SET QTP0004 NEW)

find_package(PkgConfig REQUIRED)

add_subdirectory(src)

include(GNUInstallDirs)
install(TARGETS mkd
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES maikyno.desktop DESTINATION $ENV{HOME}/.local/share/applications)
