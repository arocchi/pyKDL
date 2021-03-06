cmake_minimum_required(VERSION 2.8.11)
include(ExternalProject)

set(PROJECTNAME pyKDL)
project(${PROJECTNAME})

# Copyright: (C) 2014 Walkman Consortium
# Authors: Alessio Rocchi
# CopyPolicy: Released under the terms of the GNU GPL v2.0.

cmake_minimum_required(VERSION 2.8.12)
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 OLD)
    cmake_policy(SET CMP0005 NEW)
    cmake_policy(SET CMP0017 NEW)
endif(COMMAND cmake_policy)
include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/")


FIND_PACKAGE(orocos_kdl REQUIRED)

# add include directories
INCLUDE_DIRECTORIES(. ${orocos_kdl_INCLUDE_DIRS})

find_package(SWIG)
if(SWIG_FOUND)
    include(UseSWIG)

    set_source_files_properties(pyKDL.i PROPERTIES CPLUSPLUS ON)

    include_directories(. include)
    link_libraries(${orocos_kdl_LIBRARIES})

    set(CMAKE_SWIG_FLAGS "-Wall;-module;pyKDL;-threads")

        set(GYM_USES_PYTHON_VERSION "" CACHE STRING "Specify python version to use" )

        find_package(PythonInterp ${GYM_USES_PYTHON_VERSION} REQUIRED)
        set(GYM_USES_PYTHON_VERSION_ARGS)
        if(NOT GYM_USES_PYTHON_VERSION)
          set (GYM_USES_PYTHON_VERSION ${PYTHON_VERSION_STRING})
        endif()

        find_package(PythonLibs ${GYM_USES_PYTHON_VERSION} EXACT)
        include_directories(${PYTHON_INCLUDE_PATH})
        link_libraries(${PYTHON_LIBRARY})

        set(target_name pyKDL)

        swig_add_module(${target_name} python pyKDL.i)
        set_target_properties(_${target_name} PROPERTIES OUTPUT_NAME "_pyKDL")
        set_target_properties(_${target_name} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/python)

        # installation path is determined reliably on most platforms using distutils
        execute_process(COMMAND ${PYTHON_EXECUTABLE}
            -c "from distutils import sysconfig; print(sysconfig.get_python_lib(1,0,prefix=''))"
        OUTPUT_VARIABLE PYTHON_INSTDIR OUTPUT_STRIP_TRAILING_WHITESPACE )
        install(FILES ${CMAKE_CURRENT_BINARY_DIR}/pyKDL.py
                DESTINATION ${PYTHON_INSTDIR} )
        install(TARGETS _${target_name} DESTINATION ${PYTHON_INSTDIR} )

endif(SWIG_FOUND)
