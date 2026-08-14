create schema if not exists testsch;
create table if not exists testsch.tab_dis_def_input (first_column byte4address);

insert into testsch.tab_dis_def_input (first_column) values ('wadawdaw');

drop schema if exists testsch cascade;