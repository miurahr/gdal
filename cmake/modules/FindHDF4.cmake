#
# To be used by projects that make use of CMakeified hdf-4.2
#

#[=======================================================================[.rst:
FindHDF4
---------

Find the HDF4 includes and get all installed hdf4 library settings

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
  (Not yet implemented)

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

# seed the initial lists of libraries to find with items we know we need
set( HDF4_C_LIBRARY_NAMES_INIT hdf )
set( HDF4_F90_LIBRARY_NAMES_INIT hdf_f90cstub ${HDF4_C_LIBRARY_NAMES_INIT} )
set( HDF4_FORTRAN_LIBRARY_NAMES_INIT df_fortran ${HDF4_F90_LIBRARY_NAMES_INIT} )
set( HDF4_MFHDF_LIBRARY_NAMES_INIT mfhdf ${HDF4_C_LIBRARY_NAMES_INIT})
set( HDF4_XDR_LIBRARY_NAMES_INIT xdr ${HDF4_MFHDF_LIBRARY_NAMES_INIT})
set( HDF4_FORTRAN_MF_90_LIBRARY_NAMES_INIT mfhdf_f90cstub ${HDF4_FORTRAN_LIBRARY_NAMES_INIT} )
set( HDF4_FORTRAN_MF_LIBRARY_NAMES_INIT mfhdf_fortran ${HDF4_FORTRAN_MF_90_LIBRARY_NAMES_INIT} )
set( HDF4_C_LIB ${HDF4_XDR_LIBRARY_NAMES_INIT})

# Hard-coded guesses should still go in PATHS. This ensures that the user
# environment can always override hard guesses.
set(_HDF4_PATHS
    /usr/lib/hdf4
    /usr/share/hdf4
    /usr/local/hdf4
    /usr/local/hdf4/share
)

find_path(HDF4_INCLUDE_DIR hdf.h
    PATHS ${_HDF4_PATHS}
    PATH_SUFFIXES
        include
        Include
        hdf
        hdf4
)

if(HDF4_INCLUDE_DIR)
    if(NOT HDF_LIBRARY)
        foreach(LIB ${HDF4_C_LIB})
            if(UNIX AND HDF4_USE_STATIC_LIBRARIES)
                # According to bug 1643 on the CMake bug tracker, this is the
                # preferred method for searching for a static library.
                # See http://www.cmake.org/Bug/view.php?id=1643.  We search
                # first for the full static library name, but fall back to a
                # generic search on the name if the static search fails.
                set( THIS_LIBRARY_SEARCH_DEBUG lib${LIB}d.a ${LIB}d )
                set( THIS_LIBRARY_SEARCH_RELEASE lib${LIB}.a ${LIB} )
            else()
                set( THIS_LIBRARY_SEARCH_DEBUG ${LIB}d )
                set( THIS_LIBRARY_SEARCH_RELEASE ${LIB} )
            endif()
            find_library(_HDF4_${LIB}_LIBRARY_DEBUG
                NAMES ${THIS_LIBRARY_SEARCH_DEBUG}
                HINTS ${HDF4_${LANGUAGE}_LIBRARY_DIRS}
                PATH_SUFFIXES lib Lib )
            find_library(_HDF4_${LIB}_LIBRARY_RELEASE
                NAMES ${THIS_LIBRARY_SEARCH_RELEASE}
                HINTS ${HDF4_${LANGUAGE}_LIBRARY_DIRS}
                PATH_SUFFIXES lib Lib )
            select_library_configurations( HDF4_${LIB} )
            if(HDF4_${LIB}_LIBRARY)
                list(APPEND HDF4_LIBRARY ${HDF4_${LIB}_LIBRARY})
            endif()
        endforeach()
    endif()
endif()
mark_as_advanced(HDF4_INCLUDE_DIR HDF4_LIBRARY)

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

find_package_handle_standard_args(HDF4
                                  FOUND_VAR HDF4_FOUND
                                  REQUIRED_VARS HDF4_LIBRARY HDF4_INCLUDE_DIR
                                  VERSION_VAR HDF4_VERSION
                                  )

# set output variables
IF(HDF4_FOUND)
  set(HDF4_LIBRARIES ${HDF4_LIBRARY})
  set(HDF4_INCLUDE_DIRS ${HDF4_INCLUDE_DIR})
ENDIF()

