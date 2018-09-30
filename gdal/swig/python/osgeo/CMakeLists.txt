

# SWIG generates wrapper sources
include(GdalSwigBindings)
GDAL_SWIG_BINDINGS(
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

macro(py_ext name source)
    # FIXME: current script builds from generated sources
    add_library(${name} SHARED ${CMAKE_CURRENT_SOURCE_DIR}/../extensions/${source})
    set_target_properties(${name} PROPERTIES
                          PREFIX ""
                          LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/)
    gdal_standard_includes(${name})
    target_include_directories(${name} PRIVATE
                               ${Python_INCLUDE_DIRS}
                               $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                               $<TARGET_PROPERTY:gnm,SOURCE_DIR>
                               )
    if(WIN32 AND NOT CYGWIN)
        set_target_properties(${name} PROPERTIES SUFFIX ".pyd")
        target_compile_definitions(${name} PRIVATE -D__MSVCRT_VERSION__=0x0601)
    endif()
    if(APPLE)
        set_target_properties(${name} PROPERTIES SUFFIX ".so")
    endif()
    target_link_libraries(${name} PRIVATE ${Python_LIBRARIES} $<TARGET_NAME:gdal>)
endmacro()

py_ext(_gdal gdal_wrap.cpp)
py_ext(_gdalconst gdalconst_wrap.c)
py_ext(_gnm gnm_wrap.cpp)
py_ext(_ogr ogr_wrap.cpp)
py_ext(_osr osr_wrap.cpp)
install(TARGETS _gdal _gdalconst _gnm _osr _ogr DESTINATION ${Python_SITEARCH}/osgeo)

if(NumPy_FOUND)
    py_ext(_gdal_array gdal_array_wrap.cpp)
    target_include_directories(_gdal_array PRIVATE ${NumPy_INCLUDE_DIR})
    install(TARGETS _gdal_array DESTINATION ${Python_SITEARCH}/osgeo)
endif()

install(FILES __init__.py gdal.py gdalconst.py gdal_array.py gdalnumeric.py gnm.py ogr.py osr.py
        DESTINATION ${Python_SITELIB}/osgeo)
