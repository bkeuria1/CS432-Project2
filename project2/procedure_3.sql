set sqlblanklines on;
set serveroutput on;
create or replace package body srs as 
PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type) IS
BEGIN
INSERT INTO students VALUES(sid, firstname, lastname, status, gpa, email);
END;
END;
