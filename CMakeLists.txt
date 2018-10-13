cmake_minimum_required(VERSION 3.6)
project(parceltoy CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -w")

# Find and include HPX settings
if(NOT HPX_DIR)
    message(FATAL "HPX_DIR not set, unable to find HPX!")
endif()

message(STATUS "HPX_DIR=${HPX_DIR}")

# This adds the HPX cmake configuration directory to the search path.
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
        ${HPX_DIR}/share/cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/Modules)

# Instruct cmake to find the HPX settings
find_package(HPX NO_CMAKE_PACKAGE_REGISTRY REQUIRED)
if(HPX_FOUND)
    include_directories(${HPX_INCLUDE_DIR})
    link_directories(${HPX_LIBRARY_DIR})
endif()

# Adjust auxiliary build settings for HPX to work properly
if(NOT MSVC)
    set(HPX_RPATH
            "${HPX_RPATH}:${CMAKE_INSTALL_PREFIX}/lib/hpx:${CMAKE_BINARY_DIR}/lib/hpx")
else()
    # enable solution folders for MSVC
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
    if(HPX_NO_INSTALL)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/$(Configuration)" CACHE PATH
                "Prefix prepended to install directories." FORCE)
    endif()
    hpx_add_compile_flag(-MP)         # Multiprocessor build
    hpx_add_compile_flag(-bigobj)     # Increase the maximum size of object file sections
endif()

add_executable(parceltoy_exe pingpong_performance.cpp)
hpx_setup_target(parceltoy_exe COMPONENT_DEPENDENCIES iostreams)

