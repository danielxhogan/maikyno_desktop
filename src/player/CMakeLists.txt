option(USE_MKP_BACKEND "Use the custom mkp library instead of mpv" OFF)

if(USE_MKP_BACKEND)
    message(STATUS "Building with MKP backend")
    qt_add_library(mkp_backend STATIC
        "MkpBackend.cpp"
    )


    pkg_check_modules(LIBMKP REQUIRED IMPORTED_TARGET libmkp)
    target_link_libraries(mkp_backend PRIVATE
        Qt6::Quick
        PkgConfig::LIBMKP
    )

    target_include_directories(mkp_backend INTERFACE ${LIBMKP_INCLUDE_DIRS})
    target_compile_definitions(mkp_backend INTERFACE USE_MKP)
    target_link_libraries(mkd PRIVATE mkp_backend)
else()
    message(STATUS "Building with MPV backend")
    qt_add_library(mpv_backend STATIC
        "MpvBackend.cpp"
    )

    pkg_check_modules(MPV REQUIRED IMPORTED_TARGET mpv)
    target_link_libraries(mpv_backend PRIVATE
        Qt6::Quick
        PkgConfig::MPV
    )

    target_include_directories(mpv_backend INTERFACE ${MPV_INCLUDE_DIRS})
    target_compile_definitions(mpv_backend INTERFACE USE_MPV)
    target_link_libraries(mkd PRIVATE mpv_backend)
endif()

