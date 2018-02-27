GDAL_DRIVERS(TARGET gdal_NetCDF SOURCES netcdfdataset.h
        gmtdataset.cpp  netcdfdataset.cpp netcdflayer.cpp netcdfwriterconfig.cpp
    INCLUDES ${NETCDF_INCLUDES}
    LIBRARIES ${NETCDF_LIBRARIES}
    DEFINITIONS  -DNETCDF_HAS_NC4 -DNETCDF_HAS_HDF4
    #-DHAVE_HDF4 -DHAVE_HDF5
)
