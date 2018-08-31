add_gdal_driver(TARGET gdal_JP2KAK SOURCES jp2kakdataset.cpp
        jp2kak_headers.h jp2kakdataset.h subfile_source.h vsil_target.h)
target_include_directories(gdal_JP2KAK PRIVATE ${KDU_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_JP2KAK LIBRARIES ${KDU_LIBRARIES})

# FIXME: these includes paths found?
# $(KAKDIR)/coresys/common $(KAKDIR)/apps/compressed_io
#	         $(KAKDIR)/apps/jp2 $(KAKDIR)/apps/image $(KAKDIR)/apps/args
#	         $(KAKDIR)/apps/support $(KAKDIR)/apps/kdu_compress
