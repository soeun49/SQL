----------------------------------------
--DB objects
---------------------------------------

-- System계정으로 CREATE VIEW 권한을 부여 
GRANT CREATE VIEW TO C##KSE;

-- 사용자 계정으로 복귀

-- Simple View: 단일 테이블, 함수나 연산식이 포함한 컬럼이 없는 단순 뷰
DROP TABLE emp123;
CREATE TABLE emp123 
    AS SELECT*FROM hr.employees 
    WHERE department_id IN (10,20,30);

SELECT *FROM emp123;

--emp123 테이블을 기반으로 department_id가 30번인 사람들만 보여주는 view를 생성

CREATE OR REPLACE VIEW emp10 
    AS SELECT employee_id, first_name, last_name, salary, 
        FROM emp123
        WHERE department_id=10;
        
DESC emp10;

-- view는 테이블 처럼 SELECT 할 수있다
-- 다만 실제 데이터는 원본 테이블 내에 있는 데이터 활용
SELECT*FROM emp10;
SELECT first_name || ' ' || last_name, salary FROM emp10;

-- Simple View 는 제약 사항에 위반되지 않는다면 내용을 갱신할 수 있음 
--salary를 2배로 올려보자
SELECT first_name, salary FROM emp123;

UPDATE emp10 SET salary= salary*2;
SELECT first_name, salary FROM emp10;
SELECT first_name, salary FROM emp123;

--VIEW는 가급적 조회용으로만 사용하도록 하자
-- READ ONLY option을 부여하여 view 생성

ROLLBACk;

CREATE OR REPLACE VIEW emp10 
AS SELECT employee_id, first_name,last_name, salary
FROM emp123  
WHERE department_id=10
With READ ONLY;

SELECT*FROM emp10;

UPDATE emp10 SET salary= salary*2; --읽기 전용 뷰에서는 DML 수행 불가 

--복합 뷰
DESC author;
DESC book;
--author 와 book을 조인하여 정보를 출력하는 복합 뷰를 생성

CREATE OR REPLACE VIEW book_detail
(book_id, title, author_name, pub_date) 
AS SELECT book_id, title, author_name, pub_date 
FROM book b, author a
WHERE b.author_id = a.author_id;

DESC book_detail;
SELECT *FROM book_detail;

UPDATE book_detail SET author_name= 'unknown';
--복합 뷰에서는 기본적으로 DML 작업이 불가능함 












