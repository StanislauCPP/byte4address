CREATE OR REPLACE FUNCTION byte4address_in(cstring)
	RETURNS byte4address
	AS '$libdir/byte4address', 'byte4address_input_disabled'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_out(byte4address)
	RETURNS cstring
	AS '$libdir/byte4address', 'byte4address_output'
	LANGUAGE C IMMUTABLE STRICT;

-- Functions byte4address_in and byte4address_out created only shell of type byte4address,
-- so we use check select typisdefined from pg_catalog.pg_type WHERE typname = 'byte4address') = false.
-- If this sql request be used more than one time and byte4address isn't droped, then typisdefined will equal true
DO $$
BEGIN
	IF ((select typisdefined from pg_catalog.pg_type WHERE typname = 'byte4address') = false)
	THEN
		CREATE TYPE byte4address (
			input = byte4address_in,
			output = byte4address_out,
			internallength = 4,
			alignment = int4
		);
	END IF;
END $$;