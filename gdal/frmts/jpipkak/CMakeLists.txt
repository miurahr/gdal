add_gdal_driver(TARGET gdal_JPIPKAK SOURCES
        jpipkak_headers.h
        jpipkakdataset.h
        jpipkakdataset.cpp)
gdal_standard_includes(gdal_JPIPKAK)
target_include_directories(gdal_JPIPKAK PRIVATE ${KDU_INCULUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_JPIPKAK LIBRARIES ${KDU_LIBRARIES})

# FIXME: mdule find these paths?
#        $(KAKDIR)/coresys/common $(KAKDIR)/apps/compressed_io
#        $(KAKDIR)/apps/jp2 $(KAKDIR)/apps/image $(KAKDIR)/apps/args
#        $(KAKDIR)/apps/support $(KAKDIR)/apps/kdu_compress
#        $(KAKDIR)/apps/caching_sources
