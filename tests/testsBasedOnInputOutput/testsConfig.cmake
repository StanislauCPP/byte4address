# $ENV{SHELL} is used because windows 10 get bash from WSL instead git bash

add_executable(${TESTNAME} ${CMAKE_CURRENT_LIST_DIR}/main.cpp)

include(${CMAKE_CURRENT_LIST_DIR}/../psqlPreSet.cmake)
enable_testing()

set(SCHEMA			"for_testing_byte4address")
set(DBFIXTURE		"db_fixture")

# installing type byte4address in schema for testing
add_test(NAME installing_type_byte4address_in_schema_for_testing COMMAND $ENV{SHELL} -c "cd ${CMAKE_CURRENT_LIST_DIR}/../..;
																																													cmake -S . -B build -DPostgreSQL_ROOT=\"${PostgreSQL_ROOT}\" -DINSTALLINGSCHEMA=\"${SCHEMA}\";
																																													cmake --build build --config Release;
																																													cmake --install build --config Release")
set_tests_properties(installing_type_byte4address_in_schema_for_testing PROPERTIES FIXTURES_SETUP ${DBFIXTURE} LABELS ${DBFIXTURE})

# testComposition is used for tests (required and cleanup)
function(testComposition testName psqlCustomSettings checkOutput fixtureSettings)
	list(JOIN PSQLCOMMAND "\" \"" PSQLCOMMANDSTRING)																							# \" \" - defend from spaces which can may be in psql.exe absolute path
	# -v "ON_ERROR_STOP=1" - need to get exit code from psql, for example exit code may be 1,2... not only 0.
	add_test(NAME ${testName} COMMAND $ENV{SHELL} -c "\"${PSQLCOMMANDSTRING}\" ${psqlCustomSettings} -v \"ON_ERROR_STOP=1\"; ${checkOutput}")
	set_tests_properties(${testName} PROPERTIES FIXTURES_${fixtureSettings} ${DBFIXTURE} LABELS ${DBFIXTURE})
endfunction()

## get real output from test requests
set(REALOUTPUT ${CMAKE_CURRENT_BINARY_DIR}/realOutput)
file(MAKE_DIRECTORY ${REALOUTPUT})
file(GLOB LISTINPUT input/*.sql)
file(GLOB LISTEXPECTEDOUTPUT expectedOutput/*.out)
foreach(inp expOut IN ZIP_LISTS LISTINPUT LISTEXPECTEDOUTPUT)
	get_filename_component(INPFILENAME ${inp} NAME_WE)
	set(REALOUTPUTFILE ${REALOUTPUT}/output_${INPFILENAME}.out)
	testComposition(${TESTNAME}_${INPFILENAME}
									"-c \"SET SCHEMA '${SCHEMA}'\" -q -f ${inp} -o ${REALOUTPUTFILE}"
									"$<TARGET_FILE:${TESTNAME}> ${expOut} ${REALOUTPUTFILE}"
									"REQUIRED")
endforeach()

testComposition("deleting_schema_with_tested_tables"
								"-c 'DROP SCHEMA ${SCHEMA} CASCADE' -q"
								""
								"CLEANUP")