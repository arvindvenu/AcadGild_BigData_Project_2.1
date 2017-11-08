-- drop project_2.1 database if exists
drop database if exists `project_2.1`;
-- create a new database
create database if not exists `project_2.1`;

-- switch to the database just created
use `project_2.1`;

-- drop and create a table to export the result of task 1
drop table if exists task_1;
create table if not exists task_1
(
	description varchar(200),
	count int
);

-- drop and create a table to export the result of task 2
drop table if exists task_2;
create table if not exists task_2
(
	description varchar(200),
	count int
);

-- drop and create a table to export the result of task 3
drop table if exists task_3;
create table if not exists task_3
(
	company varchar(100) not null primary key,
	complaint_count int
);

-- drop and create a table to export the result of task 4
drop table if exists task_4;
create table if not exists task_4
(
	description varchar(200),
	count int
);


