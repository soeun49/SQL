-- 커미션을 받는 직원들의  last_name, salary, department_name 출력 
SELECT e.last_name, e.salary, d.department_name 
FROM employees e, departments d
WHERE commission_pct IS NOT NULL 
AND e.department_id=d.department_id(+);

--last_name이 King인 사람을 매니저로 둔 직원들의 last_name, salary, job_id 출력
SELECT last_name, salary, job_id
FROM employees e, (SELECT employee_id FROM employees Where last_name = 'King') m
WHERE e.manager_id = m.employee_id;


--자신의 매니저보다 많은 급여를 받고 있는 직원들의 last_name, salary 출력
SELECT e.last_name, e.salary 
FROM employees e, (SELECT employee_id, salary FROM employees) m
WHERE e.manager_id=m.employee_id
AND e.salary>m.salary;

-- 사원 전체 대상으로 최소급여, 최대 급여, 급여의 합, 평균 급여 출력
-- 평균급여는 소수점 아래 자리를 반올림 
SELECT MIN(salary) MIN, MAX(salary) MAX, SUM(salary) SUM, ROUND(AVG(salary),0) AVERAGE 
FROM employees;

--소속 부서의 평균 급여보다 적게 버는 직원의 last_name, salary 출력
SELECT e.last_name, e.salary 
FROM employees e, (SELECT department_id, AVG(salary) salary From employees GROUP BY department_id ) t
WHERE e.department_id=t.department_id
AND t.salary > e.salary;

