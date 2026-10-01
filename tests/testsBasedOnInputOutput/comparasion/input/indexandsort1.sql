\pset format unaligned
\pset tuples_only
create table t1 (first_column byte4address);

insert into t1 (first_column)
VALUES (make_byte4address(4, 7, 13, 2)),
				(make_byte4address(10, 5, 3, 1)),
				(make_byte4address(41, 5, 8, 2)),
				(make_byte4address(7, 5, 4, 1));

CREATE INDEX t1_id_byte4address ON t1 (first_column);

select first_column from t1 order by first_column;