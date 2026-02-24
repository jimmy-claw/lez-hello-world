cmake_minimum_required(VERSION 3.16)
project(lez_hello_world_app LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_INSTALL_RPATH "$ORIGIN")
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

set(MODULE_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../module/src" CACHE PATH "Path to module source directory")
set(HELLO_FFI_LIB "" CACHE FILEPATH "Path to libhello_ffi shared library")
set(HELLO_FFI_INCLUDE "" CACHE PATH "Path to FFI include directory")

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

# Bundle HelloWorldView.qml from the module QML directory
set(HW_VIEW "${CMAKE_CURRENT_SOURCE_DIR}/../module/qml/HelloWorldView.qml")
set_source_files_properties(${HW_VIEW} PROPERTIES QT_RESOURCE_ALIAS "HelloWorldView.qml")

qt_add_executable(lez-hello-world-app
    main.cpp
    ${MODULE_SRC}/HelloWorldBridge.cpp
)

qt_add_resources(lez-hello-world-app "qml"
    PREFIX "/"
    FILES
        main.qml
        ${HW_VIEW}
)

target_include_directories(lez-hello-world-app PRIVATE
    ${MODULE_SRC}
    ${CMAKE_CURRENT_SOURCE_DIR}/../module/include
    ${HELLO_FFI_INCLUDE}
)

target_link_libraries(lez-hello-world-app PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    ${HELLO_FFI_LIB}
)

install(TARGETS lez-hello-world-app RUNTIME DESTINATION bin)
