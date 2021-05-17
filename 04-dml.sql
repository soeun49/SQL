------------------------------
--CUD (Create, Update, Delete) 
-------------------------------

DESC author;

--INSERT: 테이블에 새 데이터 추가
--데이터에 넣을 컬럼을 지정하지 않으면 전체 데이터를 제공 
--테이블 정의시 지정한 순서대로 데이터가 insert 된다
--TRANSACTON의 시작 
INSERT INTO author 
VALUES (1, '박경리', '토지 작가');

--2번째 방법: 특정 컬럼의 내용만 입력 할 떄는 컬럼의 목록 지정
INSERT INTO author (author_id, author_name) 
VALUES (2,'김영하');
--author_id는 pk값이므로 중복되면 안됨 

SELECT*FROM author; --author_desc는 데이터를 넣지 않았으므로 null로 잡힘

COMMIT; --변경 사항 커밋 = 트랜젝션 cmd의 sql plus에서 확인 가능!

INSERT INTO author(author_id, author_name)
VALUES (3, '스티븐 킹');

SAVEPOINT a;
SELECT*FROM author;

INSERT INTO author (author_id, author_name)
VALUES (4, '톨스토이');

SELECT * FROM author;

ROLLBACK TO a; -- savepoint a로 돌아가기 (복구) 
SELECT*FROM author;

ROLLBACK; -- 트랜젝션 시작 위치로 복구 (커밋 이후의)
SELECT * FROM author;

DESC book;

INSERT INTO book 
VALUES (1,'토지', sysdate, 1);

INSERT INTO book (book_id, title, author_id)
VALUES (2, '살인자의 기억법', 2);

SELECT * FROM book;

INSERT INTO book(book_id, title, author_id) 
VALUES(3, '쇼생크 탈출', 3);
-- 무결성 제약조건이 위배되어 (부모키가 없어) ERROR 
--삽입되지 않음 

COMMIT;


--UPDATE
--UPDATE 테이블 명 SET 컬럼명=값, 컬럼명=값
UPDATE author SET author_desc='알쓸신잡 출연';
--WHERE 절로 명시하지 않을 경우, 모든 레코드가 바뀜 
SELECT *FROM author;

ROLLBACK;

UPDATE author SET author_desc='알쓸신잡 출연'
WHERE author_id=2;
SELECT *FROM author;

--연습
--hr.employees 테이블로부터 departmnent_id가 10,20,30인 사람들만 
--새 테이블로 생성
CREATE TABLE emp123 AS
        (SELECT *FROM hr.employees WHERE department_id IN (10,20,30));

DESC emp123;
SELECT first_name, salary, department_id FROM emp123;

--부서가 30인 직원들의 급여를 10%인상
UPDATE emp123 SET salary = salary + salary*0.1
WHERE department_id=30;
SELECT first_name, salary, department_id, job_id FROM emp123;

ROLLBACK;

-- DELETE: 테이블로부터 레코드 삭제(!)
SELECT *FROM emp123;
DELETE FROM emp123;
--WHERE 절로 명시하지 않을 경우, 모든 레코드가 삭제됨 

ROLLBACK;
--job_id가 pu로 시작되는 레코드 삭제
DELETE FROM emp123 
WHERE job_id LIKE 'PU_%';

SELECT*FROM emp123;

ROLLBACK;

--DELETE 와 TRUNCATE 비교
--DELETE: TRANSACTION 의 대상 --> ROLLBACK이 가능
--TRUNCATE: TRANSACTION의 대상이 아님 --> ROLLBACK이 불가능

DELETE FROM emp123;
SELECT*FROM emp123;
ROLLBACK;

TRUNCATE TABLE emp123;
SELECT*FROM emp123;
ROLLBACK; -- truncate는 rollback의 대상이 아님 
SELECT*FROM emp123;


--무결성 제약조건을 위배하면 DML은 수행되지 않는다. 
--COMMIT: 영구적 저장 
--ROLLBACK: 복원






