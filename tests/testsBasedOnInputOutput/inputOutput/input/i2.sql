create table t2 (first_column byte4address);

insert into t2 (first_column)
VALUES (make_byte4address(12, 5, 13, 2)),
				(make_byte4address(10, 16, 0, 1));

\pset format unaligned
\pset tuples_only
select * from t2;