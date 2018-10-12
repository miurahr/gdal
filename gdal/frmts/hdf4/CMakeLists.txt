# HDF4 and HDF4Image driver
add_gdal_driver(TARGET gdal_HDF4 SOURCES
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
target_include_directories(gdal_HDF4 PRIVATE ${HDF4_INCLUDE_DIRS}
                           $<TARGET_PROPERTY:gdal_PDS,SOURCE_DIR>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/hdf-eos>)
if(HDF4_HAS_MAXOPENFILES)
    target_compile_definitions(gdal_HDF4 PRIVATE -DHDF4_HAS_MAXOPENFILES)
endif()
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_HDF4 LIBRARIES ${HDF4_LIBRARIES})

if(GDAL_ENABLE_PLUGIN)
    # When build as plugin, it initialize HDF4Image driver too.
    target_compile_definitions(gdal_HDF4 PRIVATE -DHDF4_PLUGIN)
endif()
