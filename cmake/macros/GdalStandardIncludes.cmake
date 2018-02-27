function(GDAL_STANDARD_INCLUDES _TARGET)
     if(NOT GDAL_ROOT_SOURCE_DIR)
          set(GDAL_ROOT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/gdal)
     endif()
     if(NOT GDAL_ROOT_BINARY_DIR)
          set(GDAL_ROOT_BINARY_DIR ${CMAKE_BINARY_DIR}/gdal)
     endif()
     target_include_directories(${_TARGET} PRIVATE
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                                $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                                $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>)
endfunction()