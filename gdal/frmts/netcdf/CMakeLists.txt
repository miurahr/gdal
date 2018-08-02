ADD_GDAL_DRIVER(TARGET gdal_netCDF SOURCES netcdfdataset.h
        gmtdataset.cpp  netcdfdataset.cpp netcdflayer.cpp netcdfwriterconfig.cpp)
gdal_standard_includes(gdal_netCDF)
target_include_directories(gdal_netCDF PRIVATE ${NETCDF_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_netCDF  LIBRARIES ${NETCDF_LIBRARIES})
target_compile_definitions(gdal_netCDF PRIVATE -DNETCDF_HAS_NC4 -DNETCDF_HAS_HDF4
    #-DHAVE_HDF4 -DHAVE_HDF5
)
