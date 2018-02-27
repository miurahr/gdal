# Find TEIGHA
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets TEIGHA_FOUND to TRUE
# and following variables are set:
#    TEIGHA_INCLUDE_DIR
#    TEIGHA_LIBRARIES
#
#  Before call here user should set TEIGHA_PLATFORM variable

find_path(TEIGHA_INCLUDE_DIR  OdaCommon.h
          PATHS /opt/teigha /usr/local/teigha/
          PATH_SUFFIXES include
)

set(TEIGHA_DIR )
set(TEIGHA_PLT ${TEIGHA_PLATFORM})

find_library(TEIGHA_LIBRARY
             NAMES TD_Db TD_DbRoot TD_Root TD_Ge TD_Alloc
             PATHS ${TEIGHA_DIR}/bin/${TEIGHA_PLT}
)
