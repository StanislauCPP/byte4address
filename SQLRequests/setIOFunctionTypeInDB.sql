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
	IF ((select t_type.typisdefined from pg_catalog.pg_type t_type
				JOIN pg_catalog.pg_namespace t_namespace ON t_type.typnamespace = t_namespace.oid
				WHERE t_namespace.nspname = current_schema() and typname = 'byte4address') = false)
	THEN
		CREATE TYPE byte4address (
			input = byte4address_in,
			output = byte4address_out,
			internallength = 4, passedbyvalue,	-- passedbyvalue is used because byte4address_constructor return result by value
			alignment = int4
		);
	END IF;
END $$;

-- This function is used instead byte4address_in
CREATE OR REPLACE FUNCTION make_byte4address(smallint, smallint, smallint, smallint)
	RETURNS byte4address
	AS '$libdir/byte4address', 'byte4address_constructor'
	LANGUAGE C IMMUTABLE STRICT;

-- We need this function, because postgres doesn't perform implicit cast
CREATE OR REPLACE FUNCTION make_byte4address(integer, integer, integer, integer)
	RETURNS byte4address
	AS $$ select make_byte4address($1::smallint, $2::smallint, $3::smallint, $4::smallint) $$
	LANGUAGE sql IMMUTABLE STRICT;