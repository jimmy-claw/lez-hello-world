cmake_minimum_required(VERSION 3.16)
project(lez_hello_world_module LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_INSTALL_RPATH "$ORIGIN")
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

# FFI library path (override via -DHELLO_FFI_LIB=... for Nix builds)
set(HELLO_FFI_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib/libhello_ffi.so" CACHE FILEPATH "Path to libhello_ffi shared library")
set(HELLO_FFI_INCLUDE "" CACHE PATH "Path to FFI include directory")

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

qt_add_qml_module(lez_hello_world_module
    URI LezHelloWorld
    VERSION 1.0
    NO_GENERATE_PLUGIN_SOURCE
    QML_FILES
        qml/HelloWorldView.qml
    SOURCES
        src/hello_world_plugin.cpp
        src/HelloWorldBridge.cpp
        src/HelloWorldBridge.h
)

target_include_directories(lez_hello_world_module PRIVATE
    include
    src
    ${HELLO_FFI_INCLUDE}
)

target_link_libraries(lez_hello_world_module PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    ${HELLO_FFI_LIB}
)

install(TARGETS lez_hello_world_module LIBRARY DESTINATION lib)
install(TARGETS lez_hello_world_moduleplugin LIBRARY DESTINATION lib)
