
# There are netCDF, GMT drivers.
# When PLUGIN specifying NETCDF_PLUGIN then automatically
# register GMT from netCDF.
ADD_GDAL_DRIVER(TARGET gdal_netCDF SOURCES netcdfdataset.h
                gmtdataset.cpp  netcdfdataset.cpp
                netcdflayer.cpp netcdfwriterconfig.cpp)

IS_PLUGIN(RES gdal_netCDF)
if(RES)
    target_compile_definitions(gdal_netCDF PRIVATE -DNETCDF_PLUGIN)
endif()

gdal_standard_includes(gdal_netCDF)
target_include_directories(gdal_netCDF PRIVATE ${NETCDF_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_netCDF LIBRARIES NETCDF::netCDF)
if(NETCDF_HAS_NC4)
    target_compile_definitions(gdal_netCDF PRIVATE -DNETCDF_HAS_NC4)
endif()
if(NETCDF_HAS_HDF4)
    target_compile_definitions(gdal_netCDF PRIVATE -DNETCDF_HAS_HDF4)
endif()
if(HAVE_USERFAULTFD_H AND NETCDF_MEM)
    target_compile_definitions(gdal_netCDF PRIVATE -DENABLE_UFFD)
endif()
if(HAVE_HDF4)
    target_compile_definitions(gdal_netCDF PRIVATE -DHAVE_HDF4)
endif()
if(HAVE_HDF5)
    target_compile_definitions(gdal_netCDF PRIVATE -DHAVE_HDF5)
endif()
