---------------
--사용자 관련 
---------------
--SYSTEM 계정으로 수행 
--CREATE (생성), ALTER (수정), DROP (삭제) 키워드

--사용자 생성
CREATE USER C##KSE IDENTIFIED BY 1234;
--사용자 비밀번호 변경 
ALTER USER C##KSE IDENTIFIED BY test;
--사용자의 삭제
DROP USER C##KSE;
--경우에 따라서, 내부에 테이블 등 데이터베이스 객체가 생성된 사용자
DROP USER C##KSE CASCADE; --CASCADE=폭포수

--다시 사용자 생성
CREATE USER C##KSE IDENTIFIED BY 1234;
--SQLPlus로 접속 시도!

--사용자 생성, 권한 부여되지 않으면 아무 일도 할 수 없음

--사용자 정보의 확인
-- USER_USERS: 현재 사용자 관련 정보
-- ALL_USERS: 전체 사용자 정보
--DBA_USERS: 모든 사용자의 상세 정보 (DBA 전용)
DESC USER_USERS;
SELECT *FROM USER_USERS;

DESC ALL_USERS;
SELECT *FROM ALL_USERS;

DESC DBA_USERS;
SELECT *FROM DBA_USERS; 
-- account_status 상태
-- 일정 기간 사용을 안하면  LOCKED으로 바뀜 
-- EXPIRED: 만료 

--사용자 계정에게 로그인 권한 부여 
GRANT create session TO C##KSE ;
--일반적으로 데이터베이스 접속, 테이블 만들어 사용하려면 
--connect, resource 롤을 부여 -> (SYSTEM 권한) 
GRANT connect, resource TO C##KSE;
--ORACLE 12 이상에는 사용자 테이블 스페이스에 공간 부여 필요 
ALTER USER C##KSE DEFAULT TABLESPACE USERS QUOTA unlimited on USERS;

--시스템 권한의 부여: GRANT 권한 (역할)명 TO 사용자;
--시스템 권한의 박탈: REVOKE 권한 (역할)명 FROM 사용자;

--스키마 객체에 대한 권한의 부여: GRANT 권한 ON 객체 TO 사용자;
--스키마 객체에 대한 권한의 박탈: REVOKE 권한 ON 객체 FROM 사용자;

--HR.employees와 hr.departments를 select할 수 있는 권한을 내 사용자에게 부여
--hr.-> 를 붙여 내 계정이 아닌 다른 계정으로 부터의 것임을 구분 
GRANT select ON hr.employees TO C##KSE;
GRANT select ON hr.departments TO C##KSE;

--이하 사용자 계정으로 수정 
SELECT *FROM hr.employees;
SELECT * FROM hr.departments;

-- SYSTEM계정으로 가서 hr.departments의 select 권한 회수
REVOKE select ON hr.departments FROM C##KSE;

--다시 사용자 계정으로 돌아와서 
SELECT *FROM hr.departments; --권한 회수로 테이블을 볼 수 없게됨 

----------
--DDL: DATA DEFINITION LANGUAGE
----
CREATE TABLE book ( --컬럼의 정의
    book_id NUMBER (5), -- 5자리 정수 타입 -> PK로 변경될 예정
    title VARCHAR2(50), -- 50자리 가변문자
    author VARCHAR2(10), -- 10자리 가변문자
    pub_date DATE DEFAULT sysdate --  날짜타입 (기본값: 현재날짜와 시간) 
);
DESC book;


--SUBQUERY를 이용한 새 테이블 생성
-- hr.employees 테이블에서 일부 데이터를 추출하여 새 테이블 생성
SELECT *FROM hr.employees WHERE job_id LIKE 'IT_%'; --SUBQUERY 결과로 새 테이블 생성

CREATE TABLE it_emp AS(
    SELECT *FROM hr.employees 
    WHERE job_id LIKE 'IT_%' 
    );
DESC it_emp;
SELECT *FROM it_emp;

--내가 가지고 있는 테이블의 목록
SELECT * FROM tab;

--테이블 삭제
DROP TABLE it_map;
DROP TABLE it_emp;
SELECT *FROM tab;
--휴지통 비우기
PURGE RECYCLEBIN;
SELECT *FROM tab; --확인 

DESC BOOK;

--연습문제: AUTHOR TABLE 추가 , COLUMN, 제약조건 추가하기
CREATE TABLE author (
    author_id NUMBER (10),
    PRIMARY KEY (author_id)); --테이블 제약 조건 
ALTER TABLE author ADD (author_name VARCHAR2 (100) NOT NULL); --컬럼 제약 조건 
ALTER TABLE author ADD (author_desc VARCHAR2 (500));
DESC book;
DESC author; 

--book 테이블의 author 컬럼을 삭제
--나중의 author 테이블과 연결

ALTER TABLE book DROP COLUMN author;
DESC book;

--author.author_id를 참조하기 위한 author_id 컬럼을 book테이블에 추가 
ALTER TABLE book ADD (author_id NUMBER (10));
DESC book;
DESC author;

--book.book_id를 NUMBER (10)으로 바꾸기
ALTER TABLE book MODIFY (book_id NUMBER (10));

--book.author_id -> author.author_id를 참조 하도록 변경 (FK)
ALTER TABLE book 
ADD CONSTRAINTS 
    fk_author_id FOREIGN KEY (author_id)
                    REFERENCES author (author_id);
                    
DESC book;
--book 테이블의 author_id 컬럼에 author테이블의 author_id(FK)를 참조하는 외래키 (FK)추가


---------
--DATA DICTIONARY
-- ORACLE이 관리하는 데이터베이스 관련 정보들을 모아둔 특별한 용도의 테이블
-- USER_ : 현재 로그인 한 사용자 레벨의 객체들
-- ALL_: 사용자 전체 대상의 정보
--DBA_: 데이터 베이스 전체에 관련한 정보들 (관리자 전용)

--모든 딕셔너리 확인
SELECT * FROM DICTIONARY;

--사용자 스키마 객체 확인: USER_OBJECTS
SELECT * FROM USER_OBJECTS;
--제약
SELECT object_name, object_type FROM USER_OBJECTS;

--내가 가진 제약 조건 확인: USER_CONSTRAINTS
SELECT * FROM USER_CONSTRAINTS; -- CONSTRAINT_NAME: FK; 없으면:SYS

-- BOOK table에 걸려있는 제약조건 확인 
SELECT constraint_name, constraint_type, search_condition 
FROM USER_CONSTRAINTS 
WHERE table_name='BOOK';