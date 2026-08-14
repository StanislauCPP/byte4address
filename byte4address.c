#include "postgres.h"
#include "fmgr.h"
#include "libpq/pqformat.h"

PG_MODULE_MAGIC;

/*This struct locates 4 bytes for address which is represented 4 single bytes*/
typedef struct { unsigned int alocator; } Byte4Addres;

PGDLLEXPORT Datum byte4address_input_disabled(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(byte4address_input_disabled);
/*Direct string input string isn't supported.
	Exammple:
		If we try use command: INSERT INTO tab (addr) '40,29,10,5'::byte4address
		- we'll get error message "Direct string input is not allowed for byte4address. Use make_byte4address() constructor instead." */
Datum byte4address_input_disabled(PG_FUNCTION_ARGS) {
	ereport(ERROR,
					(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
						errmsg("Direct string input is not allowed for byte4address. Use make_byte4address() constructor instead.")));
	
	PG_RETURN_DATUM(0); //Code isn't get to this place.
}

PGDLLEXPORT Datum byte4address_output(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(byte4address_output);
Datum byte4address_output(PG_FUNCTION_ARGS) {
	int8 answerSize = 32;																				//Think about answerSize. This size may be decreased.
																															//"%u.%u.%u.%u" - 3 symbols for each 1 byte number, and 1 symbol for each symbols '.'

	Byte4Addres *addr = (Byte4Addres *) PG_GETARG_POINTER(0);
	uint8 * byte = (uint8 *) &(addr->alocator);
	char *result = (char *) palloc(answerSize);
	snprintf(result, answerSize, "%u.%u.%u.%u", *(byte + 3), *(byte + 2), *(byte + 1), *(byte));
	PG_RETURN_CSTRING(result);
}