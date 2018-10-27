add_gdal_driver(TARGET ogr_MSSQLSpatial
                SOURCES
                ogrmssqlgeometryparser.cpp
                ogrmssqlgeometryvalidator.cpp
                ogrmssqlgeometrywriter.cpp
                ogrmssqlspatialdatasource.cpp
                ogrmssqlspatialdriver.cpp
                ogrmssqlspatiallayer.cpp
                ogrmssqlspatialselectlayer.cpp
                ogrmssqlspatialtablelayer.cpp)
gdal_standard_includes(ogr_MSSQLSpatial)

