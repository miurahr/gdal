#
# FindPython
# - Limited Compatibility module for < 3.12
#
# Copyright (C) 2018 Hiroshi Miura
#
# Only support as similar behavior as find_package(Python COMPONENTS Development)
#

# handle components
if(NOT Python_FIND_COMPONENTS)
    set(Python_FIND_COMPONENTS Interpreter)
endif()
foreach(_Python_COMPONENT IN LISTS Python_FIND_COMPONENTS)
    set(Python_${_Python_COMPONENT}_FOUND FALSE)
endforeach()

macro(FindPythonSupport)
    if("Interpreter" IN_LIST Python_FIND_COMPONENTS)
        find_package(PythonInterp REQUIRED)
    else()
        find_package(PythonInterp)
    endif()
    set(Python_EXECUTABLE ${PYTHON_EXECUTABLE})
    if(PYTHONINTERP_FOUND)
        set(Python_Interpreter_FOUND TRUE)
    endif()

    if ("Development" IN_LIST Python_FIND_COMPONENTS)
        if(PYTHONINTERP_FOUND)
            find_package(PythonLibs)
            if(PYTHONLIBS_FOUND)
                # Set variables as same as one on FindPython in cmake 3.12
                set(Python_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
                set(Python_LIBRARIES ${PYTHON_LIBRARIES})
                set(Python_VERSION ${PYTHONLIBS_VERSION_STRING})
                set(Python_VERSION_MAJOR ${PYTHON_VERSION_MAJOR})
                set(Python_VERSION_MINOR ${PYTHON_VERSION_MINOR})
                set(_version_major_minor "${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}")
                set(Python_Development_FOUND TRUE)
            endif()
        endif()

        if(NOT ANDROID AND NOT IOS)
            execute_process(COMMAND ${Python_EXECUTABLE} -c "from distutils.sysconfig import *; print(get_python_lib(plat_specific=False,standard_lib=True))"
                            RESULT_VARIABLE _py_process
                            OUTPUT_VARIABLE _path
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(Python_STDLIB "${_path}")
            execute_process(COMMAND ${Python_EXECUTABLE} -c "from distutils.sysconfig import *; print(get_python_lib(plat_specific=True,standard_lib=True))"
                            RESULT_VARIABLE _py_process
                            OUTPUT_VARIABLE _path
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(Python_STDARCH "${_path}")
            execute_process(COMMAND ${Python_EXECUTABLE} -c "from distutils.sysconfig import *; print(get_python_lib(plat_specific=False,standard_lib=False))"
                            RESULT_VARIABLE _py_process
                            OUTPUT_VARIABLE _path
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(Python_SITELIB "${_path}")
            execute_process(COMMAND ${Python_EXECUTABLE} -c "from distutils.sysconfig import *; print(get_python_lib(plat_specific=True,standard_lib=False))"
                            RESULT_VARIABLE _py_process
                            OUTPUT_VARIABLE _path
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(Python_SITEARCH "${_path}")
            unset(_py_process)
            unset(_path)

            if(NOT Python_SITEARCH)
                # Path detection function borrowed from OpenCV
                if(CMAKE_HOST_UNIX)
                    execute_process(COMMAND ${_executable} -c "from distutils.sysconfig import *; print(get_python_lib())"
                                    RESULT_VARIABLE _py_process
                                    OUTPUT_VARIABLE _path
                                    OUTPUT_STRIP_TRAILING_WHITESPACE)
                    if("${_path}" MATCHES "site-packages")
                        set(_packages_path "python${_version_major_minor}/site-packages")
                        set(_stdlib_path "python${_version_major_minor}")
                    else() #debian based assumed, install to the dist-packages.
                        set(_packages_path "python${_version_major_minor}/dist-packages")
                        set(_stdlib_path "python${_version_major_minor}")
                    endif()
                elseif(CMAKE_HOST_WIN32)
                    get_filename_component(_path "${Python_EXECUTABLE}" PATH)
                    file(TO_CMAKE_PATH "${_path}" _path)
                    if(NOT EXISTS "${_path}/Lib/site-packages")
                        unset(_path)
                        get_filename_component(_path "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\${_version_major_minor}\\InstallPath]" ABSOLUTE)
                        if(NOT _path)
                            get_filename_component(_path "[HKEY_CURRENT_USER\\SOFTWARE\\Python\\PythonCore\\${_version_major_minor}\\InstallPath]" ABSOLUTE)
                        endif()
                        file(TO_CMAKE_PATH "${_path}" _path)
                    endif()
                    set(_packages_path "${_path}/Lib/site-packages")
                    set(_stdlib_path "${_path}/Lib")
                endif()
                set(Python_STDLIB "${_stdlib_path}")
                set(Python_STDARCH "${_stdlib_path}")
                set(Python_SITELIB "${_packages_path}")
                set(Python_SITEARCH "${_packages_path}")
                unset(_path)
                unset(_stdlib_path)
                unset(_pacakges_path)
            endif()
        endif()
    endif()
    if ("Development" IN_LIST Python_FIND_COMPONENTS)
        if(PYTHONINTERP_FOUND AND PYTHONLIBS_FOUND)
            set(Python_FOUND TRUE)
        endif()
    else()
        if(PYTHONINTERP_FOUND)
            set(Python_FOUND TRUE)
        endif()
    endif()
endmacro()

if (DEFINED Python_FIND_VERSION)
    set(Python_ADDITIONAL_VERSION ${Python_FIND_VERSION})
    FindPythonSupport()
else()
    set (_Python_REQUIRED_VERSIONS 3 2)
    foreach (_Python_REQUIRED_VERSION_MAJOR IN LISTS _Python_REQUIRED_VERSIONS)
        if(_Python_REQUIRED_VERSION_MAJOR EQUAL 2)
            set(Python_ADDITIONAL_VERSIONS 2.7)
        elseif(_Python_REQUIRED_VERSION_MAJOR EQUAL 3)
            set(Python_ADDITIONAL_VERSIONS 3.8 3.7 3.6 3.5 3.4)
        endif()
        FindPythonSupport()
        if(Python_FOUND)
            break()
        endif()
    endforeach()
endif()

