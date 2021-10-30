
set serveroutput on;
create or replace sequence s
        START WITH 1000
        INCREMENT BY 1
        NOCACHE;


create or replace package srs as
procedure show_students(c1 in out sys_refcursor);
procedure show_courses(c1 in out sys_refcursor);

procedure show_classes(c1 in out sys_refcursor);
procedure show_enrollments(c1 in out sys_refcursor);
procedure show_pre(c1 in out sys_refcursor);

PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type);

PROCEDURE get_student_info(p_sid in students.sid%type, c1 out sys_refcursor);

PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor);
end;
/
show errors;

create or replace package body srs as

 PROCEDURE show_students(c1 in OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from students;
END;

PROCEDURE show_courses(c1 in OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from courses;
END;

PROCEDURE show_classes(c1 in OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from classes;
END;


PROCEDURE show_enrollments(c1 in OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from enrollments;
END;


PROCEDURE show_pre(c1 in OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from prerequisites;
END;

PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type) as
BEGIN

INSERT INTO students VALUES(sid, firstname, lastname, status, gpa, email);

END;

PROCEDURE get_student_info(p_sid in students.sid%type, c1 out sys_refcursor) as
	enrollment_sid enrollments.sid%TYPE;
        sid_count number;	
	enrollment_count number;
	BEGIN

	select count(*) into sid_count from students where p_sid = sid;
	select count(*) into enrollment_count from enrollments where p_sid = enrollments.sid;
	IF sid_count<1 THEN
		dbms_output.put_line('The SID is invalid');
		
	END IF;
	
	IF enrollment_count<1 THEN
		dbms_output.put_line('The student has not taken any course');
	END IF;
		open c1 for select s.sid, s.firstname, s.gpa, e.classid, concat(c.dept_code, c.course_no) as COURSE , c.semester from students s, enrollments e, classes c  where
		p_sid = s.sid and e.classid = c.classid and s.sid = e.sid;



END;

PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor) as
	class_count number;
	enrollment_count number;
	

	BEGIN
	select count(*) into class_count from classes where c_id = classid;
	select count(*) into enrollment_count from enrollments where c_id = classid;
	IF class_count<1 THEN
		dbms_output.put_line('The classid is invalid');
	END IF;
	
	IF enrollment_count<1 THEN
		dbms_output.put_line('No student is enrolled in the class');
	END IF;

	open c1 for select classid, title, semester, year, sid, firstname, lastname, email from students inner join enrollments using (sid) inner join classes using (classid) inner join courses using(dept_code, course_no) where
	c_id = classid;
	
	END;


END;
/
show errors;

