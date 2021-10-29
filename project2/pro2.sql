create sequence s
        START WITH 1000
        INCREMENT BY 1
        NOCACHE;
set serveroutput on
create or replace package srs as
procedure show_students(c1 in out sys_refcursor);
procedure show_courses(c1 in out sys_refcursor);

procedure show_classes(c1 in out sys_refcursor);
procedure show_enrollments(c1 in out sys_refcursor);
procedure show_pre(c1 in out sys_refcursor);

PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type);

PROCEDURE get_student_info(sid in students.sid%type, c1 out sys_refcursor);
PROCEDURE prereq(dc in varchar2(4), cn in number(3));
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

PROCEDURE get_student_info(sid in students.sid%type, c1 out sys_refcursor) as
	enrollment_sid enrollments.sid%TYPE;
	
	BEGIN
		open c1 for select * from classes c,  enrollments e where sid = e.sid and c.classid = e.classid;

END;

PROCEDURE prereq(dc in varchar2(4), cn in number(3)) as
BEGIN
	DECLARE prereqs TABLE (
	dept_code varchar2(4),
	course_no number(3), 
	title varchar2(20));
	DECLARE title1 = (Select title from courses where courses.dept_code = dc and courses.course_no = cn);
	Insert into prereqs VALUES (dc, cn, title);
	DECLARE pdc varchar2(4), pcn number(3);
	Declare pre_cur CURSOR FOR
	SELECT pre_dc, pre_cn from prerequisites where dept_code = dc and course_no = cn;
	OPEN pre_cur;
	fetch next from pre_cur into pdc, pcn;
	while @@fetch_status = 0
	Begin
		insert into prereqs select * from prereq(pdc, pcn);
	End;
	select * from prereqs;
END;

END;
/
show errors;
