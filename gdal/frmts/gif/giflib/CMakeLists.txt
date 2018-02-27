add_library(giflib OBJECT
			dgif_lib.c egif_lib.c gifalloc.c gif_err.c gif_hash.c
			gif_hash.h gif_lib.h gif_lib_private.h
)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:giflib>)
