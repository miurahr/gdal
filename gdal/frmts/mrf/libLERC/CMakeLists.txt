add_library(liblerc OBJECT
            CntZImage.cpp CntZImage.h
            BitMaskV1.cpp BitMaskV1.h BitStufferV1.cpp BitStufferV1.h
            DefinesV1.h
            Image.h TImage.hpp
            )
target_include_directories(liblerc PRIVATE
                           $<TARGET_PROPERTY:cpl,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,BINARY_DIR>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:liblerc>)
set_property(TARGET liblerc PROPERTY POSITION_INDEPENDENT_CODE ON)
