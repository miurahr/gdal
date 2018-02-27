if(ENABLE_GNM)
        add_subdirectory(gnm_frmts)

        add_library(gnm OBJECT
                gnm_priv.h
                gnmlayer.cpp
                gnmgenericnetwork.cpp
                gnmgraph.cpp
                gnmnetwork.cpp
                gnmresultlayer.cpp
                gnmrule.cpp
        )
        set(LIB_INST_HEADERS
            gnm.h
            gnm_api.h
            gnmgraph.h
        )
        target_include_directories(gnm PRIVATE
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                                   $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                       )

        target_sources(gnm PRIVATE ${LIB_INST_HEADERS})
        target_sources(gdal PRIVATE $<TARGET_OBJECTS:gnm>)
        install(FILES ${LIB_INST_HEADERS} DESTINATION include/gdal)
endif()