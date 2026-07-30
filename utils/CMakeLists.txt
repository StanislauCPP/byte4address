cmake_minimum_required(VERSION 3.20)
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME LIBNAME)

project(LIB${LIBNAME} LANGUAGES C)

add_library(${LIBNAME} src/utils.c)
target_include_directories(${LIBNAME} PUBLIC include)