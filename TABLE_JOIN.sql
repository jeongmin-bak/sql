--- 인프런.실무에서 바로쓰는 SQL 예제 200 
--- 10,11 테이블 JOIN 

-- 테이블 JOIN
-- 예제1. 
SELECT EMPNO, ENAME , SAL
FROM emp;

-- 예제2.
SELECT *
FROM emp;

-- 3
SELECT EMPNO  AS "사원번호",
	ENAME AS "사원이름",
	SAL AS "Salary"
FROM emp

-- 4 
SELECT ENAME || SAL
FROM emp;

-- 5 
SELECT DISTINCT JOB
FROM emp;

-- 6 
SELECT ENAME, SAL 
FROM emp
ORDER BY SAL ASC; 

-- 7 
SELECT ENAME, SAL, JOB 
FROM emp
WHERE SAL = 3000;

-- 8 
SELECT ENAME, SAL, JOB, TO_CHAR(HIREDATE, 'YY/MM/DD') AS HIREDATE, DEPTNO 
FROM emp
WHERE ENAME = 'SCOTT';

-- 58
SELECT *
FROM emp; 

SELECT * 
FROM DEPT;

SELECT e.ENAME, d.LOC
FROM EMP e 
JOIN DEPT d ON e.DEPTNO  = d.DEPTNO;

SELECT e.ENAME, d.LOC
FROM EMP e 
JOIN DEPT d
USING (DEPTNO);

SELECT e.ENAME, d.LOC
FROM EMP e 
NATURAL JOIN DEPT d

-- 59
WITH salgrade AS (
	SELECT 1 grade, 700 losal, 1200 hisal FROM dual 
	UNION ALL 
	SELECT 2 grade, 1202 losal, 1400 hisal FROM dual 
	UNION ALL
	SELECT 3 grade, 1401 losal, 2000 hisal FROM dual 
	UNION ALL 
	SELECT 4 grade, 2001 losal, 3000 hisal FROM dual 
	UNION ALL 
	SELECT 5 grade, 3001 losal, 999 hisal FROM dual 
)
SELECT EMPNO, ENAME, e.sal, grade, losal, hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.HISAL 
ORDER BY EMPNO;

WITH salgrade AS (
	SELECT 1 grade, 700 losal, 1200 hisal FROM dual 
	UNION ALL 
	SELECT 2 grade, 1202 losal, 1400 hisal FROM dual 
	UNION ALL
	SELECT 3 grade, 1401 losal, 2000 hisal FROM dual 
	UNION ALL 
	SELECT 4 grade, 2001 losal, 3000 hisal FROM dual 
	UNION ALL 
	SELECT 5 grade, 3001 losal, 999 hisal FROM dual 
) 
SELECT e.ENAME, e.SAL, s.GRADE 
FROM emp e, salgrade s 
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL AND s.GRADE = 4
ORDER BY e.SAL DESC;

SELECT e.ENAME, e.SAL
	, CASE
		WHEN e.SAL >= 5000 THEN 5
		WHEN e.SAL >= 2450 THEN 4
		WHEN e.SAL >= 1500 THEN 3
		WHEN e.SAL >= 1250 THEN 2
		ELSE 1
	END AS GRADE
FROM EMP e 
ORDER BY e.SAL;

-- 60 
SELECT e.ENAME, d.LOC 
FROM EMP e, DEPT d 
WHERE e.DEPTNO(+) = d.DEPTNO;

SELECT e.ENAME, d.LOC 
FROM EMP e RIGHT OUTER JOIN DEPT d
ON e.DEPTNO = d.DEPTNO;



-- 60 


INSERT INTO emp(empno, ename, sal, deptno) VALUES (7122, 'JACK', 3000, 70);
COMMIT;

SELECT *
FROM emp e;

SELECT e.ENAME, e.JOB, e.SAL, d.LOC 
FROM emp e, dept d
WHERE e.DEPTNO = d.DEPTNO(+);

-- 61 
SELECT e.ENAME AS 사원 
	 , e.JOB   AS 직
	 , 'BLAKE' AS 관리자 
	 , 'MANAGER' AS 직업_1
FROM emp e
WHERE e.JOB='SALESMAN';

SELECT 사원.ename AS 사원, 
 	   사원.job AS 직업, 
	  관리자.ename AS 관리자,
	  관리자.job AS 직업_1 
FROM emp 사원, emp 관리자 
WHERE 사원.mgr = 관리자.empno

SELECT 사원.ename AS 사원, 
 	   사원.job AS 직업, 
 	   사원.sal,
	  관리자.ename AS 관리자,
	  관리자.job AS 직업_1,
	  관리자.sal
FROM emp 사원, emp 관리자 
WHERE 사원.mgr = 관리자.empno AND 사원.SAL > 관리자.SAL

-- 61 
SELECT e.ENAME
	, e.JOB 
	, e.SAL
	, d.LOC  
FROM emp e LEFT JOIN dept d 
ON e.DEPTNO = d.DEPTNO 
WHERE e.JOB = 'SALESMAN'

SELECT e.ENAME , e.SAL, d.LOC 
FROM emp e 
JOIN dept d 
ON e.DEPTNO = d.DEPTNO 
WHERE e.SAL BETWEEN 1000 AND 3000

-- 61
SELECT e.ENAME
	, e.JOB 
	, e.SAL
	, d.LOC  
FROM emp e LEFT JOIN dept d 
USING (deptno) WHERE e.JOB = 'SALESMAN' 

-- 64
SELECT e.ENAME
	, e.JOB 
	, e.SAL
	, d.LOC  
FROM emp e 
NATURAL JOIN dept d WHERE e.JOB = 'SALESMAN'

-- 64-1
SELECT e.ENAME, e.JOB, e.SAL, d.LOC 
FROM EMP e
NATURAL JOIN DEPT d 
WHERE e.JOB = 'SALESMAN' AND DEPTNO = '30';

-- 65 
SELECT e.ENAME AS 이름
	, e.JOB AS 직업 
	, e.SAL AS 월급 
	, d.LOC AS 부서위치 
FROM emp e, dept d 
WHERE e.DEPTNO(+) = d.DEPTNO

-- 66 
SELECT e.ENAME AS ENAME
	, e.JOB AS JOB 
	, e.SAL AS SAL 
	, d.LOC AS LOC 
FROM emp e
FULL OUTER JOIN dept d
ON e.DEPTNO(+)=d.DEPTNO

SELECT e.ename, d.loc
FROM emp e RIGHT OUTER JOIN  dept d 
ON e.DEPTNO = d.DEPTNO ;


SELECT e.ENAME AS ENAME
	, e.JOB AS JOB 
	, e.SAL AS SAL 
	, d.LOC AS LOC 
FROM emp e
FULL OUTER JOIN dept d
ON e.DEPTNO=d.DEPTNO(+)

SELECT e.ename, d.loc
FROM emp e LEFT OUTER JOIN  dept d 
ON e.DEPTNO = d.DEPTNO ;

SELECT e.ENAME AS ENAME
	, e.JOB AS JOB 
	, e.SAL AS SAL 
	, d.LOC AS LOC 
FROM emp e 
FULL OUTER JOIN dept d
ON e.DEPTNO = d.DEPTNO ;

SELECT e.ENAME AS ENAME
	, e.JOB AS JOB 
	, e.SAL AS SAL 
	, d.LOC AS LOC 
FROM emp e 
FULL OUTER JOIN dept d
ON e.DEPTNO = d.DEPTNO 
WHERE e.JOB = 'ANALYST' OR d.LOC='BOSTON';

-- 67 
SELECT d.DEPTNO
	, SUM(e.SAL)
FROM emp e 
JOIN dept d
ON e.DEPTNO = d.DEPTNO 
GROUP BY d.DEPTNO
UNION ALL 
SELECT NULL, SUM(e.SAL)
FROM emp e 

-- 68 
SELECT d.DEPTNO
	, SUM(e.SAL)
FROM emp e 
JOIN dept d
ON e.DEPTNO = d.DEPTNO 
GROUP BY d.DEPTNO
UNION
SELECT NULL, SUM(e.SAL)
FROM emp e;