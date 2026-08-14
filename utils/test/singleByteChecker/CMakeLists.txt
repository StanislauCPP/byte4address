cmake_minimum_required(VERSION 3.25)
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME TESTNAME)

project(TEST${TESTNAME} LANGUAGES C)

add_executable(${TESTNAME} main.c)
include(../preSet.cmake)

enable_testing()

add_test(NAME ${TESTNAME}0 COMMAND $<TARGET_FILE:${TESTNAME}> 0) ## There is test for the range: from 0 to 255
add_test(NAME ${TESTNAME}1 COMMAND $<TARGET_FILE:${TESTNAME}> 1) ## There is test for the range: from 256 to 65535
add_test(NAME ${TESTNAME}2 COMMAND $<TARGET_FILE:${TESTNAME}> 2) ## There is test for last number (65535) in the range