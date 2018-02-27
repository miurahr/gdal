# SDE library location may be
#/esri3/users/test/sdehome and it would be set environment variable SDEHOME
set(SDE_DIRECTORY "" CACHE STRING "ESRI C++ SDK directory")

find_path(SDE_INCLUDE_DIR
          NAMES sdetype.h
          PATHS ${SDE_DIRECTORY}/include)
if(SDE_INCLUDE_DIR)
    find_library(SDE_LIBRARY NAMES sde
                 PATHS ${SDE_DIRECTORY}/lib)
endif()
mark_as_advanced(SDE_INCLUDE_DIR SDE_LIBRARY)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SDE
                                  REQUIRED_VARS SDE_LIBRARY SDE_INCLUDE_DIR)
if(SDE_FOUND)
    set(SDE_INCLUDE_DIRS ${SDE_INCLUDE_DIR})
    set(SDE_LIBRARIES ${SDE_LIBRARIES})
endif()
