-- =========================================================
-- DBMS Mini Project: Student Management System
-- File: setup_database.sql
-- Purpose: Create table + constraints + demo data
-- Note: Script is written in simple steps for viva explanation
-- =========================================================

-- Step 1: Drop table if already present (for easy re-run)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE student_profile CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Step 2: Create main table
CREATE TABLE student_profile (
    student_id      NUMBER,
    student_name    VARCHAR2(100) NOT NULL,
    student_age     NUMBER NOT NULL,
    course_name     VARCHAR2(80) NOT NULL,
    section_name    VARCHAR2(10) DEFAULT 'A',
    created_on      DATE DEFAULT SYSDATE,
    CONSTRAINT pk_student_profile PRIMARY KEY (student_id),
    CONSTRAINT chk_student_age CHECK (student_age > 0)
);

-- Step 3: Insert sample records
INSERT INTO student_profile (student_id, student_name, student_age, course_name, section_name)
VALUES (201, 'Aarav Mehta', 19, 'Computer Science', 'A');

INSERT INTO student_profile (student_id, student_name, student_age, course_name, section_name)
VALUES (202, 'Riya Sharma', 20, 'Data Analytics', 'B');

INSERT INTO student_profile (student_id, student_name, student_age, course_name, section_name)
VALUES (203, 'Kabir Nair', 18, 'Cyber Security', 'A');

COMMIT;

-- Step 4: Check inserted data
SELECT student_id,
       student_name,
       student_age,
       course_name,
       section_name,
       TO_CHAR(created_on, 'DD-MON-YYYY') AS created_on
FROM student_profile
ORDER BY student_id;
