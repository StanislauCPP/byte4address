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

	uint32_t alocator = PG_GETARG_UINT32(0);
	char *result = (char *) palloc(answerSize);
	snprintf(result, answerSize, "%u.%u.%u.%u", (alocator >> 24) & 0xFF, (alocator >> 16) & 0xFF, (alocator >> 8) & 0xFF, (alocator) & 0xFF);
	PG_RETURN_CSTRING(result);
}
/*Use it instead byte4address_input_disable*/
PGDLLEXPORT Datum byte4address_constructor(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(byte4address_constructor);
Datum byte4address_constructor(PG_FUNCTION_ARGS) {
	uint16_t b3 = (uint16_t) PG_GETARG_INT16(0);
	uint16_t b2 = (uint16_t) PG_GETARG_INT16(1);
	uint16_t b1 = (uint16_t) PG_GETARG_INT16(2);
	uint16_t b0 = (uint16_t) PG_GETARG_INT16(3);

	/*The smallest number type in postgres is smallint (equal 2 bytes)
	We check second byte that it is equaled 0*/
	if( (b3 | b2 | b1 | b0) > 0xFF ) {
		ereport(ERROR,
						(errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),
							errmsg("Check bytes. Some bytes have out of range. b3 = %hu b2 = %hu b1 = %hu b0 = %hu", b3, b2, b1, b0)));
	}

	uint32_t result = (((uint32_t) b3) << 24) | (((uint32_t) b2) << 16) | (((uint32_t) b1) << 8) | ((uint32_t) b0);
	PG_RETURN_DATUM(result);
}