# This file is used by 'build/CPackOptions.cmake', which 
# is generated from 'xmake/CPackOptions.cmake.in'

# NOTE
# message(STATUS ...) do not working, i do not known why?
# message(WARNING/FATAL_ERROR ...) works, can be used to debug!

if(CPACK_GENERATOR MATCHES "NSIS")
    # For windows start menu link create
    # A pair of value list: targetName => menu/linkName
    set(CPACK_NSIS_MENU_LINKS "bin/xtest.exe" "xtest")
endif()

if("${CPACK_GENERATOR}" STREQUAL "PackageMaker")

endif()

if(CPACK_GENERATOR MATCHES "IFW")

endif()