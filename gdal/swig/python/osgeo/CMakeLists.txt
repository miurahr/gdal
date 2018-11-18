

# SWIG generates wrapper sources
include(GdalSwigBindings)
gdal_swig_bindings(
        BINDING python
        ARGS -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}
        OUTPUT
            ${CMAKE_CURRENT_BINARY_DIR}/gdal.py
            ${CMAKE_CURRENT_BINARY_DIR}/gdalconst.py
            ${CMAKE_CURRENT_BINARY_DIR}/gdalnumeric.py
            ${CMAKE_CURRENT_BINARY_DIR}/gnm.py
            ${CMAKE_CURRENT_BINARY_DIR}/ogr.py
            ${CMAKE_CURRENT_BINARY_DIR}/osr.py
            ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdal_wrap.cpp
            ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdalconst_wrap.c
            ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gnm_wrap.cpp
            ${CMAKE_CURRENT_BINARY_DIR}/../extensions/ogr_wrap.cpp
            ${CMAKE_CURRENT_BINARY_DIR}/../extensions/osr_wrap.cpp
)

# gdal_array_wrap.cpp when NumPy exist
if(NumPy_FOUND)
    set(ARRAY_INPUT  ${CMAKE_SOURCE_DIR}/gdal/swig/include/gdal_array.i )
    set(ARRAY_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdal_array_wrap.cpp )
    add_custom_command(
        OUTPUT  ${ARRAY_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE}
                -Wall  -I${CMAKE_SOURCE_DIR}/gdal/swig/include
                -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs
                -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}
        ${SWIG_DEFINES} -I${CMAKE_SOURCE_DIR}/gdal -c++ -python -o ${ARRAY_OUTPUT} ${ARRAY_INPUT}
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${ARRAY_INPUT}
                ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/typemaps_python.i
    )

    # generate wrapper sources
    add_custom_target(pygen
                      DEPENDS
                      ${CMAKE_CURRENT_BINARY_DIR}/gdal.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gdal_array.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gdalconst.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gdalnumeric.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gnm.py
                      ${CMAKE_CURRENT_BINARY_DIR}/ogr.py
                      ${CMAKE_CURRENT_BINARY_DIR}/osr.py
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdal_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdal_array_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdalconst_wrap.c
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gnm_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/ogr_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/osr_wrap.cpp
                      )
else()
    add_custom_target(pygen
                      DEPENDS
                      ${CMAKE_CURRENT_BINARY_DIR}/gdal.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gdalconst.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gdalnumeric.py
                      ${CMAKE_CURRENT_BINARY_DIR}/gnm.py
                      ${CMAKE_CURRENT_BINARY_DIR}/ogr.py
                      ${CMAKE_CURRENT_BINARY_DIR}/osr.py
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdal_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gdalconst_wrap.c
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/gnm_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/ogr_wrap.cpp
                      ${CMAKE_CURRENT_BINARY_DIR}/../extensions/osr_wrap.cpp
                      )
endif()

