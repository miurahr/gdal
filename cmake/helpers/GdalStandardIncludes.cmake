function(GDAL_STANDARD_INCLUDES _TARGET)
     target_include_directories(${_TARGET} PRIVATE
                                $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                                $<TARGET_PROPERTY:alg,SOURCE_DIR>
                                $<TARGET_PROPERTY:gcore,SOURCE_DIR>
                                $<TARGET_PROPERTY:gcore,BINARY_DIR>
                                $<TARGET_PROPERTY:cpl,SOURCE_DIR> # port
                                $<TARGET_PROPERTY:cpl,BINARY_DIR>
                                $<TARGET_PROPERTY:ogr,SOURCE_DIR>
                                $<TARGET_PROPERTY:ogrsf_frmts,SOURCE_DIR> # gdal/ogr/ogrsf_frmts
                                $<TARGET_PROPERTY:gdal_frmts,SOURCE_DIR> # gdal/frmts
                                )
endfunction()