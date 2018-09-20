# HDF5, BAG and HDF5Image
ADD_GDAL_DRIVER(TARGET gdal_HDF5
           SOURCES hdf5dataset.h iso19115_srs.h gh5_convenience.h
                   hdf5dataset.cpp hdf5imagedataset.cpp gh5_convenience.cpp
                   iso19115_srs.cpp bagdataset.cpp)
gdal_standard_includes(gdal_HDF5)
# When build as plugin, initialize all drivers from Register_HDF5
if(GDAL_ENABLE_PLUGIN)
    target_compile_definitions(gdal_HDF5 PRIVATE -DHDF5_PLUGIN)
endif()
if(WIN32)
    target_compile_definitions(gdal_HDF5 PRIVATE -DWIN32 -D_HDF5USEDLL_)
endif()
target_include_directories(gdal_HDF5 PRIVATE ${HDF5_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_HDF5 LIBRARIES ${HDF5_LIBRARIES})