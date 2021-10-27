CREATE PROCEDURE insert_student(sid in students.sid%type,
 firstname in students.firstname%type, lastname in students.lastname%type, 
 status in students.status%type, gpa in students.gpa%type, email in students.email%type)  
AS
BEGIN 
	INSERT INTO students VALUES(sid, firstname, lastname, status, gpa, email);
END