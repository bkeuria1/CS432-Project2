
set serveroutput on;
drop sequence log_id;
create sequence log_id
        START WITH 1000
        INCREMENT BY 1
        NOCACHE
/
show errors;
CREATE or replace trigger drop_student_trigger AFTER
DELETE on Enrollments
FOR EACH ROW
DECLARE 
	uname varchar2(10);
	
	
BEGIN
	        select user  into uname from dual;
		dbms_output.put_line(log_id.nextval);	
		update Classes SET class_size = class_size - 1 where classid = :old.classid;
		insert into logs values(log_id.nextval, uname, sysdate,'enrollments', 'delete', :old.sid || ',' || :old.classid);
END;


/
show errors;

CREATE or REPLACE trigger delete_student_trigger AFTER DELETE on students
FOR EACH ROW
DECLARE
	 uname varchar2(50);

BEGIN
		  select user into uname from dual;
		delete from enrollments where sid = :old.sid;
		insert into logs values(log_id.nextval, uname, sysdate, 'Students', 'delete', :old.sid);
END;
/
show errors;

CREATE or REPLACE trigger add_student_trigger AFTER INSERT on students
FOR EACH ROW
DECLARE
	 uname varchar2(50);
BEGIN
                select user into uname from dual;
                insert into logs values(log_id.nextval, uname, sysdate, 'Students', 'insert', :new.sid);

END;
/
show errors;

CREATE or REPLACE trigger add_enrollment_trigger AFTER INSERT on enrollments
FOR EACH ROW
DECLARE
	 uname varchar2(50);
BEGIN
--      for c1_record in c1 loop
                  select user into uname from dual;
		  update Classes SET class_size = class_size+1 where classid = :new.classid;
               	 insert into logs values(log_id.nextval, uname, sysdate, 'Enrollments', 'insert', :new.sid ||','||:new.classid);
--      END LOOP;
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
PROCEDURE delete_student(p_sid in students.sid%type);
PROCEDURE enroll_student(p_sid in students.sid%type, p_classid in classes.classid%type);
end;
/
show errors;

create or replace package body srs as
--the show_* procedures have essentially the same code. We use cursors to store multiple tuples
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
	--local procedure variables
	enrollment_sid enrollments.sid%TYPE;
        sid_count number;	
	enrollment_count number;
	BEGIN

	select count(*) into sid_count from students where p_sid = sid;
	select count(*) into enrollment_count from enrollments where p_sid = enrollments.sid;
	--counting is a valid way to know whether an attribute is in the table
	--IF the count is less than 1, the attribute does not exist 
	IF sid_count<1 THEN
		dbms_output.put_line('The SID is invalid');
		
	END IF;
	
	IF enrollment_count<1 THEN
		dbms_output.put_line('The student has not taken any course');
	END IF;
		/*
		Use a tuple to store mutliple tuples
		need to use students, enrollment, and classes table
		need to store the dept_code and course_no so we use concat
		
		*/
		open c1 for select s.sid, s.firstname, s.gpa, e.classid, concat(c.dept_code, c.course_no) as COURSE , c.semester from students s, enrollments e, classes c  where
		p_sid = s.sid and e.classid = c.classid and s.sid = e.sid;



END;

PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor) as
	--procedure local variables
	class_count number;
	enrollment_count number;
	

	BEGIN
	select count(*) into class_count from classes where c_id = classid;
	select count(*) into enrollment_count from enrollments where c_id = classid;
	--If the count of enrollment_count or class_count then
	--no one is enrolled in the class or the classid is invalid, respectivly
	IF class_count<1 THEN
		dbms_output.put_line('The classid is invalid');
	END IF;
	
	IF enrollment_count<1 THEN
		dbms_output.put_line('No student is enrolled in the class');
	END IF;
	--join students, enrollments and classes table to get proper tuples

	open c1 for select classid, title, semester, year, sid, firstname, lastname, email from students inner join enrollments using (sid) inner join classes using (classid) inner join courses using(dept_code, course_no) where
	c_id = classid;
	
END;

PROCEDURE get_pre(p_dept_code in prerequisites.dept_code%type,p_course_no in prerequisites.course_no%type, c1 out sys_refcursor) as
	--we used a hierarchal query to get all direct and indirect prereq course
	--more can be read here: https://docs.oracle.com/cd/B19306_01/seIver.102/b14200/queries003.htm
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
	class_enrollment number;
	student_enrollment number;
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
		 					
	/*
		Loop iterate through all the prereq courses and the classes that the student is taking. If the class is a prereq for a class
		that a student is taking, then we don't allow the student to drop the classs
	*/	
		for i in (select pre_dept_code, pre_course_no from prerequisites where pre_dept_code = c_dept_code and pre_course_no = c_num) loop
		    	dbms_output.put_line(i.pre_dept_code ||' ' || i.pre_course_no);	
			for j in (select dept_code, course_no from classes c, enrollments e where  e.classid = c.classid and p_sid = e.sid) loop
				if(i.pre_dept_code = j.dept_code and i.pre_course_no = j.course_no) then
		
					dbms_output.put_line('drop request rejected due to prequisite requirements');
					return;
				END IF; 	
			END LOOP ;
		END LOOP;
		
/*
	Case where student can drop the class
*/
	DELETE from enrollments where sid = p_sid and classid = p_classid;
	select count(classid) into student_enrollment from enrollments where p_sid = sid;
	select count(sid) into class_enrollment from enrollments where classid = p_classid; 
	
	IF student_enrollment=0 then
		dbms_output.put_line('student enrolled in no class');
	END IF;
	IF class_enrollment = 0 then
		dbms_output.put_line('no student in this class');
	END IF;
	
	END;

PROCEDURE delete_student(p_sid in students.sid%type) as
	valid_student number;
	BEGIN
		 select count(*) into valid_student from students where p_sid = sid;
		 if valid_student <1 then
			dbms_output.put_line('sid not found');
		END IF;
		delete from students where sid = p_sid;
		
		
END;

PROCEDURE enroll_student(p_sid in students.sid%type, p_classid in classes.classid%type) as
	--local procedure variables
	valid_student number;
	valid_load number;
	valid_classid number;
	c_size number;
	class_limit number;
	in_class number;
	class_semester classes.semester%type;
	class_year number;
	c_num number;
	pre_req_grade varchar2(10);
	c_dept_code classes.dept_code%type; 
	BEGIN
		 select count(*) into valid_student from students where p_sid = sid;
		 select count(*) into valid_classid from classes where p_classid = classid;
	            IF valid_student<1 THEN
                        dbms_output.put_line('sid not found');
                        return;
                END IF;

                IF valid_classid<1 THEN
                       dbms_output.put_line('invalid classid');
                       return;
                END IF;
		  select semester into class_semester from classes where classid = p_classid;
                 select year into class_year from classes where classid = p_classid;
		 select class_size into c_size from classes where p_classid = classid;
		 select limit into class_limit from classes where p_classid = classid;
		 select count(*) into in_class from enrollments where p_sid = sid and p_classid = classid;
		 select count(*) into valid_load from enrollments inner join classes using(classid) where p_sid = sid and year = class_year and semester = class_semester; 
		 select course_no into c_num from classes where classid = p_classid;
		 select dept_code into c_dept_code from classes where classid = p_classid; 
		
		IF c_size = class_limit then
			dbms_output.put_line('class full');
			return;
		END IF;
		
		IF in_class>=1 then
			dbms_output.put_line('already in class');
			return;
		END IF;
		
		IF valid_load = 4 then
			dbms_output.put_line('overloaded');
		END IF;

		 /*
		 TODO: 
			1)check the prereq requirements
			2)check add students into the enrollments table
			3)modify add_enrollment trigger
		*/
		   for i in (select pre_dept_code, pre_course_no from prerequisites  where dept_code = c_dept_code and course_no = c_num) loop
                     	select lgrade into pre_req_grade from classes c, enrollments e where c.classid = e.classid and e.sid = p_sid and i.pre_dept_code = c.dept_code and i.pre_course_no = c.course_no;
		
			if pre_req_grade > 'C' then
				
				dbms_output.put_line('Prerequisite courses have not been completed');
				return;
			END if;
		
                   END LOOP;
		insert into enrollments values(p_sid, p_classid,null);

	END;
END;
/
show errors;

