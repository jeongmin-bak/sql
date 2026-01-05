/*
 * 섹션13. 윈도우 함수 
 * 
 * 선수 지식: GROUP BY
 */

/*
 * 윈도우 함수 개요
 *
 * 윈도우 함수는 OVER 절을 필수로 포함
 * OVER 절 SYNTAX
 * [ PARTITION BY partition_expr[, ...] ]
 * [ ORDER BY expr [ { ASC| DESC } ] [, ...] ]
 * [ window_frame_clause ]
 * 
 * <집계 함수>
 * 열들을 그대로 두고 하는 GROUP BY, 근데 이제 WINDOW를 곁들인..
 * SUM, MAX, MIN, AVG, COUNT
 * SQL Server는 집계 함수 내에서 ORDER BY 구문 지원 안함
 * 
 * <순위 관련 함수> 
 * RANK, DENSE_RANK, ROW_NUMBER
 * 
 * <비율 관련 함수>
 * CUME_DIST, PERCENT_RANK, NTILE, RATIO_TO_REPORT
 * RATIO_TO_REPORT는 Oracle만
 *
 */

-- 집계 함수에서 사용한 함수들을 윈도우 함수에서도 사용할 수 있다. OVER 절이 포함된 것이 다르다.
-- 집계 함수와는 다르게 출력 행 수를 변경하지 않고 모든 행에 집계 값을 출력한다.
--- 

SELECT SUM(SAL)
FROM EMP; 

SELECT DISTINCT SUM(SAL) OVER()
FROM EMP;

SELECT ENAME, JOB, SAL, SUM(SAL) OVER()
FROM EMP;

--

SELECT JOB, SUM(SAL)
FROM EMP 
GROUP BY JOB;

-- PARTITION BY는 GROUP BY 처럼 소그룹을 나눠 집계할 수 있게 해준다.
-- WINDOW 함수 집계 결과는 분할(PARTITION)을 넘어 올 수 없다.
-- 행 수가 변경되는 GROUP BY 집계 한 것과는 다르게 각각의 행마다 집계값을 표시한다.


SELECT JOB, SUM(SAL) OVER(PARTITION BY JOB)
FROM EMP;

/* 
 * window_frame_clause:
 * 
 * ROW 절을 이용하면 열 단위로 윈도우 크기를 설정할 수 있다.
 * RANGE는 논리적 값에 의한 범위를 나타낸다.
 * 
 * {ROWS|RANGE} { frame_start | frame_between }
 * 
 * frame_start:
 * 	  { UNBOUNDED PRECEDING | numeric_expr PREDING | [CURRENT ROW] }
 * 
 * frame_between:
 * 	  {
 * 	    BETWEEN UNBOUNDED PRECEDNG AND frame_end_a
 *      | BETWEEN numeric_expr PRECEDING AND frame_end_a
 *      | BETWEEN CURRENT ROW AND frame_end_b
 *      | BETWEEN numeric_expr FOLLOWING AND frame_end_c
 *    }
 *  
 * 	frame_end_a:
 * 	  { numeric_expr PRECEDING | CURRENT ROW | numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }
 * 
 * 	frame_end_b:
 * 	  { CURRENT ROW | numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }
 *  
 * 	frame_end_c:
 * 	  { numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }
 */

-- 윈도우를 설정하려면 먼저 ORDER BY로 순서를 정해야 한다.
-- ROWS만 있는 절은 BETWEEN 절의 AND CURRENT ROW가 생략된 것과 같다.

SELECT ENAME, SAL, 
--	SUM(sal) OVER() AS col0,
	SUM(sal) OVER(ORDER BY sal) AS col1, -- 누적합 
	SUM(sal) OVER(ORDER BY SAL ROWS UNBOUNDED PRECEDING) AS "=col1",
	SUM(sal) OVER(ORDER BY SAL ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS col2,
	SUM(sal) OVER(ORDER BY SAL ROWS 1 PRECEDING) AS col3,
	SUM(sal) OVER(ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS col3,
	SUM(sal) OVER(ORDER BY SAL ROWS CURRENT ROW) AS col4,
	SUM(sal) OVER(ORDER BY SAL ROWS BETWEEN CURRENT ROW AND CURRENT ROW) AS col4
FROM EMP;


--------------------------------------------------------------------------------
-- ROWS BETWEEN UNBOUNDED PRECEDING AND { numeric_expr PRECEDING | CURRENT ROW | numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }

SELECT ename, sal,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS col1,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS col2,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS col3,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS col4,
	SUM(SAL) OVER ()
FROM EMP;

----------------------------------------------------------------------------
--ROWS BETWEEN CURRENT ROW AND { CURRENT ROW | numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }

SELECT ename, sal,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN CURRENT ROW AND CURRENT ROW) AS col1,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS col2,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS col3,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS col4,
	SUM(SAL) OVER ()
FROM EMP;

----------------------------------------------------------------------------

--ROWS BETWEEN numeric_expr FOLLOWING AND { numeric_expr FOLLOWING | UNBOUNDED FOLLOWING }

SELECT ename, sal,
	SUM(SAL) OVER (ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) AS col1,
	SUM(SAL) OVER (ORDER BY SAL ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) AS col2
FROM EMP;

----------------------------------------------------------------------------

-- 논리적 범위를 설정하는 range

SELECT ename, sal,
	COUNT(*) OVER(ORDER BY SAL RANGE BETWEEN 200 PRECEDING AND 200 FOLLOWING) AS col 
FROM EMP;

----------------------------------------------------------------------------

-- partition by와 함께 사용

SELECT ENAME, JOB, SAL,
	COUNT(*) OVER(PARTITION BY JOB ORDER BY SAL RANGE BETWEEN 200 PRECEDING AND 200 FOLLOWING) AS sal_num
FROM EMP
ORDER BY 2,3; 

----------------------------------------------------------------------------

--- group by와 함께 사용

SELECT JOB, ROUND(AVG(SAL), 2) AVG_SAL, 
	COUNT(*) OVER(ORDER BY AVG(SAL) RANGE BETWEEN 300 PRECEDING AND 300 FOLLOWING) AS RNG 
FROM EMP 
GROUP BY JOB
ORDER BY 2

----------------------------------------------------------------------------

/*
 * 집계 함수
 */

SELECT ename, job, sal,
	SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS sum,
	round(AVG(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),2) AS avg,
	MIN(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min,
	MAX(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max,
	COUNT(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt
FROM emp
ORDER BY sal;

SELECT ename, job, sal,
	SUM(sal) OVER () AS sum,
	round(AVG(sal) OVER (),2) AS avg,
	MIN(sal) OVER () AS min,
	MAX(sal) OVER () AS max,
	COUNT(sal) OVER () AS cnt
FROM emp
ORDER BY sal;

SELECT ename, job, sal,
	SUM(sal) OVER (PARTITION BY job) AS sum,
	round(AVG(sal) OVER (PARTITION BY job),2) AS avg,
	MIN(sal) OVER (PARTITION BY job) AS min,
	MAX(sal) OVER (PARTITION BY job) AS max,
	COUNT(sal) OVER (PARTITION BY job) AS cnt
FROM emp;

----------------------------------------------------------------------------

/*
 * 순위 함수
 * RANK       동순위 허용, 동순위 후 간격 있음
 * DENSE_RANK 동순위 허용, 동순위 후 간격 없음
 * ROW_NUMBER 동순위 없음, 동순위 시 무작위로 번호 배정
 */