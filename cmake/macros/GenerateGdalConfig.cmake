function(generate_gdal_config)
    # generate gdal-config
    if(NOT DEFINED CMAKE_INSTALL_PREFIX)
        set(GDAL_PREFIX "/usr/local") # default
    else()
        set(GDAL_PREFIX ${CMAKE_INSTALL_PREFIX})
    endif()
    set(CONFIG_CFLAGS "-I${GDAL_PREFIX}/${INSTALL_INCLUDE_DIR}")
    set(CONFIG_DATA "${GDAL_PREFIX}/share/gdal/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}")
    set(CONFIG_LIBS "-L${GDAL_PREFIX}/${INSTALL_LIB_DIR} -l${GDAL_LIB_NAME}")

    # dep-libs
    set(_DEP_LIBS "")
    get_property(_LINK_LIBS
                 TARGET GDAL_LINK_LIBRARY
                 PROPERTY INTERFACE_LINK_LIBRARIES)
    foreach(_lib ${_LINK_LIBS})
        get_filename_component(_lib_name ${_lib} NAME_WE)
            if("${_lib_name}" STREQUAL "")
            else()
                string(REGEX REPLACE "^lib" "" _name ${_lib_name})
                list(APPEND _DEP_LIBS "-l${_name}")
                get_filename_component(_lib_dir ${_lib} PATH)
                if("${_lib_dir}" STREQUAL "")
                else()
                    list(APPEND _DEP_LIBS "-L${_lib_dir}")
                endif()
            endif()
    endforeach()
    list(REMOVE_DUPLICATES _DEP_LIBS )
    string(REPLACE ";" " " CONFIG_DEP_LIBS "${_DEP_LIBS}")

    if(ENABLE_GNM)
        set(CONFIG_GNM_ENABLED "yes")
    else()
        set(CONFIG_GNM_ENABLED "no")
    endif()
    # formats
    string(REPLACE ";" " " CONFIG_FORMATS "${GDAL_FORMATS}")

    # Generate gdal-config
    add_custom_target(gdal_config ALL DEPENDS ${GDAL_ROOT_BINARY_DIR}/apps/gdal-config)
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal-config.in ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/gdal-config @ONLY)
    file(COPY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/gdal-config
            DESTINATION ${GDAL_ROOT_BINARY_DIR}/apps/
            FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

    if(UNIX AND NOT OSX_FRAMEWORK)
        install(PROGRAMS ${GDAL_ROOT_BINARY_DIR}/apps/gdal-config
                DESTINATION bin
                COMPONENT applications)
    endif()
endfunction()
