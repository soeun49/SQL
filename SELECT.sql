--계정 내의 테이블 확인
--SQL은 대소문자 구분하지 않음 
SELECT * From tab;

--테이블의 구조 확인
DESC employees;

----
--SELECT ~ FROM
--가장 기본적인 SELECT: 전체 데이터 조회
SELECT * FROM employees; -- employees table 안의 모든 column 을 불러옴
SELECT * FROM departments;

--테이블 내에서 정의된 컬럼의 순서대로 출력됨 

-- 특정 컬럼만 선별적으로 Projections
-- 모든 사원의 first_name, 입사일, 급여 출력
SELECT first_name, hire_date, salary
FROM employees;

--기본적인 산술 연산
--산술식 자체가 특정 테이블에 소속된 것이 아닐때: dual - 가상 테이블
SELECT 10+20 FROM  dual;
--특정 컬럼 값을 수치로 산술 계산 할 수 있음
--직원들의 연봉 salary*12
SELECT first_name, salary, salary*12 FROM employees;

--
SELECT first_name, job_id *12 FROM employees; -- ERROR! 
--job_id는 문자열 = 산술 연산 불가

--연습

--employees table: first_name, phone_number, hire_date, salary 출력
SELECT first_name, phone_number, hire_date, salary FROM employees;
--사원의 first_name, last_name, salary, phone_number,hire_date 출력
SELECT first_name, last_name, salary, phone_number,hire_date FROM employees;


--문자열의 연결
SELECT first_name|| ' ' || last_name FROM employees;

SELECT first_name,salary,commission_pct FROM employees;
-- 커미션 포함 실질 급여를 출력 해보자

-- IMP: 산술 연산 식에 null이 포함되어 있으면 결과는 항상 NULL
--그러므로: nvl (expr1, expr2): expr1 이 null이면 expr2를 선택
SELECT first_name, salary, commission_pct,salary+salary*nvl(commission_pct,0) 
FROM employees;

--Alias (별칭)
--별칭 내에 공백 혹은 특수문자가 포함될 경우, " " 로 구분한다. 
--필드 표시명은 일반적으로 한글 등은 쓰지 말자
SELECT first_name 이름, last_name as 성, first_name || ' ' ||last_name "Full Name" FROM employees;


--WHERE 절 
--특정 조건을 기준으로 레코드를 선택 (Selection)

--급여가 15000이상인 사원의 이름과 연봉 
SELECT first_name, salary *12 "Annual Salary" FROM employees WHERE salary >=15000;
--07/01/01 이후 입사한 사원의 이름과 입사일
SELECT  first_name, hire_date FROM employees WHERE hire_date >='07/01/01';
--이름이 'Lex'인 사원의 연봉, 입사일, 부서 id
SELECT first_name, salary *12 "Annual Salary", hire_date, department_id FROM employees 
WHERE first_name= 'Lex';
--부서 아이디가 10인 사람의 명단
SELECT * FROM employees WHERE department_id=10;

--논리연산자: 조건이 2개 이상일 떄
--급여가 14000이하이거나 17000이상인 사원의 이름과 급여
SELECT first_name,salary FROM employees WHERE salary <=14000 or salary >=17000;
--부서 id가 90인 사원 중, 급여가 20000이상인 사원
SELECT first_name,salary,department_id FROM employees WHERE department_id=90 and salary >=20000;

--BETWEEN 연습
--입사일이 07/01/01~07/12/31구간에 있는 사원의 목록
SELECT first_name, hire_date FROM employees WHERE hire_date between '07/01/01' and '07/12/31';

--IN 연습
--부서 id가 10,20,40인 사원의 명단 목록
--비교, 논리 연산자 활용
SELECT first_name,department_id FROM employees WHERE department_id=10 or department_id=20 or department_id=40;
--IN활용
SELECT first_name, department_id FROM employees WHERE department_id IN(10,20,40);
--Manager id가 100,120,147인 사원의 명단 목록
--비교, 논리연산자 활요
SELECT first_name, manager_id FROM employees WHERE manager_id=100 or manager_id=120 or manager_id=147; 
--IN 활용
SELECT first_name,manager_id FROM employees WHERE manager_id IN(100,120,147);

--LIKE 연습
--이름에 am을 포함한 사원의 이름과 급여를 출력
SELECT first_name, salary FROM employees WHERE first_name LIKE '%am%'; 
--이름의 두번째 글자가 a인 사람의 이름과 급여를 출력
SELECT first_name, salary FROM employees WHERE first_name LIKE '_a%';
--이름의 네번째 글자가 a인 사람의 이름을 출력
SELECT first_name FROM employees WHERE first_name LIKE '___a%';
--이름이 4글자인 사원 중에서 끝에서 두번째 글자가 a인 사원의 이름을 출력 
SELECT first_name FROM employees WHERE first_name LIKE '__a_';

