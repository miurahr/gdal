#
# Search found packages and return all the packages are found or not.
#

function(are_packages_found _pkgs _result)
    get_property(_EnabledPackages GLOBAL PROPERTY PACKAGES_FOUND)
    foreach(_pkg IN ITEMS ${_pkgs})
        list(FIND _EnabledPackages ${_pkg} _found)
        if(_found EQUAL -1)
            set(${_result} OFF PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${_result} ON PARENT_SCOPE)
endfunction()
