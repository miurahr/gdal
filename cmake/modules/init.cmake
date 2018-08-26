set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/thirdparty
    # GDAL specific helpers
    ${CMAKE_CURRENT_LIST_DIR}/../helpers
    ${CMAKE_MODULE_PATH})

# Backported modules from versions
if(CMAKE_VERSION VERSION_LESS 3.13)
    set(CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/3.13
        ${CMAKE_MODULE_PATH})
endif()
if(CMAKE_VERSION VERSION_LESS 3.12)
    set(CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/3.12
        ${CMAKE_MODULE_PATH})
endif()
if(CMAKE_VERSION VERSION_LESS 3.9)
    set(CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/3.9
        ${CMAKE_MODULE_PATH})
endif()
