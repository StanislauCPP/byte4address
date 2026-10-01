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

CREATE OR REPLACE FUNCTION byte4address_comparision_less(byte4address, byte4address)
	RETURNS bool
	AS '$libdir/byte4address', 'byte4address_comparision_less'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_comparision_greater(byte4address, byte4address)
	RETURNS bool
	AS '$libdir/byte4address', 'byte4address_comparision_greater'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_comparision_lessequal(byte4address, byte4address)
	RETURNS bool
	AS '$libdir/byte4address', 'byte4address_comparision_lessequal'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_comparision_greaterequal(byte4address, byte4address)
	RETURNS bool
	AS '$libdir/byte4address', 'byte4address_comparision_greaterequal'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_comparision_equal(byte4address, byte4address)
	RETURNS bool
	AS '$libdir/byte4address', 'byte4address_comparision_equal'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION byte4address_comparision_for_index(byte4address, byte4address)
	RETURNS integer
	AS '$libdir/byte4address', 'byte4address_comparision_for_index'
	LANGUAGE C IMMUTABLE STRICT;

DO $$
BEGIN
	if not exists(select 1 from pg_operator op
									JOIN pg_type ltype ON op.oprleft = ltype.oid
									JOIN pg_type rtype ON op.oprright = rtype.oid
									JOIN pg_catalog.pg_namespace t_namespace ON op.oprnamespace = t_namespace.oid
									WHERE ltype.typname = 'byte4address' and rtype.typname = 'byte4address'
										and t_namespace.nspname = current_schema())
	then
		CREATE OPERATOR < (
			leftarg = byte4address,
			rightarg = byte4address,
			function = byte4address_comparision_less,
			COMMUTATOR = >,
			NEGATOR = >=,
			RESTRICT = scalarltsel,
			JOIN = scalarltjoinsel
		);

		CREATE OPERATOR > (
			leftarg = byte4address,
			rightarg = byte4address,
			function = byte4address_comparision_greater,
			COMMUTATOR = <,
			NEGATOR = <=,
			RESTRICT = scalargtsel,
			JOIN = scalargtjoinsel
		);

		CREATE OPERATOR <= (
			leftarg = byte4address,
			rightarg = byte4address,
			function = byte4address_comparision_lessequal,
			COMMUTATOR = >=,
			NEGATOR = >,
			RESTRICT = scalarlesel,
			JOIN = scalarlejoinsel
		);

		CREATE OPERATOR >= (
			leftarg = byte4address,
			rightarg = byte4address,
			function = byte4address_comparision_greaterequal,
			COMMUTATOR = <=,
			NEGATOR = <,
			RESTRICT = scalargesel,
			JOIN = scalargejoinsel
		);

		CREATE OPERATOR = (
			leftarg = byte4address,
			rightarg = byte4address,
			function = byte4address_comparision_equal,
			COMMUTATOR = =,
			NEGATOR = <>,
			RESTRICT = eqsel,
			JOIN = eqjoinsel
		);

		CREATE OPERATOR CLASS byte4address_operators
		DEFAULT FOR TYPE byte4address USING btree AS
			OPERATOR	1	< ,
			OPERATOR	2	<= ,
			OPERATOR	3	= ,
			OPERATOR	4	>= ,
			OPERATOR	5	> ,
			FUNCTION	1	byte4address_comparision_for_index(byte4address, byte4address);
	end if;
END $$;