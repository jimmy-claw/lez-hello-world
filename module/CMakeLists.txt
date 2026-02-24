cmake_minimum_required(VERSION 3.16)
project(lez_hello_world_module LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

qt_add_qml_module(lez_hello_world_module
    URI LezHelloWorld
    VERSION 1.0
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
)

target_link_libraries(lez_hello_world_module PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/libhello_ffi.so
)
