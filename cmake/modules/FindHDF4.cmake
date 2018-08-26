#
# To be used by projects that make use of CMakeified hdf-4.2
#

#[=======================================================================[.rst:
FindHDF4
---------

Find the HDF4 includes and get all installed hdf4 library settings

Component supported:  XDR FORTRAN

The following vars are set if hdf4 is found.

.. variable:: HDF4_FOUND

  True if found, otherwise all other vars are undefined

.. variable:: HDF4_INCLUDE_DIR

  The include dir for main *.h files

.. variable:: HDF4_FORTRAN_INCLUDE_DIR

  The include dir for fortran modules and headers
  (Not yet implemented)

.. variable:: HDF4_VERSION_STRING

  full version (e.g. 4.2.0)

.. variable:: HDF4_VERSION_MAJOR

  major part of version (e.g. 4)

.. variable:: HDF4_VERSION_MINOR

  minor part (e.g. 2)

The following boolean vars will be defined

.. variable:: HDF4_ENABLE_PARALLEL

  1 if HDF4 parallel supported
  (Not yet implemented)

.. variable:: HDF4_BUILD_FORTRAN

  1 if HDF4 was compiled with fortran on

.. variable:: HDF4_BUILD_CPP_LIB

  1 if HDF4 was compiled with cpp on
  (Not yet implemented)

.. variable:: HDF4_BUILD_TOOLS

  1 if HDF4 was compiled with tools on
  (Not yet implemented)

Target names that are valid (depending on enabled options)
will be the following(Not yet implemented)

hdf              : HDF4 C library
hdf_f90cstub     : used by Fortran to C interface
hdf_fortran      : Fortran HDF4 library
mfhdf            : HDF4 multi-file C interface library
xdr              : RPC library
mfhdf_f90cstub   : used by Fortran to C interface to multi-file library
mfhdf_fortran    : Fortran multi-file library

#
#]=======================================================================]
#


include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

# Hard-coded guesses should still go in PATHS. This ensures that the user
# environment can always override hard guesses.
set(HDF4_PATHS
    /usr/lib/hdf4
    /usr/share/hdf4
    /usr/local/hdf4
    /usr/local/hdf4/share
)

find_path(HDF4_INCLUDE_DIR hdf.h
    PATHS ${HDF4_PATHS}
    PATH_SUFFIXES
        include
        Include
        hdf
        hdf4
)

function(find_hdf4_lib)
    set(_options)
    set(_oneValueArgs TARGET)
    set(_multiValueArgs NAMES HINTS)
    cmake_parse_arguments(_LIB "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    set(HDF4_${_LIB_TARGET}_LIBRARY)
    foreach(tgt IN ITEMS ${_LIB_NAMES})
        find_library(HDF4_${tgt}_LIBRARY_DEBUG
                     NAMES ${tgt}d
                     HINTS ${_LIB_HINTS}
                     )
        find_library(HDF4_${tgt}_LIBRARY_RELEASE
                     NAMES ${tgt}
                     HINTS ${_LIB_HINSTS}
                     )
        select_library_configurations(HDF4_${tgt})
        list(APPEND HDF4_${_LIB_TARGET}_LIBRARY ${HDF4_${tgt}_LIBRARY})
        mark_as_advanced(HDF4_${tgt}_LIBRARY HDF4_${tgt}_LIBRARY_RELEASE HDF4_${tgt}_LIBRARY_DEBUG )
    endforeach()
    set(HDF4_${_LIB_TARGET}_LIBRARY ${HDF4_${_LIB_TARGET}_LIBRARY} PARENT_SCOPE)
endfunction()

if(HDF4_INCLUDE_DIR AND NOT HDF4_LIBRARY)
    set(HDF4_LIBRARY)
    # Debian supplies the HDF4 library which does not conflict with NetCDF.
    # Test for Debian flavor first. Hint: install the libhdf4-alt-dev package.
    find_hdf4_lib(TARGET C
                  NAMES dfalt mfhdfalt
                  HINTS ${HDF4_PATHS}/lib)
    if(HDF4_C_LIBRARY)
        set(HDF4_LIBRARY ${HDF4_C_LIBRARY})
    else()
        # next looking for standard names.
        find_hdf4_lib(TARGET C
                  NAMES df mfhdf
                  HINTS ${HDF4_PATHS}/lib)
        if(HDF4_C_LIBRARY)
            set(HDF4_LIBRARY ${HDF4_C_LIBRARY})
        else()
            find_hdf4_lib(TARGET C
                          NAMES hdf4
                          HINTS ${HDF4_PATHS}/lib)
            set(HDF4_LIBRARY ${HDF4_C_LIBRARY})
        endif()
    endif()
    list (FIND HDF4_FIND_COMPONENTS "XDR" _nextcomp)
    if (_nextcomp GREATER -1)
        set(_HDF4_XDR 1)
    endif()
   if (_HDF4_XDR)
        find_hdf4_lib(TARGET XDR
                      NAMES xdr
                      HINTS ${HDF4_PATHS}/lib)
        list(APPEND HDF4_LIBRARY ${HDF4_XDR_LIBRARY})
    endif()
    unset(_HDF4_XDR)
endif()
mark_as_advanced(HDF4_INCLUDE_DIR HDF4_C_LIBRARY HDF4_XDR_LIBRARY HDF4_LIBRARY)

if(HDF4_INCLUDE_DIR AND EXISTS "${HDF4_INCLUDE_DIR}/hfile.h")
    file(STRINGS "${HDF4_INCLUDE_DIR}/hfile.h" hdf4_version_string
         REGEX "^#define[\t ]+LIBVER.*")
    string(REGEX MATCH "LIBVER_MAJOR[ \t]+([0-9]+)" "${hdf4_version_str}" HDF4_VERSION_MAJOR "${hdf4_version_string}")
    string(REGEX MATCH "LIBVER_MINOR[ \t]+([0-9]+)" "${hdf4_version_str}" HDF4_VERSION_MINOR "${hdf4_version_string}")
    string(REGEX MATCH "LIBVER_RELEASE[ \t]+([0-9]+)" "${hdf4_version_str}" HDF4_VERSION_RELEASE "${hdf4_version_string}")
    string(REGEX MATCH "LIBVER_SUBRELEASE[ \t]+([0-9A-Za-z]+)" "${hdf4_version_str}" HDF4_VERSION_SUBRELEASE "${hdf4_version_string}")
    unset(hdf4_version_string)
    if(HDF4_VERSION_SUBRELEASE STREQUAL "")
        set(HDF4_VERSION_STRING "${HDF4_VERSION_MAJOR}.${HDF4_VERSION_MINOR}.${HDF4_VERSION_RELEASE}_${HDF4_VERSION_SUBRELEASE}")
    else()
        set(HDF4_VERSION_STRING "${HDF4_VERSION_MAJOR}.${HDF4_VERSION_MINOR}.${HDF4_VERSION_RELEASE}")
    endif()
endif()

if(HDF4_INCLUDE_DIR AND HDF4_LIBRARY)
    list (FIND HDF4_FIND_COMPONENTS "FORTRAN" _nextcomp)
    if (_nextcomp GREATER -1)
        find_path(HDF4_FORTRAN_INCLUDE_DIR hdf.f90
            PATHS ${HDF4_PATHS}
            PATH_SUFFIXES
                include
                Include
                hdf
                hdf4
        )
        if(HDF4_FORTRAN_INCLUDE_DIR)
            find_hdf4_lib(TARGET FORTRAN
                          NAMES df_fortran
                          HINTS ${HDF4_PATHS}/lib)
            find_hdf4_lib(TARGET FORTRAN_MF
                          NAMES mfhdf_fortran
                          HINTS ${HDF4_PATHS}/lib)
            if(HDF4_FORTRAN_LIBRARY AND HDF4_FORTRAN_MF_LIBRARY)
                list(APPEND HDF4_FORTRAN_LIBRARY ${HDF4_FORTRAN_MF_LIBRARY})
                list(APPEND HDF4_LIBRARY ${HDF4_FORTRAN_LIBRARY})
            else()
                set(HDF4_FORTRAN_LIBRARY HDF4_FORTRAN_LIBRARY-NOTFOUND)
            endif()

            find_hdf4_lib(TARGET F90
                          NAMES hdf_f90cstub
                          HINTS ${HDF4_PATHS}/lib)
            find_hdf4_lib(TARGET FORTRAN_MF_90
                          NAMES mfhdf_f90cstub
                          HINTS ${HDF4_PATHS}/lib)
            if(HDF4_F90_LIBRARY AND HDF4_FORTRAN_MF_90_LIBRARY)
                list(APPEND HDF4_F90_LIBRARY ${HDF4_FORTRAN_MF_90_LIBRARY})
                list(APPEND HDF4_LIBRARY ${HDF4_F90_LIBRARY})
            endif()
            unset(HDF4_FORTRAN_MF_90_LIBRARY)

            if(HDF4_F90_LIBRARY AND HDF4_FORTRAN_LIBRARY)
                list(APPEND HDF4_FORTRAN_LIBRARY ${HDF4_F90_LIBRARY})
            endif()
            unset(HDF4_F90_LIBRARY)
        endif()
    endif()
    mark_as_advanced(HDF4_FORTRAN_INCLUDE_DIR HDF4_FORTRAN_LIBRARY )
endif()

find_package_handle_standard_args(HDF4
                                  FOUND_VAR HDF4_FOUND
                                  REQUIRED_VARS HDF4_LIBRARY HDF4_INCLUDE_DIR
                                  VERSION_VAR HDF4_VERSION
                                  HANDLE_COMPONENTS
                                  )

# set output variables
IF(HDF4_FOUND)
    set(HDF4_LIBRARIES ${HDF4_LIBRARY})
    set(HDF4_INCLUDE_DIRS ${HDF4_INCLUDE_DIR})
    if(NOT TARGET HDF4::HDF4)
    endif()
    if(HDF4_XDR_LIBRAY AND NOT TARGET HDF4::XDR)
    endif()
    if(HDF4_FORTRAN_FOUND)
        set(HDF4_FORTRAN_LIBRARIES ${HDF4_FORTRAN_LIBRARY})
        set(HDF4_FORTRAN_INCLUDE_DIRS ${HDF4_FORTRAN_INCLUDE_DIR})
        if(NOT TARGET HDF4::FORTRAN)
        endif()
    endif()
ENDIF()
