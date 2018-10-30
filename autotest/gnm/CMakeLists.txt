foreach(test_target IN ITEMS
        gnm_test
        )
    add_test(NAME ${test_target} COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST ${test_target} PROPERTY LABELS gnm-test)
    set_autotest_properties(TESTS ${test_target})
endforeach()
