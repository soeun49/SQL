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
SELECT first_name, salary FROM employees WHERE first_name LIKE '___a%';
--이름이 4글자인 사원 중에서 끝에서 두번째 글자가 a인 사원의 이름을 출력 
SELECT first_name, salary FROM employees WHERE first_name LIKE '__a_';

--ORDER BY 절 이용 
--ASC: 오름차순; DESC: 내림차순 -> 뒤에 붙인다(!)
--부서 번호를 오름차순으로 정렬하고 부서 번호, 급여, 이름을 출력
SELECT department_id, salary, first_name FROM employees ORDER BY department_id;
-- 급여가 10000이상인 직원의 이름을 급여 내림차순 으로 출력
SELECT first_name, salary FROM employees WHERE salary >=10000 ORDER BY salary DESC; 
-- 부서 번호, 급여, 이름순으로 출력하되 부서번호를 오름차순, 급여를 내림차순으로 출력 
SELECT department_id, salary, first_name FROM employees ORDER BY department_id ASC, salary DESC;


-------------------------------------
--단일행 함수: 레코드를 입력으로 받음 

-- 문자열 단일행 함수
SELECT first_name, last_name,
    CONCAT(first_name, CONCAT (' ', last_name)), -- 문자열 결합 
    INITCAP(first_name || ' ' || last_name), --첫 글자를 대문자로
    LOWER (first_name),-- 모두 소문자
    UPPER (first_name), -- 모두 대문자 
    LPAD(first_name, 20, '*'), --20자리 확보, 왼쪽을 *로 채움
    RPAD (first_name, 20, '*')-- 20자리 확보 오른쪽을 *로 채움 
FROM employees; 

SELECT '   oracle   ',
    '******Database******'
FROM dual;

SELECT LTRIM ('    Oracle   '), --왼쪽의 공백 제거
    RTRIM ('    Oracle   '), --오른쪽의 공백 제거
    TRIM ('*'FROM'***********Database**********'),--양쪽의 지정된 문자 제거
    SUBSTR ('Oracle Database',8,4), --8번째 글자부터 4글자만 출력 
    SUBSTR ('Oracle Database',-8,-4) --뒤에서 8번째 글자부터 4글자만 출력 
    FROM dual;
    
--수치형 단일행 함수
SELECT ABS (-3.14), --절대 값
    CEIL (3.14),-- 소숫점 올림 
    FLOOR (3.14), -- 소숫점 버림
    MOD (7,3), -- 7을 3으로 나눈 나머지
    POWER (2,4), -- 제곱
    ROUND (3.5), -- 반올림
    ROUND (3.4567, 2),-- 소숫점 두번째 자리까지 반올림으로 변환 (소숫점 두자리까지 표시)
    TRUNC (3.5), --소숫점 아래 버림 
    TRUNC (3.4567,2) -- 소숫점 두번째 자리까지 버림 (소숫점 두자리까지 표시)
FROM dual; 
    
    
--날짜형 단일행 함수
--날짜 형식 확인 
SELECT * FROM nls_session_parameters -- nls: national language setting
WHERE parameter = 'NLS_DATE_FORMAT';

--현재 날짜와 시간 확인
SELECT sysdate FROM dual; -- dual 가상 테이블로부터 확인 -> 단일행
SELECT sysdate FROM employees; -- 테이블의 레코드 수만큼 행이 인출됨 

-- DATE 관련 함수
SELECT sysdate, -- 현재 날짜와 시간 
    ADD_MONTHS (sysdate, 2), -- 2개월 후의 날짜 
    MONTHS_BETWEEN ('99/12/31', sysdate), -- 1999년 12월 31일 부터 현재의 달수 
    NEXT_DAY (sysdate, 7), -- 현재 날짜 이후의 첫번째 7요일 -> 7요일=토요일 
    ROUND (TO_DATE('21/05/17'), 'MONTH'), -- MONTH정보로 반올림 
    TRUNC(TO_DATE('2021-05-17', 'YYYY-MM-DD'), 'MONTH') -- MONTH 정보로 버림 
FROM  dual;

--현재 날짜 기준, 입사한지 몇개월 지났는가?
SELECT first_name, hire_date, ROUND(MONTHS_BETWEEN (sysdate,hire_date))
FROM employees;


--변환 함수
--TO_NUMBER (s, frm): 문자열 -> 숫자형
--TO_DATE (s, frm): 문자열 -> 날짜형
--TO_CHAR(s, frm): 숫자, 날짜 -> 문자형

--TO_CHAR
SELECT first_name, hire_date, TO_CHAR (hire_date, 'YYYY-MM-DD HH24:MI:SS')
FROM employees;
--현재 날짜의 포맷을 문자형으로 출력 
SELECT sysdate, TO_CHAR(sysdate, 'YYYY-MM-DD  HH24:MI:SS')
FROM dual;

--숫자열을 문자열로 
SELECT TO_CHAR(123456789.0123,'999,999,999.99')
FROM dual;
--연봉 정보를 문자열로 
SELECT first_name, TO_CHAR(salary*12, '$999,999.99') SAL 
FROM employees;

--TO_NUMBER: 문자열-> 숫자 
--산술연산이 가능하게 만들어줌 
SELECT TO_NUMBER('1,999','999,999'),TO_NUMBER('$1,350.99','$999,999.99') 
FROM dual;

--TO_DATE: 문자열 -> 날짜
SELECT TO_DATE ('2021-05-05 12:30', 'YYYY-MM-DD HH12:MI')
FROM dual;

--DATE 연산
--DATE + (-) Number : 날짜에 일수를 더한다 (or 뺀다) -> Date
--Date-Date: 날짜에서 날짜를 뺀 일수를 확인할 수 있음 
--Date + Number /24: 날짜에 시간을 더할 때, 시간을 24로 나눈 값을 더한다 (뺀다). 
SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI'),
    sysdate + 1, --1일 후 
    sysdate - 1, -- 1일 전 
    sysdate - TO_DATE('2012-09-24', 'YYYY-MM-DD'), -- 두 날짜의 차이 일수
    TO_CHAR (sysdate + 13/24, 'YY/MM/DD HH24:MI') --13시간 후 
FROM dual;


--기타함수
--NULL 관련 
--nvl 함수
SELECT first_name, salary, salary +(salary*nvl(commission_pct,0)) --commision_pct가 null 이면 0으로 변경
FROM employees;
--nvl2함수
--nvl2(표현식, null이 아닐 경우, null일 경우) \
SELECT first_name, salary, commission_pct, salary + nvl2(commission_pct, salary*commission_pct, 0)
FROM employees;

--CASE 함수
--보너스 지급 : AD관련 20%; SA관련 10%, IT관련 8%; 나머지 5%
SELECT first_name, job_id, salary, SUBSTR(job_id,1,2),  
    CASE SUBSTR(job_id,1,2) WHEN 'AD' THEN salary*0.2
                            WHEN 'SA' THEN salary*0.1
                            WHEN 'IT' THEN salary*0.08
                            ELSE salary*0.05
    END as bonus
FROM employees;

--DECODE 함수 
SELECT first_name, job_id, salary, SUBSTR(job_id,1,2),
    DECODE (SUBSTR(job_id,1,2), 
        'AD', salary*0.2,
        'SA', salary*0.1,
        'IT', salary*0.08,
        salary*0.05) bonus
FROM employees;

--연습문제 
--departmnet_id <=30 -> A group; department_id <=50 -> B group; department_id<=100 -> C group ; 나머지 remainder
SELECT first_name, department_id, 
    CASE WHEN department_id <=30 THEN 'A-GROUP'
        WHEN department_id <=50 THEN 'B-GROUP'
        WHEN department_id <= 100 THEN 'C-GROUP'
        ELSE 'REMAINDER' 
END as team
FROM employees
ORDER BY team;

