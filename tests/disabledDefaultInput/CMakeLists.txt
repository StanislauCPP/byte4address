cmake_minimum_required(VERSION 3.25)
project(defaultInputTest)

cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME TESTNAME)

include(../psqlPreSet.cmake)

enable_testing()
file(GLOB LISTINPUT input/*.sql)
set(i 1)
foreach(inp IN LISTS LISTINPUT)
	add_test(NAME ${TESTNAME}${i} COMMAND ${PSQLCOMMAND} ${inp})
	set_tests_properties(${TESTNAME}${i} PROPERTIES PASS_REGULAR_EXPRESSION "Direct string input is not allowed for byte4address")

	math(EXPR i "${i} + 1")
endforeach()