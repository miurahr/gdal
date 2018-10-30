foreach(test_target IN ITEMS
        osr_basic osr_compd osr_ct osr_ct_proj osr_epsg
        osr_erm osr_esri osr_getprojectionmethods osr_metacrs osr_micoordsys
        osr_ozi osr_pci osr_pm osr_proj4
        osr_usgs osr_validate osr_xml osr_url
        )
    add_test(NAME ${test_target} COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST ${test_target} PROPERTY LABELS osr-test)
    set_autotest_properties(TESTS ${test_target})
endforeach()
foreach(test_target IN ITEMS osr_url osr_esri)
    set_property(TEST ${test_target} PROPERTY TIMEOUT 20)
endforeach()
