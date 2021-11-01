
set serveroutput on;
create or replace sequence s
        START WITH 1000
        INCREMENT BY 1
        NOCACHE;

CREATE or replace trigger drop_student_trigger AFTER
DELETE on Enrollments
FOR EACH ROW
DECLARE 
	class_id classes.classid%type;
	CURSOR c1 is select * from classes where classid = :old.classid;
BEGIN
	for c1_record in c1 loop
		c1_record.class_size := c1_record.class_size - 1;
	END LOOP;
	

END;
/
show errors;
create or replace package srs as
procedure show_students(c1 in out sys_refcursor);
procedure show_courses(c1 in out sys_refcursor);

procedure show_classes(c1 in out sys_refcursor);
procedure show_enrollments(c1 in out sys_refcursor);
procedure show_pre(c1 in out sys_refcursor);

PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type);

PROCEDURE get_student_info(p_sid in students.sid%type, c1 out sys_refcursor);
PROCEDURE get_pre(p_dept_code in prerequisites.dept_code%type,p_course_no in prerequisites.course_no%type, c1 out sys_refcursor);  
PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor);

PROCEDURE drop_student(p_sid in students.sid%type, p_classid in classes.classid%type);

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

PROCEDURE get_pre(p_dept_code in prerequisites.dept_code%type,p_course_no in prerequisites.course_no%type, c1 out sys_refcursor) as

	BEGIN
		open c1 for select pre_dept_code, pre_course_no from prerequisites  CONNECT BY dept_code = PRIOR pre_dept_code and course_no = PRIOR pre_course_no START WITH course_no = p_course_no and 
		dept_code = p_dept_code;		
	END;

PROCEDURE drop_student(p_sid in students.sid%type, p_classid in classes.classid%type) as
	valid_student number;
	valid_classid number;
        valid_enrollment number;	
	c_num number;
	c_dept_code varchar2(4);
	temp_classid varchar2(10);
	is_pre number;
	num_enrollments number;
	cursor prereq is select pre.dept_code, pre.course_no from prerequisites pre, classes c where p_classid = c.classid and c.dept_code = pre.pre_dept_code and c.course_no = pre.pre_course_no;
	BEGIN
		select count(*) into valid_student from students where p_sid = sid;
		select count(*) into valid_classid from classes where p_classid = classid;
		select count(*) into valid_enrollment from enrollments where p_classid = classid and p_sid = sid;	
		
		IF valid_student<1 THEN
			dbms_output.put_line('sid not found');
			return;
		END IF;
		
		IF valid_classid<1 THEN
			dbms_output.put_line('classid not found');
			return;
		END IF;

		IF valid_enrollment<1 then
			dbms_output.put_line('student not enrolled in this class');	
			return;
		END IF;

		 select course_no into c_num from classes where p_classid = classid;
		dbms_output.put_line(c_num);
                select dept_code into c_dept_code from classes where p_classid = classid;

		dbms_output.put_line(c_dept_code);
		
		for 			
		
	/*	
		for i in (select pre_dept_code, pre_course_no from prerequisites where dept_code = c_dept_code and course_no = c_num) loop
		    	dbms_output.put_line(i.pre_dept_code ||' ' || i.pre_course_no);	
			
			select classid into temp_classid from classes c, enrollments e where i.pre_dept_code = dept_code and i.pre_course_no = course_no;
			/*
			select count(*) into is_pre from enrollments where classid = temp_classid and p_sid = sid;
			
			IF is_pre <1 then
				dbms_output.put_line('drop request rejected due to prerequisite requirements');
		
		
			END IF; 
	
		END LOOP ;
*/
		
	
	END;


END;
/
show errors;

