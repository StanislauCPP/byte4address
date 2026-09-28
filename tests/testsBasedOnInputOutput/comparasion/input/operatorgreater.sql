\pset format unaligned
\pset tuples_only
select make_byte4address(4, 7, 13, 2) > make_byte4address(4, 7, 13, 5);
select make_byte4address(4, 7, 13, 5) > make_byte4address(4, 7, 13, 5);
select make_byte4address(10, 7, 13, 5) > make_byte4address(4, 7, 13, 5); 