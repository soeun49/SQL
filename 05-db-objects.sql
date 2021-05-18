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



--view 확인을 위한 Dictionary
SELECT*FROM USER_VIEWS; --view에 관한 정보 확인
-- 특정 view의 정보 확인을 위해 WHERE 절에 View_name을 지정하면 된다
SELECT view_name, text FROM USER_VIEWS 
WHERE view_name='BOOK_DETAIL';

-- USER_OBJECTS 테이블을 이용한 확인
SELECT * FROM USER_OBJECTS;

SELECT * FROM USER_OBJECTS 
WHERE object_type='VIEW';  --(SELECT*FROM USER_VIEWS)

--view의 삭제
DROP VIEW book_detail;

SELECT*FROM USER_VIEWS;


------------
--INDEX: 검색 속도 개선을 위한 데이터베이스 객체 
--hr.employees의 테이블을 기반으로 새로운 테이블 s_emp생성
CREATE TABLE s_emp 
AS SELECT * FROM hr.employees ;

-- s_emp테이블의 employee_id컬럼에 UNIQUE INDEX를 생성
SELECT * FROM s_emp;
CREATE UNIQUE INDEX s_emp_id_pk
ON s_emp (employee_id); -- s_emp 테이블의 employee_id컬럼에 unique index 부여

--사용자가 가지고 있는 인덱스 확인
SELECT * FROM USER_INDEXES;

-- 어느 컬럼에 인덱스가 걸려 있는지 확인
SELECT * FROM USER_IND_COLUMNS;

--두 테이블을 조인, 어느 인덱스가 어느 컬럼에 걸려 있는지 확인
SELECT t.index_name, t.table_name, c.column_name, c.column_position FROM USER_INDEXES t, USER_IND_COLUMNS c
WHERE t.index_name = c.index_name AND t.table_name= 'S_EMP';


--INDEX는 
--WHERE 절, JOIN절에 빈번하게 사용되는 컬럼
-- 자주 업데이트가 되는 테이블의 경우, 인덱스를 계속 갱신해야 함 
-- > 인덱스가 DB 성능을 저하시킬 수도 있음 
--> 꼭 필요한 컬럼에만 인덱스 부여 권장 

-- INDEX의 제거
DROP INDEX s_emp_id_pk;
SELECT * FROM USER_INDEXES; -- 제거 확인


-- SEQUENCE
-- author 테이블에 새 레코드 삽입
DESC author;
SELECT * FROM author;

--author.author_id max 확인
SELECT MAX (author_id) FROM author;

-- 새로운 author 추가
INSERT INTO author (author_id, author_name) 
VALUES ((SELECT MAX(author_id) + 1 FROM author), 'Unknown');

SELECT* FROM author;

--유일한 PK를 확보해야 할 경우, 위 방법은 안전하지 않을 수 있다
-- SEQUENCE를 이용, 유일한 정수 값을 확보

ROLLBACK;

--시퀀스 생성
SELECT MAX (author_id) + 1 FROM author;

CREATE SEQUENCE seq_author_id
START WITH 3   
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000000
NOCACHE;

-- 시퀀스 이용한 OK의 부여
INSERT INTO author(author_id, author_name)
VALUES ((seq_author_id.NEXTVAL), 'Steven King');

SELECT* FROM author;

--새로운 시퀀스 하나 생성
CREATE SEQUENCE my_seq
START WITH 1 
INCREMENT BY 1
MAXVALUE 10 
NOCACHE;

--새 시퀀스 생성
SELECT my_seq.NEXTVAL FROM dual; -- 시퀀스 증가시키고 반환
SELECT my_seq.CURRVAL FROM dual; -- 시퀀스의 현재 값

--시퀀스 수정 
ALTER SEQUENCE my_seq
INCREMENT BY 2
MAXVALUE 10000;

SELECT my_seq.NEXTVAL FROM dual;
SELECT my_seq.CURRVAL FROM dual;


--시퀀스를 위한 Dictionary
SELECT * FROM USER_SEQUENCES;

SELECT* FROM USER_OBJECTS WHERE object_type= 'SEQUENCE';


-- book_id를 위한 시퀀스도 추가해보자
SELECT MAX(book_id) FROM book;

-- 시퀀스 생성
CREATE SEQUENCE seq_book_id 
START WITH 3
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000;

SELECT*FROM USER_SEQUENCES;