# This is common library for other driver.
add_library(libz OBJECT
    crc32.h deflate.h inffast.h inffixed.h inflate.h inftrees.h trees.h zconf.h zlib.h zutil.h
    adler32.c compress.c crc32.c deflate.c gzio.c infback.c inffast.c inflate.c inftrees.c trees.c
    uncompr.c zutil.c)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:libz>)
set_property(TARGET libz PROPERTY POSITION_INDEPENDENT_CODE ON)