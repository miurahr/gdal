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
        gdal_standard_includes(gnm)
        target_include_directories(gnm PRIVATE  ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/gnm_frmts)
        target_sources(gdal PRIVATE $<TARGET_OBJECTS:gnm>)
        install(FILES ${LIB_INST_HEADERS} DESTINATION include/gdal)
endif()