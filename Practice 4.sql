
--서브쿼리 (SUBQUERY)

--#1
--평균 급여보다 적은 급여를 받는 직원은 몇명?
SELECT COUNT(salary)
FROM employees
WHERE salary < (SELECT avg(salary) FROM employees); 

--#2
--평균급여 이상, 최대 급여 이하의 월급을 받는 사원의 직원번호 (employee_id), 이름 (first_name), 급여 (salary) 평균급여, 최대급여
-- 급여의 오름차순으로 정렬하여 출력 

SELECT e.employee_id, e.first_name, e.salary, t.avgSalary, t.maxSalary 
FROM employees e, (SELECT round(avg(salary),0) avgSalary, max(salary) maxSalary FROM employees) t
WHERE e.salary between t.avgSalary AND t.maxSalary
ORDER BY salary ASC;


--#3
--직원 중 Steven King 이 소속된 부서가 있는 곳의 주소를 알아보려고 한다 
--location_id, street_address, postal_code, city, state_province, country_id 출력
SELECT location_id, street_address, postal_code,city,state_province,country_id
FROM locations 
WHERE location_id = (SELECT location_id FROM departments WHERE department_id = (SELECT department_id FROM employees WHERE first_name = 'Steven' and last_name = 'King'));

--#4
--job_id가 'ST_MAN'인 직원의 급여보다 작은 직원의 사번, 이름, 급여 출력
-- 급여의 내림차순
SELECT employee_id, first_name, salary 
FROM employees
WHERE salary < ANY (SELECT salary FROM employees WHERE job_id='ST_MAN');

--#5
--각 부서별로 최고의 급여를 받는 사원의 employee_id, first_name, salary, department_id 조회
--급여의 내림차순
--1)조건절 비교, 2) 테이블 조인 2가지 방법으로 작성

-- 1)조건절 비교
SELECT e.employee_id, e.first_name, e.salary, e.department_id 
FROM employees e
WHERE (e.department_id, e.salary) in (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id) 
ORDER BY salary DESC;

--2)테이블 조인
SELECT e.employee_id, e.first_name, e.salary, e.department_id
FROM employees e, (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) t
WHERE e.department_id=t.department_id
AND e.salary=t.salary
ORDER BY salary DESC;


--#6
--각 업무 별로 연봉의 총합을 함
--연봉 총합이 가장 높은 업무부터 job_title과 연봉총합을 출력
SELECT j.job_title, t.sumSalary, t.job_id, j.job_id
FROM jobs j, (SELECT job_id, sum(salary) sumSalary FROM employees GROUP BY job_id) t
WHERE j.job_id = t.job_id
ORDER BY sumSalary DESC;

--OR
SELECT j.job_title, sum(e.salary) SUM
FROM jobs j, employees e
WHERE j.job_id=e.job_id
GROUP BY j.job_title
ORDER BY SUM DESC;

--#7
--자신의 부서 평균 급여보다 연봉이 많은 직원의 employee_id, first_name, salary  조회
SELECT e.employee_id, e.first_name, e.salary
FROM employees e, (SELECT department_id, avg(salary) salary FROM employees GROUP BY department_id) t
WHERE e.department_id = t.department_id
and e.salary > t.salary;

--#8
-- 직원 입사일이 11번째 부터 15번째의 employee_id, first_name, salary, hire_date
-- hire_date 순으로 출력

SELECT rn, employee_id, first_name, hire_date 
FROM (SELECT rownum rn, employee_id, first_name, salary, hire_date 
FROM (SELECT employee_id, first_name, salary, hire_date FROM employees ORDER BY hire_date ASC))
WHERE  rn>=11 AND rn<=15 ;