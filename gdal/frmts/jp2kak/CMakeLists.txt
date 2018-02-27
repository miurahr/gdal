set(KAKDIR ${KDU_DIRECTORY})
GDAL_DRIVER(TARGET gdal_JP2KAK SOURCES jp2kakdataset.cpp
        jp2kak_headers.h jp2kakdataset.h subfile_source.h vsil_target.h
    INCLUDES $(KAKDIR)/coresys/common $(KAKDIR)/apps/compressed_io
	         $(KAKDIR)/apps/jp2 $(KAKDIR)/apps/image $(KAKDIR)/apps/args
	         $(KAKDIR)/apps/support $(KAKDIR)/apps/kdu_compress
)