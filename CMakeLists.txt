cmake_minimum_required(VERSION 3.28)
project(maikyno_desktop LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Quick)
qt_standard_project_setup(REQUIRES 6.5)
qt_policy(SET QTP0004 NEW)

find_package(PkgConfig REQUIRED)

add_subdirectory(src)
