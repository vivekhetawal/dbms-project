-- =========================================================
-- DBMS Mini Project: Student Management System
-- File: student_management_plsql.sql
-- Purpose: Procedures + trigger with beginner-friendly logic
-- =========================================================

SET SERVEROUTPUT ON;

-- ---------------------------------------------------------
-- Trigger: Before insert
-- Why used?
-- 1) Stops invalid age
-- 2) Stops duplicate ID with custom message
-- 3) Shows simple insert message
-- ---------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_profile_before_insert
BEFORE INSERT ON student_profile
FOR EACH ROW
DECLARE
    v_id_count NUMBER;
BEGIN
    IF :NEW.student_age <= 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Age must be greater than 0.');
    END IF;

    SELECT COUNT(*)
    INTO v_id_count
    FROM student_profile
    WHERE student_id = :NEW.student_id;

    IF v_id_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Student ID already present: ' || :NEW.student_id);
    END IF;

    :NEW.course_name := INITCAP(:NEW.course_name); -- small formatting variation

    DBMS_OUTPUT.PUT_LINE('Trigger Message: New record is being inserted for ID ' || :NEW.student_id);
END;
/

-- ---------------------------------------------------------
-- Procedure: Add student
-- Variation: prints age group for viva discussion
-- ---------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_add_student (
    p_student_id   IN student_profile.student_id%TYPE,
    p_student_name IN student_profile.student_name%TYPE,
    p_student_age  IN student_profile.student_age%TYPE,
    p_course_name  IN student_profile.course_name%TYPE,
    p_section_name IN student_profile.section_name%TYPE DEFAULT 'A'
) AS
BEGIN
    INSERT INTO student_profile (student_id, student_name, student_age, course_name, section_name)
    VALUES (p_student_id, p_student_name, p_student_age, p_course_name, p_section_name);

    IF p_student_age < 20 THEN
        DBMS_OUTPUT.PUT_LINE('Added successfully. Age group: Teen student.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Added successfully. Age group: Adult student.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Add failed: ' || SQLERRM);
END;
/

-- ---------------------------------------------------------
-- Procedure: Delete student by ID
-- ---------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_delete_student (
    p_student_id IN student_profile.student_id%TYPE
) AS
BEGIN
    DELETE FROM student_profile
    WHERE student_id = p_student_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No student found with ID ' || p_student_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student deleted successfully. ID: ' || p_student_id);
    END IF;
END;
/

-- ---------------------------------------------------------
-- Procedure: Search student by ID
-- ---------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_search_student (
    p_student_id IN student_profile.student_id%TYPE
) AS
    v_name    student_profile.student_name%TYPE;
    v_age     student_profile.student_age%TYPE;
    v_course  student_profile.course_name%TYPE;
    v_section student_profile.section_name%TYPE;
BEGIN
    SELECT student_name, student_age, course_name, section_name
    INTO v_name, v_age, v_course, v_section
    FROM student_profile
    WHERE student_id = p_student_id;

    DBMS_OUTPUT.PUT_LINE('Student Found -> ID: ' || p_student_id ||
                         ', Name: ' || v_name ||
                         ', Age: ' || v_age ||
                         ', Course: ' || v_course ||
                         ', Section: ' || v_section);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student not found for ID ' || p_student_id);
END;
/

-- ---------------------------------------------------------
-- Procedure: Display all students
-- Variation: prints total count at the end
-- ---------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_display_all_students AS
    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--------- Student List ---------');
    FOR rec IN (
        SELECT student_id, student_name, student_age, course_name, section_name, created_on
        FROM student_profile
        ORDER BY student_id
    ) LOOP
        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id ||
                             ' | Name: ' || rec.student_name ||
                             ' | Age: ' || rec.student_age ||
                             ' | Course: ' || rec.course_name ||
                             ' | Section: ' || rec.section_name ||
                             ' | Created: ' || TO_CHAR(rec.created_on, 'DD-MON-YYYY'));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total students: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;
/

-- ---------------------------------------------------------
-- Procedure: Update student details
-- Variation: keeps old value if null passed
-- ---------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_update_student (
    p_student_id   IN student_profile.student_id%TYPE,
    p_student_name IN student_profile.student_name%TYPE DEFAULT NULL,
    p_student_age  IN student_profile.student_age%TYPE DEFAULT NULL,
    p_course_name  IN student_profile.course_name%TYPE DEFAULT NULL,
    p_section_name IN student_profile.section_name%TYPE DEFAULT NULL
) AS
BEGIN
    IF p_student_age IS NOT NULL AND p_student_age <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update stopped: Age must be greater than 0.');
        RETURN;
    END IF;

    UPDATE student_profile
    SET student_name = NVL(p_student_name, student_name),
        student_age = NVL(p_student_age, student_age),
        course_name = NVL(INITCAP(p_course_name), course_name),
        section_name = NVL(UPPER(p_section_name), section_name)
    WHERE student_id = p_student_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No student found for update. ID: ' || p_student_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student updated successfully. ID: ' || p_student_id);
    END IF;
END;
/

-- ---------------------------------------------------------
-- Demo executions (uncomment while testing)
-- ---------------------------------------------------------
-- EXEC pr_add_student(204, 'Manya Verma', 21, 'ai and ml', 'C');
-- EXEC pr_search_student(202);
-- EXEC pr_update_student(203, p_course_name => 'cloud computing');
-- EXEC pr_delete_student(201);
-- EXEC pr_display_all_students;
