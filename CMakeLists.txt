cmake_minimum_required(VERSION 3.25)
project(postgres_byte4address_type C)

# We need to make this variable cached to use them in install step
set(PostgreSQL_ROOT "" CACHE STRING "Variable for find package PostgreSQL")
set(LIBNAME "" CACHE STRING "Variable for library name")

# Set PostgreSQL_ROOT in command line. For example: -DPostgreSQL_ROOT="Y:/programmes/PostgreSQL/17".
# This parametr need to find package PostgreSQL correctly
if(NOT PostgreSQL_ROOT)
	message(FATAL_ERROR "<<PostgreSQL_ROOT wasn't setted>>")
endif()
find_package(PostgreSQL 14 REQUIRED)

# We need pg_config to get certain pathes:
# include server directory; library directory (for developing); library directory (for server execution)
find_program(POSTGRES_PG_CONFIG pg_config REQUIRED
							HINTS "${PostgreSQL_ROOT}/*"
							DOC "Path to pg_config executable")

# Getting include server directory path
execute_process(COMMAND ${POSTGRES_PG_CONFIG} --includedir-server
									OUTPUT_VARIABLE PG_INCLUDE_SERVER_DIR
									OUTPUT_STRIP_TRAILING_WHITESPACE)

# Getting library directory path
execute_process(COMMAND ${POSTGRES_PG_CONFIG} --libdir
									OUTPUT_VARIABLE PG_LIB_DIR
									OUTPUT_STRIP_TRAILING_WHITESPACE)

cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME LIBNAME)
add_library(${LIBNAME} SHARED ${LIBNAME}.c)

target_include_directories(${LIBNAME} PRIVATE ${PG_INCLUDE_SERVER_DIR}
																								${PostgreSQL_INCLUDE_DIRS}
																								"${PG_INCLUDE_SERVER_DIR}/port/win32"
																								"${PG_INCLUDE_SERVER_DIR}/port/win32_msvc")

# Getting postgres.lib from this linking
target_link_directories(${LIBNAME} PRIVATE "${PG_LIB_DIR}")
add_subdirectory(utils)
target_link_libraries(${LIBNAME} PRIVATE postgres.lib utils)

include(libInstall.cmake)