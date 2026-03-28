# Student Management System (PL/SQL Mini Project)

This is a college-friendly DBMS mini project made with **Oracle SQL + PL/SQL** and a simple **HTML/CSS UI mockup**.
The code is kept easy so you can explain every part clearly during viva.

## Folder Structure

- `setup_database.sql` : Creates table, constraints, and sample records.
- `student_management_plsql.sql` : Trigger + all procedures.
- `frontend/index.html` : Add and Search forms.
- `frontend/styles.css` : Basic clean design.

## What is unique in this version?

1. Table name changed to `student_profile` with clearer column names.
2. Added `section_name` field for classroom grouping.
3. Trigger auto-formats course name using `INITCAP`.
4. Display procedure also prints total student count.
5. Update procedure supports partial update (only pass fields you want to change).

## Features Covered

### Database Part
- Table with primary key (`student_id`)
- Age check (`student_age > 0`)
- Sample data insertion

### PL/SQL Part
- `pr_add_student`
- `pr_delete_student`
- `pr_search_student`
- `pr_display_all_students`
- `pr_update_student`
- `trg_profile_before_insert`

### Validation and Messages
- Duplicate ID prevented by primary key + trigger logic
- Invalid age rejected
- `DBMS_OUTPUT.PUT_LINE` used for user-friendly messages

## How to Run

```sql
@setup_database.sql
@student_management_plsql.sql
```

### Demo Commands

```sql
EXEC pr_add_student(204, 'Manya Verma', 21, 'ai and ml', 'C');
EXEC pr_search_student(204);
EXEC pr_update_student(204, p_course_name => 'data engineering');
EXEC pr_display_all_students;
```

## Frontend Note

Frontend is static (for presentation). In future, it can be connected with any backend/API.
