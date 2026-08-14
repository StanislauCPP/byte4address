# Installation byte4address into postgres

# Getting library directory (for server execution) for install custom library into postgres
execute_process(COMMAND ${POSTGRES_PG_CONFIG} --pkglibdir
								OUTPUT_VARIABLE PG_LIB_DIR_INST
								OUTPUT_STRIP_TRAILING_WHITESPACE)

install(TARGETS ${LIBNAME} CONFIGURATIONS Release
				RUNTIME DESTINATION ${PG_LIB_DIR_INST})

# There are two ways for setting connection settings and psql flags: from includes or from command line
include(settingsForPostgres/connection.cmake)
include(settingsForPostgres/psqlFlags.cmake)

# We need psql to execute sql script for introduction byte4address into postgres
# ${VAR} - variable is setted on generation step; \${VAR} - variable is setted on installation step
install(CODE "find_program(POSTGRES_PSQL psql REQUIRED
														HINTS \"${PostgreSQL_ROOT}/*\"
														DOC \"Path to psql executable\")
							
							execute_process(COMMAND \${POSTGRES_PSQL} ${FLAG_HOST} 		${Postgres_HOST}
																												${FLAG_PORT} 		${Postgres_PORT}
																												${FLAG_DBNAME}	${Postgres_DBNAME}
																												${FLAG_USER}		${Postgres_USER}
																												${FLAG_FILE} 		SQLRequests/setIOFunctionTypeInDB.sql)")