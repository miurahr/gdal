# - Find pcre
# Find the native PCRE headers and libraries.

find_path(PCRE_INCLUDE_DIR NAMES pcre.h)
find_library(PCRE_LIBRARY NAMES pcre)
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PCRE
                                  FOUND_VAR PCRE_FOUND
                                  REQUIRED_VARS PCRE_INCLUDE_DIR PCRE_LIBRARY)
mark_as_advanced(PCRE_INCLUDE_DIR PCRE_LIBRARY)
if(PCRE_FOUND)
    set(PCRE_LIBRARIES ${PCRE_LIBRARY})
    set(PCRE_INCLUDE_DIRS ${PCRE_INCLUDE_DIR})
    if(NOT TARGET PCRE::PCRE)
        add_library(PCRE::PCRE UNKNOWN IMPORTED)
        set_target_properties(PCRE::PCRE PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES ${PCRE_INCLUDE_DIR}
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION ${PCRE_LIBRARY})
    endif()
endif()
