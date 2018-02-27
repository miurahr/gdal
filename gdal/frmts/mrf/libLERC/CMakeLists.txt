add_library(liblerc OBJECT
            CntZImage.cpp CntZImage.h
            BitMaskV1.cpp BitMaskV1.h BitStufferV1.cpp BitStufferV1.h
            DefinesV1.h
            Image.h TImage.hpp
            )
TARGET_INCLUDE_DIRECTORIES(liblerc PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:liblerc>)
