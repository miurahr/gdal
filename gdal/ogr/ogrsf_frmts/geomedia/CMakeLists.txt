GDAL_DRIVER(TARGET ogr_Geomedia
            INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgeo>
            )
