--혼합

--#1
-- 담당 매니저가 배정되어 있으나, 커미션 비율이 없고, 월급이 3000초과인 직원의 이름, 매니저 아이디, 커미션 비율, 월급을 출력

SELECT first_name, manager_id, commission_pct, salary 
FROM employees 
WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary> 3000;

--#2
-- 각 부서 별로 최고의 급여를 받는 사원의 employee_id, first_name, salary, hire_date, phone_number, department_id  조회
-- 조건절 비교 방법으로 작성
-- 급여의 내림차순
-- 입사일은 0000-00-00 0요일 형식으로 출력
-- 전화번호는 000-000-0000 형식으로 출력 

SELECT e.employee_id, e.first_name, e.salary, to_char(hire_date,'YYYY-MM-DD day') hire_date, replace (phone_number, '.', '-') phone_number, e.department_id
FROM employees e
WHERE (e.department_id, e.salary) IN (SELECT department_id, max(salary) FROM employees GROUP BY department_id)
ORDER BY salary DESC;


--#3
--매니저 별로 평균급여, 최소급여, 최대 급여 출력
-- 2005년 이후 입사자
-- 평균 급여가 5000이상
-- 평균급여의 내림차순으로 출력
-- 평균급여는 소수점 첫째자리에서 반올림 
-- 매니저아이디,  first_name, 평균급여, 최소급여, 최대급여

SELECT e.manager_id, m.first_name, e.avgSalary, e.minSalary, e.maxSalary
FROM employees m, ( SELECT manager_id, ROUND (AVG(salary),0) avgSalary, MIN(salary) minSalary, Max(salary) maxSalary
FROM employees WHERE hire_date > '05/01/01' 
GROUP BY manager_id HAVING AVG(salary) >=5000 
ORDER BY AVG(salary) desc) e
WHERE m.employee_id= e.manager_id
ORDER BY avgSalary DESC;


--#4
-- 각 사원에 대해서  employee_id, first_name, department_name, manager의 first_name
-- 부서가 없는  직원도 표시
SELECT e.employee_id "사번", e.first_name "이름", d.department_name "부서명", m.first_name "매니저의 이름"
FROM employees e , departments d, employees m
    WHERE e.manager_id= m.employee_id AND e.department_id= d.department_id (+);

-- #5 
--2005년 이후 입사한 직원 중에서 입사일이 11번째에서 20번째 직원의 
-- 사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력

SELECT rn, employee_id, first_name, salary, hire_date
FROM (SELECT rownum rn, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date FROM employees WHERE hire_date>'05/01/01' ORDER BY hire_date ASC))
WHERE rn>=11 AND rn<=20;

--#6
--가장 늦게 입사한 직원의 이름 first_name, last_name, salary, department_name 출력
SELECT e.first_name, e.last_name, e.salary, d.department_name
FROM employees e, departments d
WHERE e.department_id=d.department_id 
AND e.hire_date =(SELECT MAX(hire_date) FROM employees);

--#7 
--평균 연봉이 가장 높은 부서 직원들의 
--employee_id (사번), first_name, (이름) last_name (성), job_title (업무),  salary (연봉), avg_salary 조회

SELECT e.employee_id "사번", e.first_name "이름" , e.last_name "성", j.job_title "업무" , salary "연봉", t.avgSalary "평균연봉" 
FROM employees e, jobs j, (SELECT department_id, AVG(salary) avgSalary FROM employees GROUP BY department_id)t
WHERE e.department_id=t.department_id 
AND e.job_id=j.job_id 
AND t.avgSalary = (SELECT max (AVG(salary)) avgSalary FROM employees GROUP BY department_id);   

--#8
--평균 급여가 가장 높은 부서?(department_name)

--1)
SELECT d.department_name
FROM departments d, (SELECT department_id, AVG(salary) avgSalary FROM employees GROUP BY department_id) t
WHERE d.department_id=t.department_id
AND t.avgSalary = (SELECT max(AVG(salary)) avgSalary FROM employees GROUP BY department_id);

--2)
select department_name
from departments
where department_id = ( select department_id
                        from employees
                        group by department_id
                        having avg(salary) = (select max(avg(salary))
                                              from employees
                                              group by department_id));
--#9
--평균 급여가 가장 높은 지역은? (region_name)
SELECT region_name
FROM regions r
WHERE region_id=
(SELECT r.region_id FROM regions r, employees e, departments d, locations l, countries c
WHERE e.department_id=d.department_id AND d.location_id=l.location_id
AND l.country_id=c.country_id AND c.region_id=r.region_id
GROUP BY r.region_id 
HAVING avg(salary) = (SELECT max(avg(salary)) 
FROM employees e, departments d, locations l, countries c, regions r
WHERE  e.department_id=d.department_id AND d.location_id=l.location_id
AND l.country_id=c.country_id AND c.region_id=r.region_id
GROUP BY r.region_id));

--#10
--평균 급여가 가장 높은 업무는? (job_title)
SELECT job_title 
FROM jobs
WHERE job_id= (SELECT job_id FROM employees GROUP BY job_id
HAVING avg(salary) = (SELECT max(AVG(salary)) FROM employees GROUP BY job_id));
