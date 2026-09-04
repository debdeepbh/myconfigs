# SQL on linux

### Setup

- Install

```
sudo apt install mysql-server
```

- Check installation

```
mysql --version
```

- Start as sudo

```
sudo mysql
```

- Exit

```
exit;
```


### Usage

- General
	- Nothing is case sensitive, except quoted strings

- Show databases

```
show databases;
```

- Create database

```
create database mydatabase;
```

- Select database

```
use mydatabase;
```

- Create table `person` in the currently selected database with columns `Id, Firstname, Lastname` with datatype and length

```
create table person (Id int(10) not null, Firstname varchar(10), Lastname varchar(10) );
```

### Import/export databases

- Import

```
sudo mysql -u <username> -p <database> < /path/to/database.sql
```

- Export with `mysqldump`

```
sudo mysqldump -u <username> -p <database> > /path/to/database.sql
```

### Read/write

- Operations
    - C (create)	: `insert into <tablename> (col1, col2, col3) values (data1, data2, data3)`
    - R (read)		: `select * from <tablename> where ...`
    - U (update)	: `update <tablename> set <colname>=<value> where ...`
    - D (delete)	: `delete from <tablename> where ...`

- Insert data into table

```
insert into person (Id, Firstname, Lastname) values (1, 'Richard', 'Winters');
```

- Read

```
select * from person;
```

	- Read selectively

	```
	select * from person where Id=1;
	select * from person where id = 1;
	select * from person where Firstname = 'Richard';
	select * from person where firstname='richard';
	```

- Update data

```
update person set Lastname = 'Clark' where Firstname = 'Richard';
```

- Delete data

```
delete from person where Id = 1;
```


