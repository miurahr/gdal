GDAL_DRIVER(TARGET ogr_AeronavFAA
    SOURCES ogr_aeronavfaa.h ograeronavfaadatasource.cpp ograeronavfaadriver.cpp ograeronavfaalayer.cpp)
    target_include_directories(ogr_AeronavFAA PRIVATE $<TARGET_PROPERTY:ogr_XPlane>)
