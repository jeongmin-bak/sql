SELECT *
FROM student;

INSERT INTO STUDENT (student_id, email, name, department_id) 
VALUES (14, 'ddatg@ddatg.ac.kr', 'ddatg', 1);

DELETE FROM STUDENT WHERE student_id=14;
COMMIT;

INSERT INTO STUDENT VALUES (14, 'ddatg@ddatg.ac.kr', 'ddatg', 1);

ROLLBACK;

-- 에러! column 이름 목록으로 넣지 않으면 입력 순대로 모든 값을 다 넣어야 함
INSERT INTO student 
	VALUES (14, 'ddatg@ddatg.ac.kr', 'ddatg');

-- 에러! column 이름 목록으로 넣지 않으면 입력 순서를 컬럼 순서에 맞춰야 함
INSERT INTO student 
	VALUES (14, 'ddatg@ddatg.ac.kr', 1, 'ddatg');

INSERT INTO student (student_id, email, name)
	VALUES (14, 'ddatg@ddatg.ac.kr', 'ddatg');

-- 에러! NOT NULL CONSTRAINT가 있는 컬럼은 값을 입력해줘야 함
INSERT INTO student (student_id, email, department_id)
	VALUES (14, 'ddatg@ddatg.ac.kr', 1);

/*
 * UPDATE table_name
 * 	SET column_name1=update_value1
 * 	[, column_name2=update_value2, ...]
 * WHERE condition
 */

SELECT * FROM STADIUM s ;

UPDATE STADIUM s SET tel = '000-0000'
WHERE tel IS NULL;

-- 경기장 전화번호와 홈팀 전화번호가 일치하지 않는 경우

SELECT *
FROM STADIUM s;

SELECT *
FROM TEAM t ;

SELECT s.DDD, s.TEL, t.DDD, t.TEL 
FROM STADIUM s 
INNER JOIN TEAM t
ON s.HOMETEAM_ID = t.TEAM_ID
WHERE s.TEL = t.TEL
ORDER BY 1;

UPDATE STADIUM s 
SET s.DDD = (SELECT t.DDD
			   FROM TEAM t
			  WHERE s.HOMETEAM_ID = t.TEAM_ID
			),
	s.TEL = (SELECT t.TEL
				FROM TEAM t 
			WHERE s.HOMETEAM_ID = t.TEAM_ID
	);


UPDATE STADIUM a 
SET (a.DDD, a.TEL) = (SELECT t.DDD, t.TEL
						FROM TEAM t 
					   WHERE a.HOMETEAM_ID = t.TEAM_ID)
WHERE a.STADIUM_ID = 'A02' OR a.STADIUM_ID ='A05';

ROLLBACK ;
-----------------------------------------------------------
-- merge

-- Target 테이블 생성
CREATE TABLE target_tbl (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    quantity NUMBER
);

-- Source 테이블 생성
CREATE TABLE source_tbl (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    quantity NUMBER
);

-- target_tbl 데이터 삽입
INSERT INTO target_tbl (id, name, quantity) VALUES (1, 'Item A', 10);
INSERT INTO target_tbl (id, name, quantity) VALUES (2, 'Item B', 20);
INSERT INTO target_tbl (id, name, quantity) VALUES (3, 'Item C', 30);

-- source_tbl 데이터 삽입
INSERT INTO source_tbl (id, name, quantity) VALUES (2, 'Item B', 25);
INSERT INTO source_tbl (id, name, quantity) VALUES (3, 'Item C', 35);
INSERT INTO source_tbl (id, name, quantity) VALUES (4, 'Item D', 40);

COMMIT;


SELECT *
FROM target_tbl;

SELECT *
FROM source_tbl;

MERGE INTO target_tbl t
USING source_tbl s 
ON (t.id=s.id) 
WHEN MATCHED THEN 
	UPDATE SET t.quantity = s.quantity 
WHEN NOT MATCHED THEN 
	INSERT (id, name, quantity) VALUES (s.id, s.name, s.quantity);

ROLLBACK;



