include(${CMAKE_CURRENT_LIST_DIR}/XIHD.cmake)

if(DEMO_RUN_XIHD1)
    include(${CMAKE_CURRENT_LIST_DIR}/XIHD1.cmake)
endif()

if(DEMO_RUN_XIHD2)
    include(${CMAKE_CURRENT_LIST_DIR}/XIHD2.cmake)
endif()

if(DEMO_RUN_XIHD3)
    include(${CMAKE_CURRENT_LIST_DIR}/XIHD3.cmake)
endif()

if(DEMO_APPIMAGE)
    include(${CMAKE_CURRENT_LIST_DIR}/XIHD1.cmake)
endif()
