USE employees;

# SELECT * FROM employees;
# SELECT * FROM salaries;
# SELECT * FROM dept_emp;

# Task 1
SELECT employees.emp_no AS `Employee number`, employees.first_name AS `First name`,
		employees.last_name AS `Last name`, employees.hire_date AS `Hire date`
FROM employees
WHERE employees.gender = 'M' AND
		employees.hire_date BETWEEN '1990-01-01' AND '1995-12-31'
ORDER BY `Employee number` ASC;

# Task 2
SELECT *
FROM employees
WHERE employees.hire_date =
		(SELECT MIN(employees.hire_date) FROM employees)
ORDER BY employees.emp_no;

# Task 3
SELECT employees.gender, COUNT(*) AS `Number of Employees`
FROM employees
WHERE employees.gender = 'F'
GROUP BY employees.gender;

# Task 4
SELECT employees.emp_no AS `Employee number`, employees.first_name AS `First name`,
		employees.last_name AS `Last name`, MAX(salaries.salary) AS `Salary`
FROM employees
JOIN salaries ON employees.emp_no=salaries.emp_no
GROUP BY `Employee number`
ORDER BY `Salary` DESC
LIMIT 10;

# Task 5
SELECT employees.emp_no AS `Employee number`, employees.first_name AS `First name`,
		employees.last_name AS `Last name`, AVG((salaries.salary)) AS `Salary`
FROM employees
LEFT JOIN salaries ON employees.emp_no=salaries.emp_no
GROUP BY salaries.emp_no
ORDER BY `Salary` DESC
LIMIT 10;

# Task 6
SELECT departments.dept_name AS `Department`, 
		COUNT(dept_emp.emp_no) AS `Number of Employees`
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_emp.dept_no
ORDER BY `Number of Employees` DESC
LIMIT 1;