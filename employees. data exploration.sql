select first_name, last_name from employees;

select * from employees;

select * from employees where first_name = 'Denis';

select * from employees where first_name = 'elvis';

select * from employees where first_name = 'Denis' and gender = 'M';

select * from employees where first_name = 'denis' or first_name = 'Kellie' ;

select * from employees where last_name = 'Denis' and (gender = 'M' or gender = 'F');

SELECT * FROM EMPLOYEES WHERE GENDER = 'F' AND (FIRST_NAME = 'KELLIE' OR FIRST_NAME = 'ARUNA');

select * from employees where first_name IN ('Cathie', 'mark', 'nathan');

select * from employees where first_name in ('denis', 'nathan');

select * from employees where first_name not in ('denis', 'mark', 'nathan');

select * from employees where first_name like ('mark%');

select * from employees where hire_date like ('%2000%');


select * from employees where emp_no like ('1000_');

select * from employees where first_name like ('%jack%');

select * from employees where first_name not like ('%jack%');

select * from salaries where salary between '66000' and '70000';

select * from employees where emp_no not between '10004' and '10012';

select * from departments where dept_no  between 'd003' and 'd006';

select * from departments where dept_no is not null;

select * from employees where hire_date >= '2000-01-01' and gender = 'f';

select distinct hire_date from employees;

select count(salary >= 100000) from salaries;

select count(*) from dept_manager;

select * from employees order by hire_date desc;

select salary, count(emp_no) as emps_with_same_salary from salaries where salary>80000 group by salary order by salary; 

select *, avg(salary) from salaries group by emp_no having avg(salary) > 120000;


select first_name, count(first_name) as names_count
from employees
where hire_date > '1999-01-01'
group by first_name 
having count(first_name) < 200
order by first_name desc;


select emp_no, count(emp_no) as names_count
from dept_emp
where from_date > '2000-01-01'
group by emp_no
having count(from_date)>1
order by emp_no;

select * from dept_emp
limit 100;

select count(distinct dept_no) from dept_emp;

select sum(salary) from salaries where from_date > '1997-01-01';

select min(emp_no) from employees;
select max(emp_no) from employees; 

select avg(salary) from salaries where from_date > '1997-01-01';

select round(avg(salary)) from salaries where from_date > '1997-01-01';


DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup
(dept_no CHAR(4) NULL, dept_name VARCHAR(40) NULL);

INSERT INTO departments_dup
(dept_no, dept_name)
SELECT * FROM departments;

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_dup
WHERE dept_no = 'd002'; 

INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');



DROP TABLE IF EXISTS dept_manager_dup;


CREATE TABLE dept_manager_dup (
emp_no int NOT NULL,
dept_no char(4) NULL,
from_date date NOT NULL,
to_date date NULL);

INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES   (999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
inner join departments_dup d on m.dept_no = d.dept_no
order by m.dept_no;

select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m, departments_dup d
where m.dept_no = d.dept_no
order by m.dept_no;

select m.dept_no, e.first_name, e.last_name, e.hire_date
from dept_manager_dup m, employees e
where m.emp_no = e.emp_no
order by m.emp_no;

select e.emp_no, e.first_name, e. last_name, e.hire_date, d.dept_no
from employees  e
inner join dept_manager_dup d on e.emp_no = d.emp_no
order by e.emp_no;


select e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
from employees e 
left join dept_manager_dup d on d.emp_no = e.emp_no
where last_name = 'markovitch'
order by d.dept_no desc, e.emp_no;

SELECT dm.*, d.*
FROM departments d
CROSS JOIN dept_manager dm
WHERE d.dept_no = 'd009'
ORDER BY d.dept_name;

SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d
WHERE e.emp_no < 10011 
ORDER BY e.emp_no, d.dept_name;

select e.first_name, e.last_name, e.hire_date, d.dept_name, t.title, m.from_date
from employees e
join dept_manager m  on e.emp_no = m.emp_no 
join departments d on m.dept_no = d.dept_no
join titles t on e.emp_no = t.emp_no
where t.title = 'manager'
order by e.emp_no;

select d.dept_name, AVG(salary) as average_salary
from departments d
join dept_manager m on d.dept_no = m.dept_no
join salaries s on m.emp_no  = s.emp_no
group by d.dept_name
having average_salary > 60000
order by average_salary desc;

select e.gender, count(dm.dept_no)
from employees e 
join dept_manager dm on e.emp_no = dm.emp_no
group by e.gender;


select e.first_name, e.last_name
from employees e
where e.emp_no in (select dm.emp_no from  dept_manager dm);

select e.first_name, e.last_name, e.hire_date
from employees e
where e.hire_date > 1990-01-01 in (select dm.emp_no from dept_manager dm);

select * from dept_manager
where emp_no in (select emp_no from employees where hire_date between '1990-01-01' AND '1995-01-01');

select * from employees 
where emp_no in (select emp_no from titles where title = 'Assistant Engineer');

select * from employees e 
where exists (select * from titles t where t.emp_no = e.emp_no and title = 'Assistant Engineer');


DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
SELECT
AVG(salary)
FROM
salaries;
END$$
DELIMITER ;

CALL avg_salary;
CALL avg_salary();
CALL employees.avg_salary;


drop procedure select_employees;

use employees;
drop procedure if exists emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
SELECT
e.emp_no
INTO p_emp_no FROM
employees e
WHERE
e.first_name = p_first_name
AND e.last_name = p_last_name;
END$$
DELIMITER ;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;











