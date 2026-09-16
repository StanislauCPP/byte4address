create table t1 (first_column byte4address);

insert into t1 (first_column)
VALUES (make_byte4address(4, 7, 13, 2)),
				(make_byte4address(10, 5, 3, 1));

\pset format unaligned
\pset tuples_only
select * from t1;