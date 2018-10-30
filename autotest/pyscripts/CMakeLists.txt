foreach(test_target IN ITEMS
        test_gdal2tiles test_gdal_calc test_gdal_edit test_gdal_fillnodata
        test_gdal_ls_py test_gdal_merge test_gdal_pansharpen test_gdal_polygonize
        test_gdal_proximity test_gdal_retile test_gdal_sieve test_gdalinfo_py
        test_gdalmove test_ogr2ogr_py test_ogrinfo_py test_ogrmerge
        test_rgb2pct)
    add_test(NAME ${test_target} COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST ${test_target} PROPERTY LABELS pyscripts-test)
    set_autotest_properties(TESTS ${test_target})
endforeach()
set_property(TEST test_gdal2tiles PROPERTY TIMEOUT 20)
set_property(TEST test_ogr2ogr_py PROPERTY TIMEOUT 20)
