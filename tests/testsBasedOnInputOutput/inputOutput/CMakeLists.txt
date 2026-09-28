cmake_minimum_required(VERSION 3.25)
project(inputOutputTesting LANGUAGES CXX)

cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME TESTNAME)

include(../testsConfig.cmake)

file(GLOB LISTINPUT incorrectInput/*.sql)

## Some specific tests for incorrect input
foreach(inp IN LISTS LISTINPUT)
	get_filename_component(INPFILENAME ${inp} NAME_WE)
	set(TESTSTEPNAME ${TESTNAME}_incorrectInput_${INPFILENAME})
	add_test(NAME ${TESTSTEPNAME} COMMAND ${PSQLCOMMAND} -f ${inp})
	set_tests_properties(${TESTSTEPNAME} PROPERTIES PASS_REGULAR_EXPRESSION "Check bytes")
endforeach()