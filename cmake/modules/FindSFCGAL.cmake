#-- SFCGAL finder
#

find_path(SFCGAL_INCLUDE_DIR SFCGAL/Kernel.h
    HINTS ${SFCGAL_DIR}
    PATH_SUFFIXES include
)

IF(SFCGAL_INCLUDE_DIR)
	IF(EXISTS "${SFCGAL_INCLUDE_DIR}/SFCGAL/version.h")
		FILE(STRINGS "${SFCGAL_INCLUDE_DIR}/SFCGAL/version.h" sfcgal_version_str REGEX "^#define[\t ]+SFCGAL_VERSION[\t ]+\".*\"")
		STRING(REGEX REPLACE "^#define[\t ]+SFCGAL_VERSION[\t ]+\"([^\"]*)\".*" "\\1" SFCGAL_VERSION "${sfcgal_version_str}")
		IF(${SFCGAL_VERSION} MATCHES "[0-9]+\\.[0-9]+\\.[0-9]+")
			STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" SFCGAL_MAJOR_VERSION "${SFCGAL_VERSION}")
			STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+" "\\1" SFCGAL_MINOR_VERSION "${SFCGAL_VERSION}")
			STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" SFCGAL_PATCH_VERSION "${SFCGAL_VERSION}")
		ELSE()
			MESSAGE( WARNING "SFCGAL_VERSION (${SFCGAL_VERSION}) doesn't match *.*.* form" )
		ENDIF()		
		UNSET(sfcgal_version_str)
	ELSE()
		message( WARNING "can't parse SFCGAL version" )
	ENDIF()
ENDIF()

find_library(SFCGAL_LIBRARY_RELEASE NAMES SFCGAL
	HINTS ${SFCGAL_DIR}
	PATH_SUFFIXES lib
)
find_library(SFCGAL_LIBRARY_DEBUG NAMES SFCGALd
	HINTS ${SFCGAL_DIR}
	PATH_SUFFIXES lib
)

include(SelectLibraryConfigurations)
select_library_configurations(SFCGAL)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
	SFCGAL DEFAULT_MSG
    SFCGAL_INCLUDE_DIR SFCGAL_LIBRARY
)
mark_as_advanced(SFCGAL_INCLUDE_DIR SFCGAL_LIBRARY)

if(SFCGAL_FOUND)
	set(SFCGAL_LIBRARIES ${SFCGAL_LIBRARY} )
	set(SFCGAL_INCLUDE_DIRS "${SFCGAL_INCLUDE_DIR}" )
endif()
