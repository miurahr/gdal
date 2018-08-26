CMake build system internals for developers
===========================================

CMake is a cross platform tool to beherate build script for
the platform, aka build tool for build system.

Modern CMake
------------

"Modern CMake" style is introduced in CMake3.x version.
In old cmake (2.8.x), definitions are similar to GNU Makefile.
That means sub directories scripts inherit parent definitions.
It is difficult to manage in large project about implicit definitions.

Other than previous cmake versions, modern cmake style controls scope.

Here is a modern cmake guide.

* https://rix0r.nl/blog/2015/08/13/cmake-guide/

* https://cliutils.gitlab.io/modern-cmake/

* https://unclejimbo.github.io/2018/06/08/Modern-CMake-for-Library-Developers/

Directory structure
-------------------

```
<root>
 - cmake:   cmake modules and helper scripts
   - helpers:  helpers for gdal compilation
   - init:  inital cmake cache configuration examples and toolschain files for cross compilation
   - modules:  generic cmake modules to find dependency libraries
   - templates: template source files to generate when configure
 - autotest: test suites
 - gdal: source files
   - scripts
     - vagrant
```

Build configuration files
--------------------------

There are `CMakeLists.txt` configuration scripts in each directories.
It has all configuration for compilation and link for the directory, with small exception(described later).


Logical hierarchy for cmake
----------------------------

CMake has a logical hierarchy constucted with `add_subdirectory(sub directory path)` function.
Here is a logical hierarchy diagram which is different with phisical one.

```
<root>
  - autotest
    - cpp
  - gdal
    - alg
    - gnm
      - gnm_frmts
        - file
        - db
    - apps
    - doc
    - data
    - fuzzers
    - gcore
      - mdreader
    - port
    - ogr
    - swig
      - perl
      - php
      - python
      - java
      - csharp
    - frmts
      - aaigrid
      - ...
      - xyz
      - zmap
    - ogr/ogrsf_frmts
      - aeronavfaa
      - ...
      - xplane
    - alg/internal_libqhull
    - frmts/zlib
    - frmts/pcidsk/sdk
    - ogr/ogrsf_frmts/geojson/libjson
    - ogr/ogrsf_frmts/cad/libopencad
    - frmts/gtiff/libtiff
    - frmts/gtiff/libgeotiff
    - frmts/jpeg/libjpeg
    - frmts/gif/giflib
    - frmts/png/libpng
    - frmts/pcraster/libcsf
    - frmts/mrf/libLERC
    - third_party/LercLib
```

As you know, ogr and ogr/ogrsf_frmts are not parent-child relation but brother node in configuration.
Also all internal 3rd party libraries are handled from gdal root, which means these are logically separeted with
parent project such as geotiff.

Configuration parameters
-------------------------

You can configure build process with  parameters you added to `cmake` command.
Typical usage is as follows;

```
$ cd gdal_project_directory
$ mkdir cmake-build-gcc4.8-debug
$ cd cmake-build-gcc4.8-debug
$ cmake .. -G Ninja -DENABLE_GNM -DGDAL_ENABLE_FRMTS_PDF=ON
$ cmake --build .
$ cmake --build . --target quicktest
```

There are several good example in `gdal/scripts/vagrant` directory.
For example, `gdal-clang.sh` is a build script with CLang and configured to generate gdal plugins for drivers.

```
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=clang++-3.9 \
  -DCMAKE_C_COMPILER=clang-3.9 \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DSWIG_PYTHON=ON \
  -DSWIG_PERL=ON \
  -DSWIG_JAVA=ON \
  -DSWIG_CSHARP=ON \
  -DGDAL_ENABLE_PLUGIN=ON \
  -DGDAL_ENABLE_FRMT_EPSILON=ON \
  -DGDAL_ENABLE_FRMT_GTA=ON \
  -DGDAL_ENABLE_FRMT_RASTERLITE=ON \
  -DGDAL_ENABLE_FRMT_HDF5=ON \
  -DGDAL_ENABLE_FRMT_OPENJPEG=ON \
  -DGDAL_ENABLE_FRMT_WEBP=ON \
  -DOGR_ENABLE_SOSI=OFF \
  -DOGR_ENABLE_MYSQL=ON \
  -DOGR_ENABLE_LIBKML=ON \
  -DOGR_ENABLE_CAD=ON -DGDAL_USE_OPENCAD_INTERNAL=ON \
  /vagrant


```

Interactive configuration
-------------------------

You can change build parameters by calling cmake UI
`ccmake .` or `cmake-gui .`


Output directory structure
---------------------------

CMake supports out-of-source build. There is a separate directory for built outputs.

```
cmake-build-debug: main build script such as Makefile or Ninja.rule
  - CMakeFiles: intermediate results and object files.
  - autotest:  test programs
    - cpp: test programs
  - gdal:  libgdal.so
    - gdalplugins: gdal_*.so ogr_*.so plugin artifacts
    - apps: utility commands such as gdal-config gdalinfo ogrinfo etc.
    - html: doxygen generated documents.
    - man: doxygen generated manuals
    - fuzzers: fuzzers utilities
    - swig/python: python bindings
    - swig/csharp: csharp bindings
    - swig/php: php bindings
    - swig/perl: perl bindings
    - swig/java: java bindings
    - CMakeFiles/Export: cmake exported config files
```

Build documents
----------

To build API documents, please run

```
$ cmake --build . --target doc
$ cmake --build . --target man
```

To build documents, you need Doxygen document generation tool.


Run test
---------

You can run test by command line on build output directory root.

```
$ cmake --build . --target quicktest
```

or  if you select GNUMake as a generated system.

```
$ make autotest
```

THere is a test log in `autotest/Testing/Tempolary/LastTest.log`

There are test targets; `quicktest`, `autotest`, `test_sse`,`test_misc`

To run autotest target, you should enable SWIG_PYTHON=ON.

### Test for cross compile

CMake support emulator to run test for example WINE for mingw build.
Default toolchain for mingw defines WINE as an emulator for cross compiling.

Please see https://cmake.org/cmake/help/latest/variable/CMAKE_CROSSCOMPILING_EMULATOR.html for details.


Windows
--------

CMake build script support Windows platform with both MS Visual Stidio(VC) and MSYS2/Mingw.
You can see non-GUI build scripts on appveyor.yml for MSVC and vagrant environment
for cross compiling GDAL using mingw-w64.


Android
---------

The cmake build script includes script to for Andoroid port.
It depends on standard cmake scripts in Android-NDK.

Android NDK requires CMake 3.6 or higher.

Vagrant environment includes dependencies for Android.

If you want to build it by hand, please refer to gdal/script/vagrant/gdal-android.sh

```
cmake \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
    -C /vagrant/cmake/init/android.cmake \
    -DSWIG_JAVA=ON \
    ${GDAL_SOURCE}
```

IDE
-----

Modern IDEs(Integrated development environment), such as Visual Studio 17 and later,
JetBrains CLion, Android Studio and VScode, can recogize gdal's CMake build script natively.

CMake support all other development environment by generating configurations for tools.
For example you use XCode, you can specify generator target 'XCode' to generate
build script.

CI tests
--------

Using out-of-source capability, we can reduce test patterns
and run multiple build and test on same environment.

### Travis-CI test cases

- GCC on Ubuntu Trusty

- Clang 4.0 with PLUGIN on Ubuntu Trusty

- Clang 4.0 with PLUGIN and most drivers on Ubuntu Trusty

- Cross compile with mingw-w64 on Ubuntu Trusty

- Cross compile for Android on Ubuntu Trusty

- Mac OS X

### AppVeyor CI test cases

- MSVC 2017 for Win32

- MSVC 2015 for Win64

Configuration parameters
------------------------

### CMake standard options

- BUILD_SHARED_LIBS: build target as shared library


### Custom options

- USE_CPL: set ON to use CPL,Common Portability Library

- ENABLE_GNM: set ON to use GNM driver

- PAM_ENABLED: set ON to enable PAM

- BUILD_APPS: set ON to build utility applications

- GDAL_ENABLE_PLUGIN: set ON to build drivers as plugin

- GDAL_QHULL: set ON to build QHULL support

- GDAL_USE_LIBPCIDSK_INTERNAL: set ON to enable internal libpcidsk sdk

- RENAME_INTERNAL_LIBTIFF_SYMBOLS: set ON to rename internal symbols in libtiff

- BUILD_DOCS: set ON to build documentations


### Drivers

- GDAL_ENABLE_FRMT_ADRG
- GDAL_ENABLE_FRMT_AIGRID
- GDAL_ENABLE_FRMT_AAIGRID
- GDAL_ENABLE_FRMT_AIRSAR
- GDAL_ENABLE_FRMT_ARG
- GDAL_ENABLE_FRMT_BMP
- GDAL_ENABLE_FRMT_BSB
- GDAL_ENABLE_FRMT_CALS
- GDAL_ENABLE_FRMT_CEOS
- GDAL_ENABLE_FRMT_CEOS2
- GDAL_ENABLE_FRMT_COASP
- GDAL_ENABLE_FRMT_COSAR
- GDAL_ENABLE_FRMT_CTG
- DAL_ENABLE_FRMT_DDS
- DAL_ENABLE_FRMT_DIMAP
- GDAL_ENABLE_FRMT_DODS
- GDAL_ENABLE_FRMT_DTED
- GDAL_ENABLE_FRMT_E00GRID
- GDAL_ENABLE_FRMT_EEDA
- GDAL_ENABLE_FRMT_ELAS
- GDAL_ENABLE_FRMT_ENVISAT
- GDAL_ENABLE_FRMT_EPSILON
- GDAL_ENABLE_FRMT_FIT
- GDAL_ENABLE_FRMT_FITS
- GDAL_ENABLE_FRMT_GIF
- GDAL_ENABLE_FRMT_GTA
- GDAL_ENABLE_FRMT_GFF
- GDAL_ENABLE_FRMT_GIF
- GDAL_ENABLE_FRMT_GRIB
- GDAL_ENABLE_FRMT_GSG
- GDAL_ENABLE_FRMT_GTA
- GDAL_ENABLE_FRMT_GTIFF
- GDAL_ENABLE_FRMT_GXF
- GDAL_ENABLE_FRMT_HDF4
- GDAL_ENABLE_FRMT_HDF5
- GDAL_ENABLE_FRMT_HF2
- GDAL_ENABLE_FRMT_HFA
- GDAL_ENABLE_FRMT_IDRISI
- GDAL_ENABLE_FRMT_ILWIS
- GDAL_ENABLE_FRMT_INGR
- GDAL_ENABLE_FRMT_IRIS
- GDAL_ENABLE_FRMT_JAXAPALSAR
- GDAL_ENABLE_FRMT_JDEM
- GDAL_ENABLE_FRMT_JPEG
- GDAL_ENABLE_FRMT_JPEG2000
- GDAL_ENABLE_FRMT_JPEGLS
- GDAL_ENABLE_FRMT_KMLSUPEROVERLAY
- GDAL_ENABLE_FRMT_KEA
- GDAL_ENABLE_FRMT_L1B
- GDAL_ENABLE_FRMT_LEVELLER
- GDAL_ENABLE_FRMT_MAP
- GDAL_ENABLE_FRMT_MBTILES
- GDAL_ENABLE_FRMT_MEM
- GDAL_ENABLE_FRMT_MRF
- GDAL_ENABLE_FRMT_MRSID
- GDAL_ENABLE_FRMT_MRSID_LIDAR
- GDAL_ENABLE_FRMT_MSGN
- GDAL_ENABLE_FRMT_NETCDF
- GDAL_ENABLE_FRMT_NGSGEOID
- GDAL_ENABLE_FRMT_NITF
- GDAL_ENABLE_FRMT_OPENJPEG
- GDAL_ENABLE_FRMT_OZI
- GDAL_ENABLE_FRMT_PCIDSK
- GDAL_ENABLE_FRMT_PCRASTER
- GDAL_ENABLE_FRMT_POSTGISRASTER)
- GDAL_ENABLE_FRMT_PDF
- GDAL_ENABLE_FRMT_PDS
- GDAL_ENABLE_FRMT_PLMOSAIC
- GDAL_ENABLE_FRMT_PNG
- GDAL_ENABLE_FRMT_POSTGISRASTER
- GDAL_ENABLE_FRMT_PRF
- GDAL_ENABLE_FRMT_R
- GDAL_ENABLE_FRMT_RAW
- GDAL_ENABLE_FRMT_RASTERLITE
- GDAL_ENABLE_FRMT_RDA
- GDAL_ENABLE_FRMT_RIK
- GDAL_ENABLE_FRMT_RMF
- GDAL_ENABLE_FRMT_RS2
- GDAL_ENABLE_FRMT_SAFE
- GDAL_ENABLE_FRMT_SAGA
- GDAL_ENABLE_FRMT_SDTS
- GDAL_ENABLE_FRMT_SENTINEL2
- GDAL_ENABLE_FRMT_SGI
- GDAL_ENABLE_FRMT_TERRAGEN
- GDAL_ENABLE_FRMT_TIL
- GDAL_ENABLE_FRMT_TSX
- GDAL_ENABLE_FRMT_USGSDEM
- GDAL_ENABLE_FRMT_VRT
- GDAL_ENABLE_FRMT_WCS
- GDAL_ENABLE_FRMT_WEBP
- GDAL_ENABLE_FRMT_WMS
- GDAL_ENABLE_FRMT_WMTS
- GDAL_ENABLE_FRMT_XPM
- GDAL_ENABLE_FRMT_XYZ
- GDAL_ENABLE_FRMT_ECW
- GDAL_ENABLE_FRMT_SDE

- OGR_ENABLE_AMIGOCLOUD
- OGR_ENABLE_CAD
- OGR_ENABLE_CARTO
- OGR_ENABLE_CLOUDANT
- OGR_ENABLE_CSW
- OGR_ENABLE_DODS
- OGR_ENABLE_DWG)
- OGR_ENABLE_ELASTIC
- OGR_ENABLE_GEOJSON
- OGR_ENABLE_GEOMEDIA
- OGR_ENABLE_GFT
- OGR_ENABLE_GMLAS
- OGR_ENABLE_ILI
- OGR_ENABLE_LIBKML
- OGR_ENABLE_MITAB
- OGR_ENABLE_MONGODB
- OGR_ENABLE_MYSQL
- OGR_ENABLE_NAS)
- OGR_ENABLE_PDS
- OGR_ENABLE_PG
- OGR_ENABLE_PLSCENES
- OGR_ENABLE_SOSI
- OGR_ENABLE_SHAPE
- OGR_ENABLE_SQLITE
- OGR_ENABLE_SVG
- OGR_ENABLE_VFK
- OGR_ENABLE_WFS
- OGR_ENABLE_XLSX

- OGR_ENABLE_SDE
- OGR_ENABLE_FME
- OGR_ENABLE_OCI
- OGR_ENABLE_DB2
- OGR_ENABLE_MSSQLSPATIAL
- OGR_ENABLE_ODS
- OGR_ENABLE_OGDI

- GDAL_ENABLE_FRMT_GRASS
- OGR_ENABLE_GRASS


Drivers which has special scripts
---------------------------------

### gdal_ADRG and gdal_SRP (gdal/frmts/adrg)

There are two individual drivers and modules in gdal/frmts/adrg
It is sinlgle build script CMakeLists.txt that have two configurations.

### libz (gdal/frmts/zlib)

This is not normal driver but internal library.

### gdal_geotiff (gdal/frmts/gtiff)

These are referred from other drivers so it should be built into libgdal
to resolve plugins dependencies.


