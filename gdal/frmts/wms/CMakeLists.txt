# WMS should not be a plugin -- WFS dependency.
ADD_GDAL_DRIVER(TARGET gdal_WMS SOURCES gdalhttp.cpp        gdalwmsrasterband.cpp         minidriver_iip.cpp  minidriver_tiled_wms.cpp    minidriver_tms.cpp           minidriver_wms.cpp        wmsdriver.cpp       wmsutils.cpp
gdalhttp.h          minidriver.cpp                minidriver_iip.h    minidriver_tiled_wms.h      minidriver_tms.h             minidriver_wms.h          wmsdriver.h
gdalwmscache.cpp    minidriver_arcgis_server.cpp  minidriver_mrf.cpp  minidriver_tileservice.cpp  minidriver_virtualearth.cpp  minidriver_worldwind.cpp  wmsmetadataset.cpp
gdalwmsdataset.cpp  minidriver_arcgis_server.h    minidriver_mrf.h    minidriver_tileservice.h    minidriver_virtualearth.h    minidriver_worldwind.h    wmsmetadataset.h
            BUILTIN
)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_WMS)
target_include_directories(gdal_WMS PRIVATE ${CURL_INCLUDE_DIRS}
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>)
target_compile_definitions(gdal_WMS PRIVATE -DHAVE_CURL)
GDAL_target_link_libraries(TARGET gdal_WMS LIBRARIES ${CURL_LIBRARIES})
