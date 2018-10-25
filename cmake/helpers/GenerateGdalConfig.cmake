function(_split_library_to_cflags _lib _result)
    if(_lib)
        set(RESULT)
        get_filename_component(_lib_name ${_lib} NAME_WE)
        if(_lib_name STREQUAL "")
        else()
            string(REGEX REPLACE "^lib" "" _lib_name ${_lib_name})
            get_filename_component(_lib_dir ${_lib} PATH)
            if("${_lib_dir}" STREQUAL "")
                set(RESULT "-l${_lib_name}")
            elseif("${_lib_dir}" STREQUAL "/usr/lib")
                set(RESULT "-l${_lib_name}")
            else()
                set(RESULT "-L${_lib_dir}")
                list(APPEND RESULT "-l${_lib_name}")
            endif()
        endif()
        set(${_result} "${RESULT}" PARENT_SCOPE)
    endif()
endfunction()

function(generate_gdal_config)
    # generate gdal-config
    if(NOT DEFINED CMAKE_INSTALL_PREFIX)
        set(GDAL_PREFIX "/usr/local") # default
    else()
        set(GDAL_PREFIX ${CMAKE_INSTALL_PREFIX})
    endif()
    set(CONFIG_CFLAGS "-I${GDAL_PREFIX}/include")
    set(CONFIG_DATA "${GDAL_PREFIX}/share/gdal/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}")
    set(CONFIG_LIBS "-L${GDAL_PREFIX}/${INSTALL_LIB_DIR} -lgdal")

    # dep-libs
    set(_DEP_LIBS "")
    get_property(_LIBS TARGET GDAL_LINK_LIBRARY PROPERTY INTERFACE_LINK_LIBRARIES)
    list(REMOVE_DUPLICATES _LIBS)
    foreach(_lib IN LISTS _LIBS)
        if(TARGET ${_lib})
           get_property(_res TARGET ${_lib} PROPERTY INTERFACE_LINK_LIBRARIES SET)
           if(NOT _res)
               get_property(_imp TARGET ${_lib} PROPERTY IMPORTED_LOCATION)
               _split_library_to_cflags("${_imp}" _res)
               list(APPEND _DEP_LIBS "${_res}")
           endif()
        else()
            _split_library_to_cflags("${_lib}" _res)
            if(_res)
                list(APPEND _DEP_LIBS "${_res}")
            endif()
        endif()
    endforeach()
    string(REPLACE ";" " " CONFIG_DEP_LIBS "${_DEP_LIBS}")

    if(ENABLE_GNM)
        set(CONFIG_GNM_ENABLED "yes")
    else()
        set(CONFIG_GNM_ENABLED "no")
    endif()
    # formats
    get_property(_GDAL_FORMATS GLOBAL PROPERTY GDAL_FORMATS)
    get_property(_OGR_FORMATS GLOBAL PROPERTY OGR_FORMATS)
    string(REPLACE ";" " " CONFIG_FORMATS "${_GDAL_FORMATS} ${_OGR_FORMATS}")

    # Generate gdal-config
    add_custom_target(gdal_config ALL DEPENDS ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config)
    file(READ  ${GDAL_CMAKE_TEMPLATE_PATH}/gdal-config.in GDAL_CONFIG_CONTENT)
    string(CONFIGURE "${GDAL_CONFIG_CONTENT}" GDAL_CONFIG_CONTENT @ONLY)
    file(GENERATE OUTPUT
         ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config
         CONTENT "${GDAL_CONFIG_CONTENT}")

    if(UNIX AND NOT MACOSX_FRAMEWORK)
        install(PROGRAMS ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config
                DESTINATION bin
                PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                COMPONENT applications)
    endif()
endfunction()
