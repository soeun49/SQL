
--조인

--#1
--직원들의 employee_id, first_name, last_name, department_name을 조회하여
--department_name 오름차순, employee_id 내림차순으로 정렬 
SELECT employee_id , first_name, last_name, department_name
FROM employees emp JOIN departments dept
                    ON emp.department_id=dept.department_id
ORDER BY department_name ASC, employee_id DESC;

--#2
--employees 테이블의 job_id는 현재의 업무 아이디 
--employee_id, first_name, salary, department_name, job_title 출력
--employee_id 오름차순 

--oracle sql
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp, departments dept, jobs j                   
WHERE emp.department_id = dept.department_id AND emp.job_id=j.job_id                  
ORDER BY employee_id ASC;

--ansi sql
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp JOIN departments dept                   
                  ON emp.department_id = dept.department_id 
                  JOIN jobs j ON emp.job_id=j.job_id
ORDER BY employee_id ASC;


--#2-1
--부서가 없는 Kimberly 사원까지 표시
--oracle sql
SELECT employee_id, first_name, salary, department_name, job_title
FROM  employees emp, departments dept, jobs j                   
WHERE emp.department_id = dept.department_id(+) AND emp.job_id=j.job_id                  
ORDER BY employee_id ASC;

--ansi sql
SELECT employee_id, first_name, salary, department_name, job_title
FROM employees emp LEFT OUTER JOIN departments dept                   
                  ON emp.department_id = dept.department_id 
                  JOIN jobs j 
                  ON emp.job_id=j.job_id
ORDER BY employee_id ASC;


--#3
--도시별로 위치한 부서들을 파악하기
--도시아이디, 도시명, 부서명, 부서아이디
--도시아이디 (오름차순)으로 정렬 
--부서가 없는 도시는 표시 x
SELECT dept.location_id, city, department_name, department_id
FROM departments dept JOIN locations loc
                    ON dept.location_id=loc.location_id
WHERE department_id IS NOT NULL
ORDER BY location_id ASC;

--#3-1
--부서가 없는 도시도 표시
SELECT dept.location_id, city, department_name, department_id
FROM departments dept RIGHT OUTER JOIN locations loc 
                        ON dept.location_id=loc.location_id
ORDER BY location_id ASC;


--#4
--regions에 속한 나라들을 region_name, country_name으로 출력
--지역이름 (오름차순), 나라이름 (내림차순)으로 정렬 
SELECT region_name, country_name
FROM regions reg JOIN countries con 
                    ON reg.region_id = con.region_id
ORDER BY region_name ASC, country_name DESC;


--#5

