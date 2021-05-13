--#1
--이름 (first_name, last_name), 월급 (salary), 전화번호 (phone_number), 입사일(hire_date)를 
--이름, 월급, 전화번호, 입사일 로 이름을 대체하고 입사일의 올림차순으로 출력 
SELECT first_name ||' '|| last_name "이름", salary "월급", phone_number "전화번호", hire_date "입사일"
FROM employees
ORDER BY hire_date ASC;

--#2
--업무(jobs) 별로 업무 이름(job_title)과  최고 월급(max_salary)을 월급의 내림 차순으로 정렬
SELECT job_title, max_salary 
FROM jobs
ORDER BY max_salary DESC;

--#3
--담당매니저가 배정되어 있으나, 커미션 비율이 없고, 
--월급이 3000초과인 직원의 이름, 매니저 아이디, 커미션 비율, 월급을 출력 
SELECT first_name, manager_id, commission_pct, salary 
FROM employees 
WHERE salary >3000 and commission_pct is null and manager_id is not null; 

--#4
--최고 월급(max_salary)이 10000이상인 업무의 이름(job_title)과 최고월급(max_salary)을 
--최고 월급(max_salary)의 내림차순으로 정렬
SELECT job_title, max_salary 
FROM jobs 
WHERE max_salary >=10000
ORDER BY max_salary DESC;

--#5
--월급이 14000미만 10000이상인 직원의 이름, 월급, 커미션 퍼센트를 월급순(내림차순)으로 출력
--단, 커미션 퍼센트가 null 이면 0으로
SELECT first_name, salary, nvl (commission_pct,0)
FROM employees WHERE salary >=10000 and salary <14000;

--#6 
--부서 번호가 10,90,100인 직원의 이름, 월급, 입사일, 부서번호를 출력 
--입사일은 1977-12로 표시
SELECT first_name, salary, hire_date as "1977-12", department_id
FROM employees 
WHERE department_id IN(10,90,100);

--#7
--이름 (first_name)에 S 또는 s가 들어가는 직원의 이름, 월급을 출력
SELECT first_name, salary FROM employees WHERE first_name like '%s%' or first_name like 'S%';


