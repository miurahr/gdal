GDAL_DRIVER(TARGET ogr_WALK
            SOURCES ogis_geometry_wkb_struct.h ogrwalk.h
            ogrwalkdatasource.cpp ogrwalkdriver.cpp ogrwalklayer.cpp ogrwalkselectlayer.cpp
            ogrwalktablelayer.cpp ogrwalktool.cpp
            )
gdal_driver_standard_includes(ogr_WALK)
target_include_directories(ogr_WALK PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgeo>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>)
