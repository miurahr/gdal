
set(KAKDIR ${KDU_DIRECTORY})
GDAL_DRIVER(TARGET gdal_JPIPKAK SOURCES
        jpipkak_headers.h
        jpipkakdataset.h
        jpipkakdataset.cpp
    INCLUDES 
        $(KAKDIR)/coresys/common $(KAKDIR)/apps/compressed_io 
        $(KAKDIR)/apps/jp2 $(KAKDIR)/apps/image $(KAKDIR)/apps/args
        $(KAKDIR)/apps/support $(KAKDIR)/apps/kdu_compress 
        $(KAKDIR)/apps/caching_sources
)