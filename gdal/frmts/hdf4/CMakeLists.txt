ADD_GDAL_DRIVER(TARGET gdal_HDF4Image SOURCES
            hdf-eos/ease.h
            hdf-eos/HdfEosDef.h
            hdf-eos/HDFEOSVersion.h
            hdf-eos/EHapi.c
            hdf-eos/GDapi.c
            hdf-eos/gctp_wrap.c
            hdf-eos/SWapi.c
            hdf4compat.h hdf4dataset.h
            hdf4dataset.cpp  hdf4imagedataset.cpp
            BUILTIN)
GDAL_STANDARD_INCLUDES(gdal_HDF4Image)
target_include_directories(gdal_HDF4Image PRIVATE ${HDF4_INCLUDE_DIRS}
                           $<TARGET_PROPERTY:gdal_PDS,SOURCE_DIR>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/hdf-eos>)
if(HDF4_HAS_MAXOPENFILES)
    target_compile_definitions(gdal_HDF4Image PRIVATE -DHDF4_HAS_MAXOPENFILES)
endif()
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_HDF4Image LIBRARIES ${HDF4_LIBRARIES})
