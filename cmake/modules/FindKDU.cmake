
set(KDU_DIRECTORY "KDU-DIRECTORY-NOT-FOUND" CACHE STRING "KAKADU library base directory")
set(KDU_VERSION_STRING "" CACHE STRING "KAKADU version")

if(KDU_DIRECTORY)
    find_path(KDU_INCLUDE_DIR kdu_file_io.h
              SUFFIXES /coresys/common
              PATH ${KAKADU_DIRECTORY})
    find_library(KDU_LIBRARY kdu
                 PATH ${KDU_DIRECTORY})
else()
    find_path(KDU_INCLUDE_DIR kdu_file_io.h
              SUFFIXES /coresys/common)
    find_library(KDU_LIBRARY kdu)
endif()

if(KDU_INCLUDE_DIR)
    string(REGEX MATCH "([0-9]+).([0-9]+).([0-9]+)" KDU_VERSION ${KDU_VERSION_STRING})
    if(KDU_VERSION)
        set(KDU_MAJOR_VERSION ${CMAKE_MATCH_1})
        set(KDU_MINOR_VERSION ${CMAKE_MATCH_2})
        set(KDU_PATCH_VERSION ${CMAKE_MATCH_3})
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KDU_FOUND
                                  VERSION_VAR KDU_VERSION_STRING
                                  REQUIRED_VARS KDU_INCLUDE_DIR KDU_LIBRARY)

if(KDU_FOUND)
    set(HAVE_KDU ON CACHE INTERNAL "HAVE_KDU")
    set(KDU_INCLUDE_DIRS KDU_INCLUDE_DIR)
    set(KDU_LIBRARIES KDU_LIBRARY)

else()
    set(HAVE_KDU OFF CACHE INTERNAL "HAVE_KDU")
endif()