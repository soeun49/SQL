--practice for JDBC
SELECT e.first_name, e.last_name, m.first_name || ' '||  m.last_name as ManagerName
FROM employees e LEFT OUTER JOIN employees m
ON e.manager_id=m.employee_id
ORDER BY e.first_name DESC;


-- 집계

--#1
--매니저가 있는 직원은 몇명? - define as "haveMngCnt"
SELECT count(manager_id) "haveMngCnt"
FROM employees 
WHERE manager_id is not null;

--#2
--직원 중에서 최고 임금과 최저 임금을 "최고 임금", "최저 임금" 프로젝션 타이틀로 함계 출력
-- 두 임금의 차이? ("최고 임금- 최저임금")이라는 타이틀로 함께 출력
SELECT min(salary) "최저 임금", max(salary) "최고 임금", (max(salary)-min(salary)) "최고임금-최저임금"
FROM employees;


-- #3 
-- 마지막으로 신입사원이 들어온 날은 언제?
-- 0000년 00월 00일 형식으로 출력
SELECT TO_CHAR(max(hire_date),'YYYY"년"MM"월"DD"일"') FROM employees;


-- #4
--부서별로 평균 임금, 최고 임금, 최저 임금을 부서아이디 (department_id)와 함께 출력
--정렬 순서는 부서번호 내림차순
SELECT ROUND(AVG(salary),2) "평균 임금", MAX(salary) "최고 임금", MIN(salary) "최저 임금", department_id 
FROM employees 
GROUP BY department_id
ORDER BY department_id DESC;
--#5
--업무 (job_id)별로 평균임금, 최고 임금, 최저임금을 업무아이디 (job_id)와 함께 출력
-- 정렬 순서: 최저임금 내림차순, 평균임금 (소숫점 반올림) 오름차순
SELECT job_id, ROUND(avg(salary),0) "평균 임금", max(salary) "최고 임금", 
min(salary) "최저 임금"
FROM employees 
GROUP BY job_id
ORDER BY MIN(Salary) DESC, AVG(salary) ASC;


--#6
--가장 오래 근속한 직원의 입사일은?
-- 0000-00-00 0요일 형식으로 출력

SELECT TO_CHAR(min(hire_date), 'yyyy-mm-dd day')
FROM employees;


--#7
-- 평균임금과 최저 임금의 차이가 2000미만인 부서 (department_id), 평균임금, 최저임금, (평균임금-최저임금) 출력
-- (평균임금-최저임금) 의 내림차순으로 정렬

SELECT department_id, avg(salary) "평균임금", min(salary) "최저임금", (avg(salary)-min(salary)) "평균임금-최저임금"
FROM employees 
GROUP BY department_id
HAVING (avg(salary)-min(salary)) <2000
ORDER BY (avg(salary)-min(salary)) DESC;

--#8
-- 업무(jobs)별로 최고 임금과 최저 임금의 차이를 출력
-- 차이를 확인 할 수 있도록 내림차순으로 정렬
SELECT job_id, max(salary) - min(salary) as diff_sal
FROM employees
GROUP BY job_id
ORDER BY diff_sal DESC;


--#9
-- 2005년 이후 입사자 중 관리자 별로 평균급여, 최소급여, 최대급여를 알아보고자 함 
-- 관리자 별로 평균 급여가 5000이상 중에 평균급여, 최소급여, 최대급여 출력
-- 평균급여의 내림 차순으로 정렬; 평균 급여는 소수점 첫째자리에서 반올림 하여 출력

SELECT manager_id, ROUND(AVG(salary),0) "평균급여", min(salary) "최소급여", max(salary) "최대급여"
FROM employees
WHERE hire_date > '05/01/01'
GROUP BY manager_id 
HAVING AVG(salary)>=5000
ORDER BY AVG(salary) DESC;
