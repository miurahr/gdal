GDAL_DRIVER(TARGET gdal_HDF5
           SOURCES hdf5dataset.h iso19115_srs.h gh5_convenience.h
                   hdf5dataset.cpp hdf5imagedataset.cpp gh5_convenience.cpp
                   iso19115_srs.cpp bagdataset.cpp
       INCLUDES ${HDF5_INCLUDE_DIRS} LIBRARIES ${HDF5_LIBRARIES})