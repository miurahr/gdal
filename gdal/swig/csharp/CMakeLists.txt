# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# *	Author:	Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2018 Hiroshi Miura
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************

FIND_PACKAGE(SWIG REQUIRED)
find_package(CSharp REQUIRED)
include(GdalStandardIncludes)
add_custom_command(
         OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gdal.snk
         COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/gdal.snk
            ${CMAKE_CURRENT_BINARY_DIR}
)

#############################################################
# gdal_csharp.dll
#
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gdal)
add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/gdal/gdal_wrap.cpp
		COMMAND ${SWIG_EXECUTABLE} -namespace OSGeo.GDAL -outdir ${CMAKE_CURRENT_BINARY_DIR}/gdal -DSWIG2_CSHARP
			-dllimport gdal_wrap -Wall -I${CMAKE_SOURCE_DIR}/gdal/swig/include -I${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp
			-I${CMAKE_SOURCE_DIR}/gdal -c++ -csharp -o gdal_wrap.cpp ${CMAKE_SOURCE_DIR}/gdal/swig/include/gdal.i
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gdal
		DEPENDS ${GDAL_SWIG_COMMON_INCLUDE}
			${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp/typemaps_csharp.i
			${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp/gdal_csharp.i
)
set_source_files_properties(gdal_wrap PROPERTIES GENERATED 1)
add_library(gdal_wrap OBJECT ${CMAKE_CURRENT_BINARY_DIR}/gdal/gdal_wrap.cpp)
gdal_standard_includes(gdal_wrap)
add_custom_command(
		OUTPUT gdal_csharp.dll
		COMMAND ${CSHARP_COMPILER} /debug:full /target:library /out:gdal_csharp.dll /r:ogr_csharp.dll
                gdal/Access.cs                      gdal/GDALWarpAppOptions.cs
                gdal/AsyncReader.cs                 gdal/Gdal.cs
                gdal/AsyncStatusType.cs             gdal/GdalPINVOKE.cs
                gdal/Band.cs                        gdal/MajorObject.cs
                gdal/CPLErr.cs                      gdal/PaletteInterp.cs
                gdal/ColorEntry.cs                  gdal/RATFieldType.cs
                gdal/ColorInterp.cs                 gdal/RATFieldUsage.cs
                gdal/ColorTable.cs                  gdal/RIOResampleAlg.cs
                gdal/DataType.cs                    gdal/RWFlag.cs
                gdal/Dataset.cs                     gdal/RasterAttributeTable.cs
                gdal/Driver.cs                      gdal/RasterIOExtraArg.cs
                gdal/GCP.cs                         gdal/ResampleAlg.cs
                gdal/GDALBuildVRTOptions.cs         gdal/SWIGTYPE_p_GDALProgressFunc.cs
                gdal/GDALDEMProcessingOptions.cs    gdal/SWIGTYPE_p_int.cs
                gdal/GDALGridOptions.cs             gdal/SWIGTYPE_p_p_GDALDatasetShadow.cs
                gdal/GDALInfoOptions.cs             gdal/SWIGTYPE_p_p_GDALRasterBandShadow.cs
                gdal/GDALNearblackOptions.cs        gdal/Transformer.cs
                gdal/GDALRasterizeOptions.cs        gdal/XMLNode.cs
                gdal/GDALTranslateOptions.cs        gdal/XMLNodeType.cs
                gdal/GDALVectorTranslateOptions.cs
                ${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.cs
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		DEPENDS gdal_wrap ogr_csharp.dll ${CMAKE_CURRENT_BINARY_DIR}/gdal.snk
)

#############################################################
# ogr_csharp.dll
#
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/ogr)
add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/ogr/ogr_wrap.cpp
		COMMAND ${SWIG_EXECUTABLE} -namespace OSGeo.OGR -outdir ${CMAKE_CURRENT_BINARY_DIR}/ogr -DSWIG2_CSHARP
			-dllimport ogr_wrap -Wall -I${CMAKE_SOURCE_DIR}/gdal/swig/include -I${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp
			-I${CMAKE_SOURCE_DIR}/gdal -c++ -csharp -o ogr_wrap.cpp ${CMAKE_SOURCE_DIR}/gdal/swig/include/ogr.i
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/ogr
		DEPENDS ${GDAL_SWIG_COMMON_INCLUDE}
			${GDAL_ROOT_SOURCE_DIR}/swig/include/csharp/typemaps_csharp.i
			${GDAL_ROOT_SOURCE_DIR}/swig/include/csharp/ogr_csharp.i
)
set_source_files_properties(ogr_wrap PROPERTIES GENERATED 1)
add_library(ogr_wrap OBJECT ${CMAKE_CURRENT_BINARY_DIR}/ogr/ogr_wrap.cpp)
gdal_standard_includes(ogr_wrap)
add_custom_command(
		OUTPUT  ogr_csharp.dll
		COMMAND ${CSHARP_COMPILER} /debug:full /target:library /out:ogr_csharp.dll  /r:osr_csharp.dll
                ogr/DataSource.cs   ogr/FieldDefn.cs      ogr/Layer.cs
                ogr/Driver.cs       ogr/FieldSubType.cs   ogr/Ogr.cs
                ogr/Envelope.cs     ogr/FieldType.cs      ogr/OgrPINVOKE.cs
                ogr/Envelope3D.cs   ogr/GeomFieldDefn.cs  ogr/StyleTable.cs
                ogr/Feature.cs      ogr/Geometry.cs       ogr/wkbByteOrder.cs
                ogr/FeatureDefn.cs  ogr/Justification.cs  ogr/wkbGeometryType.cs
				${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.cs
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		DEPENDS ogr_wrap osr_csharp.dll ${CMAKE_CURRENT_BINARY_DIR}/gdal.snk
)

#############################################################
# osr_csharp.dll
#
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/osr)
add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/osr/osr_wrap.cpp
		COMMAND ${SWIG_EXECUTABLE} -namespace OSGeo.OSR -outdir ${CMAKE_CURRENT_BINARY_DIR}/osr -DSWIG2_CSHARP
			-dllimport osr_wrap -Wall -I${CMAKE_SOURCE_DIR}/gdal/swig/include -I${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp
			-I${CMAKE_SOURCE_DIR}/gdal -c++ -csharp -o osr_wrap.cpp ${CMAKE_SOURCE_DIR}/gdal/swig/include/osr.i
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/osr
		DEPENDS ${GDAL_SWIG_COMMON_INCLUDE}
			${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp/typemaps_csharp.i
			${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp/osr_csharp.i
)
set_source_files_properties(osr_wrap PROPERTIES GENERATED 1)
add_library(osr_wrap OBJECT ${CMAKE_CURRENT_BINARY_DIR}/osr/osr_wrap.cpp)
gdal_standard_includes(osr_wrap)
add_custom_command(
		OUTPUT  osr_csharp.dll
		COMMAND ${CSHARP_COMPILER} /debug:full /target:library /out:osr_csharp.dll
            	osr/AxisOrientation.cs           osr/Osr.cs         osr/SpatialReference.cs
				osr/CoordinateTransformation.cs  osr/OsrPINVOKE.cs
				${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.cs
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		DEPENDS osr_wrap ${CMAKE_CURRENT_BINARY_DIR}/gdal.snk
)

#############################################################
# gdalconst_csharp.dll
#
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/const)
add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/const/gdalconst_wrap.cpp
		COMMAND ${SWIG_EXECUTABLE} -namespace OSGeo.GDAL -outdir ${CMAKE_CURRENT_BINARY_DIR}/const -DSWIG2_CSHARP
			-dllimport gdalconst_wrap -Wall -I${CMAKE_SOURCE_DIR}/gdal/swig/include -I${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp
			-I${CMAKE_SOURCE_DIR}/gdal -c++ -csharp -o gdalconst_wrap.cpp ${CMAKE_SOURCE_DIR}/gdal/swig/include/gdalconst.i
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/const
		DEPENDS ${GDAL_SWIG_COMMON_INCLUDE}
			${CMAKE_SOURCE_DIR}/gdal/swig/include/csharp/typemaps_csharp.i
			${CMAKE_SOURCE_DIR}/gdal/swig/include/gdalconst.i
)
set_source_files_properties(gdalconst_wrap PROPERTIES GENERATED 1)
add_library(gdalconst_wrap OBJECT ${CMAKE_CURRENT_BINARY_DIR}/const/gdalconst_wrap.cpp)
gdal_standard_includes(gdalconst_wrap)
add_custom_command(
		OUTPUT  gdalconst_csharp.dll
		COMMAND ${CSHARP_COMPILER} /debug:full /target:library /out:gdalconst_csharp.dll
          		const/GdalConst.cs  const/GdalConstPINVOKE.cs
				${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.cs
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		DEPENDS gdalconst_wrap ${CMAKE_CURRENT_BINARY_DIR}/gdal.snk
)

#############################################################
# sample commands
#
add_custom_command(OUTPUT ogrinfo.exe
				   COMMAND ${CSHARP_COMPILER} /r:ogr_csharp.dll /r:osr_csharp.dll /out:ogrinfo.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/ogrinfo.cs
				   DEPENDS ogr_csharp.dll osr_csharp.dll)
add_custom_command(OUTPUT createdata.exe
				   COMMAND ${CSHARP_COMPILER} /r:ogr_csharp.dll /r:osr_csharp.dll /out:createdata.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/createdata.cs
                   DEPENDS ogr_csharp.dll osr_csharp.dll)
add_custom_command(OUTPUT OSRTransform.exe
				   COMMAND ${CSHARP_COMPILER} /r:osr_csharp.dll /out:OSRTransform.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/OSRTransform.cs
				   DEPENDS osr_csharp.dll)
add_custom_command(OUTPUT GDALRead.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /r:System.Drawing.dll /out:GDALRead.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALRead.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALReadDirect.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /r:System.Drawing.dll /out:GDALReadDirect.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALReadDirect.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALAdjustContrast.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /r:System.Drawing.dll /out:GDALAdjustContrast.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALAdjustContrast.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALDatasetRasterIO.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /r:System.Drawing.dll /out:GDALDatasetRasterIO.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALDatasetRasterIO.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALWrite.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALWrite.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALWrite.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALDatasetWrite.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALDatasetWrite.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALDatasetWrite.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALColorTable.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALColorTable.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALColorTable.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT WKT2WKB.exe
				   COMMAND ${CSHARP_COMPILER} /r:ogr_csharp.dll /out:WKT2WKB.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/WKT2WKB.cs
				   DEPENDS ogr_csharp.dll)
add_custom_command(OUTPUT OGRGEOS.exe
				   COMMAND ${CSHARP_COMPILER} /r:ogr_csharp.dll /out:OGRGEOS.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/OGRGEOS.cs
				   DEPENDS ogr_csharp.dll)
add_custom_command(OUTPUT ReadXML.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:ReadXML.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/ReadXML.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALInfo.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /r:osr_csharp.dll /out:GDALInfo.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALInfo.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALOverviews.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALOverviews.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALOverviews.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALCreateCopy.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALCreateCopy.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALCreateCopy.cs
				   DEPENDS gdal_csharp.dll)
add_custom_command(OUTPUT GDALGetHistogram.exe
				   COMMAND ${CSHARP_COMPILER} /r:gdal_csharp.dll /out:GDALGetHistogram.exe ${CMAKE_CURRENT_SOURCE_DIR}/apps/GDALGetHistogram.cs
				   DEPENDS gdal_csharp.dll)

add_custom_target(csharp_samples DEPENDS
				  ogrinfo.exe createdata.exe OSRTransform.exe GDALRead.exe GDALReadDirect.exe
				  GDALAdjustContrast.exe GDALDatasetRasterIO.exe GDALWrite.exe GDALDatasetWrite.exe
				  GDALColorTable.exe WKT2WKB.exe OGRGEOS.exe ReadXML.exe GDALInfo.exe GDALOverviews.exe
				  GDALCreateCopy.exe GDALGetHistogram.exe)
