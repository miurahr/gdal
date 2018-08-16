add_library(qhull OBJECT
            geom.c    io.c        mem.c    poly.c     qset.c    rboxlib.c  user.h
            geom.h    io.h        mem.h    poly.h     qset.h    stat.c     usermem.c
            geom2.c   libqhull.c  merge.c  poly2.c    random.c  stat.h     userprintf.c
            global.c  libqhull.h  merge.h  qhull_a.h  random.h  user.c     userprintf_rbox.c
)
include(GdalStandardIncludes)
gdal_standard_includes(qhull)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:qhull>)
iF(MSVC)
    target_compile_definitions(qhull -D_USE_MATH_DEFINES)
endif()