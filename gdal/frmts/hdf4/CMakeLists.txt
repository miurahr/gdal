ADD_GDAL_DRIVER(TARGET gdal_HDF4 SOURCES
            hdf-eos/ease.h
            hdf-eos/HdfEosDef.h
            hdf-eos/HDFEOSVersion.h
            hdf-eos/EHapi.c
            hdf-eos/GDapi.c
            hdf-eos/gctp_wrap.c
            hdf-eos/SWapi.c
            hdf4compat.h hdf4dataset.h
            hdf4dataset.cpp  hdf4imagedataset.cpp
            )
GDAL_STANDARD_INCLUDES(gdal_HDF4)
target_include_directories(gdal_HDF4 PRIVATE ${HDF4_INCLUDE_DIR}
                           $<TARGET_PROPERTY:gdal_PDS,SOURCE_DIR>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/hdf-eos>)
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_HDF4 LIBRARIES ${HDF4_LIBRARIES})
