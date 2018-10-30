foreach(test_target IN ITEMS
        applyverticalshiftgrid contour cutline dither polygonize proximity rasterize reproject
        sieve tps transformgeoloc warp
        )
    add_test(NAME alg_${test_target} COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST alg_${test_target} PROPERTY LABELS alg-test)
    set_autotest_properties(TESTS alg_${test_target})
endforeach()
set_property(TEST alg_warp PROPERTY TIMEOUT 10)
