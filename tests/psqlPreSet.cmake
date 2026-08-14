# Set PostgreSQL_ROOT in command line. For example: -DPostgreSQL_ROOT="Y:/programmes/PostgreSQL/17".
# This parametr need to find package PostgreSQL correctly
if(NOT PostgreSQL_ROOT)
	message(FATAL_ERROR "<<PostgreSQL_ROOT wasn't setted>>")
endif()
find_package(PostgreSQL 14 REQUIRED)

# We need psql to execute sql script for certain test
find_program(POSTGRES_PSQL psql REQUIRED
							HINTS "${PostgreSQL_ROOT}/*"
							DOC "Path to psql executable")

# Preparing psql command
# There are two ways for setting connection settings and psql flags: from includes or from command line
include(${CMAKE_CURRENT_LIST_DIR}/../settingsForPostgres/connection.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../settingsForPostgres/psqlFlags.cmake)
set(PSQLCOMMAND ${POSTGRES_PSQL}	${FLAG_HOST}		${Postgres_HOST}
																	${FLAG_PORT}		${Postgres_PORT}
																	${FLAG_DBNAME}	${Postgres_DBNAME}
																	${FLAG_USER}		${Postgres_USER}
																	${FLAG_FILE})