# Distributed under the GDAL/OGR MIT/X style License.  See accompanying
# file gdal/LICENSE.TXT.

#[=======================================================================[.rst:
GenerateGdalConfig macro
------------------------


#]=======================================================================]

include(GenerateConfig)

macro(generate_gdal_config _target _link _template _output)
    set(CONFIG_DATA "${GDAL_PREFIX}/share/gdal/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}")
    if(ENABLE_GNM)
        set(CONFIG_GNM_ENABLED "yes")
    else()
        set(CONFIG_GNM_ENABLED "no")
    endif()
    get_property(_GDAL_FORMATS GLOBAL PROPERTY GDAL_FORMATS)
    get_property(_OGR_FORMATS GLOBAL PROPERTY OGR_FORMATS)
    string(REPLACE ";" " " CONFIG_FORMATS "${_GDAL_FORMATS} ${_OGR_FORMATS}")
    generate_config(${_target} ${_link} ${_template} ${_output})
endmacro()
