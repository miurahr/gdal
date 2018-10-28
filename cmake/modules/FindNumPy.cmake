## (re)Distributed under the OSI-approved 3-Clause BSD License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindNumPy
# --------
#
# Copyright (c) 2018 Hiroshi Miura


if(NOT Python_FOUND)
    if(NumPy_FIND_QUIETLY)
        find_package(Python QUIET)
    else()
        find_package(Python)
        set(__numpy_out 1)
    endif()
endif()

if (Python_EXECUTABLE)
  # Find out the include path
  execute_process(
    COMMAND "${Python_EXECUTABLE}" -c
            "from __future__ import print_function\ntry: import numpy; print(numpy.get_include(), end='')\nexcept:pass\n"
            OUTPUT_VARIABLE __numpy_path)
  # And the version
  execute_process(
    COMMAND "${Python_EXECUTABLE}" -c
            "from __future__ import print_function\ntry: import numpy; print(numpy.__version__, end='')\nexcept:pass\n"
    OUTPUT_VARIABLE NumPy_VERSION)
elseif(__numpy_out)
  message(STATUS "Python executable not found.")
endif()

find_path(NumPy_INCLUDE_DIR numpy/arrayobject.h
  HINTS "${__numpy_path}" "${Python_INCLUDE_PATH}" NO_DEFAULT_PATH)

if(NumPy_INCLUDE_DIR)
  set(NumPy_FOUND 1 CACHE INTERNAL "Python numpy found")
endif()

string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" _VER_CHECK "${NumPy_VERSION}")
if("${_VER_CHECK}" STREQUAL "")
  message(FATAL_ERROR
          "Requested version and include path from NumPy, got instead:\n${NUMPY_VERSION}\n")
  return()
endif()

# Get the major and minor version numbers
string(REGEX REPLACE "\\." ";" _NUMPY_VERSION_LIST ${NumPy_VERSION})
list(GET _NUMPY_VERSION_LIST 0 NUMPY_VERSION_MAJOR)
list(GET _NUMPY_VERSION_LIST 1 NUMPY_VERSION_MINOR)
list(GET _NUMPY_VERSION_LIST 2 NUMPY_VERSION_PATCH)
string(REGEX MATCH "[0-9]*" NUMPY_VERSION_PATCH ${NUMPY_VERSION_PATCH})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NumPy REQUIRED_VARS NumPy_INCLUDE_DIR
                                        VERSION_VAR NumPy_VERSION)

if(NumPy_FOUND)
    set(NumPy_INCLUDE_DIRS ${NumPy_INCLUDE_DIR})
endif()