proc sql;
create table employees_from_C_countries as
	select e.first_name, e.last_name, c.name
	from work.employees as e inner join work.countries as c
	on e.country_code=c.code
	where c.name like "C%";
quit;

proc freq data=work.employees_from_c_countries order=freq;
	table Name / nocum out=number_of_emp_from_C_countries;
run;