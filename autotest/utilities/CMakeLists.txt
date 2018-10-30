foreach(test_target IN ITEMS
        test_gdal_contour test_gdal_grid test_gdal_grid_lib test_gdal_rasterize
        test_gdal_rasterize_lib test_gdal_translate test_gdal_translate_lib test_gdaladdo
        test_gdalbuildvrt test_gdalbuildvrt_lib test_gdaldem test_gdaldem_lib
        test_gdalinfo test_gdalinfo_lib test_gdallocationinfo test_gdalsrsinfo
        test_gdaltindex test_gdaltransform test_gdalwarp test_gdalwarp_lib
        test_gnmutils test_nearblack test_nearblack_lib test_ogr2ogr
        test_ogr2ogr_lib test_ogrinfo test_ogrlineref test_ogrtindex
        )
    add_test(NAME ${test_target} COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST ${test_target} PROPERTY LABELS utilities-test)
    set_autotest_properties(TESTS ${test_target})
endforeach()
foreach(test_target IN ITEMS test_gdalbuildvrt test_gdaldem test_gdalinfo test_gdalsrsinfo
       test_gdalwarp test_gdalwarp_lib test_ogrinfo test_gdal_grid  test_gdal_rasterize
       test_gdal_translate test_gdaltindex )
    set_property(TEST ${test_target} PROPERTY TIMEOUT 20)
endforeach()
set_property(TEST test_ogr2ogr PROPERTY TIMEOUT 30)
