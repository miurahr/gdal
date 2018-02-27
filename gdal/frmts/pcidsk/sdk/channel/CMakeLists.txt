add_library(pcidsk_sdk_channel OBJECT
        cbandinterleavedchannel.cpp  cexternalchannel.h  cpixelinterleavedchannel.cpp  ctiledchannel.h
        cbandinterleavedchannel.h    cpcidskchannel.cpp  cpixelinterleavedchannel.h
        cexternalchannel.cpp         cpcidskchannel.h    ctiledchannel.cpp
        )
target_include_directories(pcidsk_sdk_channel PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pcidsk/sdk/channel>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pcidsk/sdk>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           )
target_sources(gdal PRIVATE $<TARGET_OBJECTS:pcidsk_sdk_channel>)
