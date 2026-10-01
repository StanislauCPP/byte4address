\pset format unaligned
\pset tuples_only
create table t2 (first_column byte4address primary key);

insert into t2 (first_column)
VALUES (make_byte4address(15, 7, 10, 2)),
				(make_byte4address(100, 65, 3, 1)),
				(make_byte4address(41, 5, 8, 2)),
				(make_byte4address(100, 5, 4, 7)),
				(make_byte4address(16, 1, 1, 7)),
				(make_byte4address(2, 100, 117, 4)),
				(make_byte4address(100, 225, 1, 3)),
				(make_byte4address(7, 5, 4, 1));


select first_column from t2 order by first_column;