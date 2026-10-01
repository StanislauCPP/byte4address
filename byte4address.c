#include "postgres.h"
#include "fmgr.h"
#include "libpq/pqformat.h"

PG_MODULE_MAGIC;

#define DATUMFUNCTIONNAME(functionName) PGDLLEXPORT Datum functionName(PG_FUNCTION_ARGS); \
																				PG_FUNCTION_INFO_V1(functionName); \
																				Datum functionName(PG_FUNCTION_ARGS)

/*This struct locates 4 bytes for address which is represented 4 single bytes*/
typedef struct { unsigned int alocator; } Byte4Addres;

/*Direct string input string isn't supported.
	Exammple:
		If we try use command: INSERT INTO tab (addr) '40,29,10,5'::byte4address
		- we'll get error message "Direct string input is not allowed for byte4address. Use make_byte4address() constructor instead." */
DATUMFUNCTIONNAME(byte4address_input_disabled) {
	ereport(ERROR,
					(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
						errmsg("Direct string input is not allowed for byte4address. Use make_byte4address() constructor instead.")));
	
	PG_RETURN_DATUM(0); //Code isn't get to this place.
}

DATUMFUNCTIONNAME(byte4address_output) {
	int8 answerSize = 16;																				//"%u.%u.%u.%u" - 3 symbols for each 1 byte number, and 1 symbol for each symbols '.', and 1 symbol for \0
	uint32_t alocator = PG_GETARG_UINT32(0);
	char *result = (char *) palloc(answerSize);
	snprintf(result, answerSize, "%u.%u.%u.%u", (alocator >> 24) & 0xFF, (alocator >> 16) & 0xFF, (alocator >> 8) & 0xFF, (alocator) & 0xFF);
	PG_RETURN_CSTRING(result);
}

/*Use it instead byte4address_input_disable*/
DATUMFUNCTIONNAME(byte4address_constructor) {
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

DATUMFUNCTIONNAME(byte4address_comparision_less)					{ PG_RETURN_BOOL((PG_GETARG_UINT32(0) <		PG_GETARG_UINT32(1))); }

DATUMFUNCTIONNAME(byte4address_comparision_greater)				{	PG_RETURN_BOOL((PG_GETARG_UINT32(0) >		PG_GETARG_UINT32(1))); }

DATUMFUNCTIONNAME(byte4address_comparision_lessequal)			{ PG_RETURN_BOOL((PG_GETARG_UINT32(0) <=	PG_GETARG_UINT32(1))); }

DATUMFUNCTIONNAME(byte4address_comparision_greaterequal)	{ PG_RETURN_BOOL((PG_GETARG_UINT32(0) >=	PG_GETARG_UINT32(1))); }

DATUMFUNCTIONNAME(byte4address_comparision_equal)					{ PG_RETURN_BOOL((PG_GETARG_UINT32(0) ==	PG_GETARG_UINT32(1))); }

DATUMFUNCTIONNAME(byte4address_comparision_for_index) {
	uint32_t leftArg = PG_GETARG_UINT32(0);
	uint32_t rightArg = PG_GETARG_UINT32(1);

	if (leftArg < rightArg)
	 PG_RETURN_INT32(-1);
	if (leftArg > rightArg)
		PG_RETURN_INT32(1);

	PG_RETURN_INT32(0);
}	