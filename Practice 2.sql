
-- 집계

--#1
--매니저가 있는 직원은 몇명? - define as "haveMngCnt"
SELECT count(manager_id) "haveMngCnt"
FROM employees 
WHERE manager_id is not null;

--#2