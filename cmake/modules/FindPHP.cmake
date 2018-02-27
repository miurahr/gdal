# - Find PHP
# This module finds if PHP is installed and determines where the include files
# and libraries are.
#
# Note, unlike the FindPHP4 module, this module uses the php-config script to
# determine information about the installed PHP configuration.  For Linux
# distributions, this script is normally installed as part of some php-dev or
# php-devel package. See http://php.net/manual/en/install.pecl.php-config.php
# for php-config documentation.
#
# This code sets the following variables:
#  PHP_CONFIG_DIR             = directory containing PHP configuration files
#  PHP_CONFIG_EXECUTABLE      = full path to the php-config binary
#  PHP_EXECUTABLE             = full path to the php binary
#  PHP_EXTENSIONS_DIR         = directory containing PHP extensions
#  PHP_EXTENSIONS_INCLUDE_DIR = directory containing PHP extension headers
#  PHP_INCLUDE_DIRS           = include directives for PHP development
#  PHP_VERSION_NUMBER         = PHP version number in PHP's "vernum" format eg 50303
#  PHP_VERSION_MAJOR          = PHP major version number eg 5
#  PHP_VERSION_MINOR          = PHP minor version number eg 3
#  PHP_VERSION_PATCH          = PHP patch version number eg 3
#  PHP_VERSION_STRING         = PHP version string eg 5.3.3-1ubuntu9.3
#  PHP_FOUND                  = set to TRUE if all of the above has been found.
#

#=============================================================================
# Copyright 2011-2012 Paul Colby
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file LICENSE.md for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

FIND_PROGRAM(PHP_CONFIG_EXECUTABLE NAMES php-config5 php-config4 php-config)

if (PHP_CONFIG_EXECUTABLE)
  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --configure-options
          COMMAND sed -ne "s/^.*--with-config-file-scan-dir=\\([^ ]*\\).*/\\1/p"
          OUTPUT_VARIABLE PHP_CONFIG_DIR
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --php-binary
          OUTPUT_VARIABLE PHP_EXECUTABLE
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --extension-dir
          OUTPUT_VARIABLE PHP_EXTENSIONS_DIR
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --include-dir
          OUTPUT_VARIABLE PHP_EXTENSIONS_INCLUDE_DIR
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --includes
          OUTPUT_STRIP_TRAILING_WHITESPACE
          COMMAND sed "s/-I//g"
          OUTPUT_VARIABLE PHP_INCLUDE_DIRS_STRING
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --vernum
          OUTPUT_VARIABLE PHP_VERSION_NUMBER
          OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --vernum
          OUTPUT_STRIP_TRAILING_WHITESPACE
          COMMAND sed -ne "s/....$//p"
          OUTPUT_VARIABLE PHP_VERSION_MAJOR
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --vernum
          OUTPUT_STRIP_TRAILING_WHITESPACE
          COMMAND sed -ne "s/..$//p"
          COMMAND sed -ne "s/^.0\\?//p"
          OUTPUT_VARIABLE PHP_VERSION_MINOR
  )

  execute_process(
          COMMAND
          ${PHP_CONFIG_EXECUTABLE} --vernum
          OUTPUT_STRIP_TRAILING_WHITESPACE
          COMMAND sed -ne "s/^...0\	\?//p"
          OUTPUT_VARIABLE PHP_VERSION_PATCH
  )

  execute_process(
    COMMAND
    ${PHP_CONFIG_EXECUTABLE} --version
    OUTPUT_VARIABLE PHP_VERSION_STRING
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  string(REPLACE " " ";" PHP_INCLUDE_DIRS ${PHP_INCLUDE_DIRS_STRING})
endif (PHP_CONFIG_EXECUTABLE)

MARK_AS_ADVANCED(
PHP_CONFIG_DIR
PHP_CONFIG_EXECUTABLE
PHP_EXECUTABLE
PHP_EXTENSIONS_DIR
PHP_EXTENSIONS_INCLUDE_DIR
PHP_INCLUDE_DIRS
PHP_VERSION_MAJOR
PHP_VERSION_MINOR
PHP_VERSION_PATCH
PHP_VERSION_STRING
)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(
php
DEFAULT_MSG
PHP_VERSION_STRING
PHP_CONFIG_DIR
PHP_CONFIG_EXECUTABLE
PHP_EXECUTABLE
PHP_EXTENSIONS_DIR
PHP_EXTENSIONS_INCLUDE_DIR
PHP_INCLUDE_DIRS
PHP_VERSION_NUMBER
PHP_VERSION_MAJOR
PHP_VERSION_MINOR
PHP_VERSION_PATCH
PHP_VERSION_STRING
)

if(APPLE)
# this is a hack for now
  string(APPEND CMAKE_SHARED_MODULE_CREATE_C_FLAGS
   " -Wl,-flat_namespace")
  foreach(symbol
    __efree
    __emalloc
    __estrdup
    __object_init_ex
    __zend_get_parameters_array_ex
    __zend_list_find
    __zval_copy_ctor
    _add_property_zval_ex
    _alloc_globals
    _compiler_globals
    _convert_to_double
    _convert_to_long
    _zend_error
    _zend_hash_find
    _zend_register_internal_class_ex
    _zend_register_list_destructors_ex
    _zend_register_resource
    _zend_rsrc_list_get_rsrc_type
    _zend_wrong_param_count
    _zval_used_for_init
    )
    string(APPEND CMAKE_SHARED_MODULE_CREATE_C_FLAGS
      ",-U,${symbol}")
  endforeach()
endif()
