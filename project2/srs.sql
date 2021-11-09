--set serveroutput on to display dbms_output messages
set serveroutput on;
--drop sequence log_id;
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
	        --the dual table is where we can access the username of the person who made the operation
		--we can use sysdate to get the current date/time
		select user  into uname from dual;
		--update class size	
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
		--delete student from the enrollments
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
		--insert tuple into logs table
                insert into logs values(log_id.nextval, uname, sysdate, 'Students', 'insert', :new.sid);

END;
/
show errors;

CREATE or REPLACE trigger add_enrollment_trigger AFTER INSERT on enrollments
FOR EACH ROW
DECLARE
	 uname varchar2(50);
BEGIN
                  select user into uname from dual;
		--increase class size by 1
		  update Classes SET class_size = class_size+1 where classid = :new.classid;
               	 insert into logs values(log_id.nextval, uname, sysdate, 'Enrollments', 'insert', :new.sid ||','||:new.classid);
END;
/
show errors;

create or replace package srs as
--Producedure name goes under the corresponding question numbers
--(2)
procedure show_students(c1 out sys_refcursor);
procedure show_courses(c1  out sys_refcursor);

procedure show_classes(c1  out sys_refcursor);
procedure show_enrollments(c1 out sys_refcursor);
procedure show_pre(c1  out sys_refcursor);
PROCEDURE show_logs(c1  out SYS_REFCURSOR);
--(3)
PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type);
--(4)
PROCEDURE get_student_info(p_sid in students.sid%type, c1 out sys_refcursor,errMsg out varchar2);
--(5)
PROCEDURE get_pre(p_dept_code in prerequisites.dept_code%type,p_course_no in prerequisites.course_no%type, c1 out sys_refcursor);  
--(6)
PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor, errMsg out varchar2);
--(7)
PROCEDURE enroll_student(p_sid in students.sid%type, p_classid in classes.classid%type, errMsg out varchar2);
--(8)
PROCEDURE drop_student(p_sid in students.sid%type, p_classid in classes.classid%type, errMsg out varchar2, classStatus out varchar2);
--(9)
PROCEDURE delete_student(p_sid in students.sid%type, errMsg out varchar2);

end;
/
show errors;

create or replace package body srs as
--the show_* procedures have essentially the same code. We use cursors to store multiple tuples
 PROCEDURE show_students(c1  OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from students;
END;

PROCEDURE show_courses(c1  OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from courses;
END;

PROCEDURE show_classes(c1  OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from classes;
END;


PROCEDURE show_enrollments(c1  OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from enrollments;
END;


PROCEDURE show_pre(c1 OUT SYS_REFCURSOR) as
BEGIN

   OPEN c1 FOR SELECT * from prerequisites;
END;

PROCEDURE show_logs(c1  out SYS_REFCURSOR) as 
BEGIN
	OPEN c1 FOR Select * from logs;
END;

--inserting student into students tables with user defined 
PROCEDURE insert_student(sid in students.sid%type, firstname in students.firstname%type, lastname in students.lastname%type, status in students.status%type, gpa in students.gpa%type, email in students.email%type) as
BEGIN

INSERT INTO students VALUES(sid, firstname, lastname, status, gpa, email);

END;
--input: student id
--output: refcursor containing the required student info
--output: errMsg that contains any error messages. if any
PROCEDURE get_student_info(p_sid in students.sid%type, c1 out sys_refcursor,errMsg out varchar2) as
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
		errMsg:= 'The SID is invalid';
		return;
	END IF;
	
	IF enrollment_count<1 THEN
		dbms_output.put_line('The student has not taken any courses');
		errMsg:='The student has not taken any courses';
		return;
	END IF;
	
		/*
		Use a tuple to store mutliple tuples
		need to use students, enrollment, and classes table
		need to store the dept_code and course_no so we use concat
	        */	
		
		open c1 for select s.sid, s.firstname,s.lastname, s.gpa, e.classid, concat(c.dept_code, c.course_no) as COURSE , c.semester, c.year from students s, enrollments e, classes c  where
		p_sid = s.sid and e.classid = c.classid and s.sid = e.sid;
	


END;
--input: classid
--output: cursor containing proper tuples
PROCEDURE get_class_info(c_id in classes.classid%type, c1 out sys_refcursor, errMsg out varchar2) as
	--procedure local variables
	class_count number;
	enrollment_count number;
	

	BEGIN
	select count(*) into class_count from classes where c_id = classid;
	select count(*) into enrollment_count from enrollments where c_id = classid;
	--If the count of enrollment_count or class_count then
	--no one is enrolled in the class or the classid is invalid, respectivly
	IF class_count<1 THEN
		errMsg:= 'The classid is invalid';
		dbms_output.put_line(errMsg);
	END IF;
	
	IF enrollment_count<1 THEN
		errMsg := 'No student is enrolled in the class';
		dbms_output.put_line(errMsg);
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


PROCEDURE drop_student(p_sid in students.sid%type, p_classid in classes.classid%type, errMsg out varchar2, classStatus out varchar2) as
	valid_student number;
	valid_classid number;
        valid_enrollment number;	
	c_num number;
	c_dept_code varchar2(4);
	class_enrollment number;
	student_enrollment number;
	BEGIN
		classStatus := ''; 
		--check  if the sid is valid
		select count(*) into valid_student from students where p_sid = sid;
		--check if classid is valid
		select count(*) into valid_classid from classes where p_classid = classid;
		--check if student is enrolled in the class
		select count(*) into valid_enrollment from enrollments where p_classid = classid and p_sid = sid;	
		--check to see if sid and classid are valid and if the student is enrolled in the class
		IF valid_student<1 THEN
			errMsg := 'sid not found';
			dbms_output.put_line(errMsg);
			return;
		END IF;
		
		IF valid_classid<1 THEN
			errMsg := 'classid not found';
			dbms_output.put_line(errMsg);
			return;
		END IF;

		IF valid_enrollment<1 then
			errMsg := 'student not enrolled in this class';
			dbms_output.put_line(errMsg);	
			return;
		END IF;
		--get the course number of the class
		 select course_no into c_num from classes where p_classid = classid;
		dbms_output.put_line(c_num);
		--get the dept_code of the class
                select dept_code into c_dept_code from classes where p_classid = classid;
		dbms_output.put_line(c_dept_code);
		 					
	/*
		Loop iterate through all the prereq courses and the classes that the student is taking. If the class is a prereq for a class
		that a student is taking, then we don't allow the student to drop the classs
	*/	
		for i in (select dept_code, course_no from prerequisites where pre_dept_code = c_dept_code and pre_course_no = c_num) loop
		    	--dbms_output.put_line(i.dept_code ||' ' || i.course_no);
				
			for j in (select dept_code, course_no from classes c, enrollments e where  e.classid = c.classid and p_sid = e.sid ) loop
				if(i.dept_code = j.dept_code and i.course_no = j.course_no)then
					errMsg := 'drop request rejected due to prerequisite requirement';
					dbms_output.put_line(errMsg);
					return;
				END IF; 	
			END LOOP ;
		
		END LOOP;
		
/*
	Case where student can drop the class
*/
	DELETE from enrollments where sid = p_sid and classid = p_classid;
	--count how many classes the student is enrolled in
	select count(classid) into student_enrollment from enrollments where p_sid = sid;
	--count how many students are in the class
	select count(sid) into class_enrollment from enrollments where classid = p_classid; 
	
	IF student_enrollment=0 then
		classStatus := CONCAT(classStatus, 'student enrolled in no class');
		dbms_output.put_line(classStatus);
	END IF;
	IF class_enrollment = 0 then
		classStatus := CONCAT(classStatus, 'no student in this class');
		dbms_output.put_line(classStatus);
	END IF;
	
	END;

PROCEDURE delete_student(p_sid in students.sid%type, errMsg out varchar2) as
	valid_student number;
	BEGIN
		--check if the sid is valid
		 select count(*) into valid_student from students where p_sid = sid;
		 if valid_student <1 then
			errMsg := 'sid not found';
			dbms_output.put_line(errMsg);
		END IF;
		--otherwise delete the student from the tables
		delete from students where sid = p_sid;
		
		
END;

PROCEDURE enroll_student(p_sid in students.sid%type, p_classid in classes.classid%type, errMsg out varchar2) as
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
	pre_req_enrolled number;
	c_dept_code classes.dept_code%type; 
	BEGIN
		--check for valid sid and classid
		 select count(*) into valid_student from students where p_sid = sid;
		 select count(*) into valid_classid from classes where p_classid = classid;
	            IF valid_student<1 THEN
			errMsg := 'sid not found';
                        dbms_output.put_line(errMsg);
                        return;
                END IF;

                IF valid_classid<1 THEN
		       errMsg := 'invalid classid';
                       dbms_output.put_line(errMsg);
                       return;
                END IF;
		errMsg := 'Prequitisite course have not been completed';
		--get semester ,year, class size, and limit of the class
		 select semester into class_semester from classes where classid = p_classid;
                 select year into class_year from classes where classid = p_classid;
		 select class_size into c_size from classes where p_classid = classid;
		 select limit into class_limit from classes where p_classid = classid;
		--check to see if the student is already in the class
		 select count(*) into in_class from enrollments where p_sid = sid and p_classid = classid;
		--check how many classes the student is taking 
		select count(*) into valid_load from enrollments inner join classes using(classid) where p_sid = sid and year = class_year and semester = class_semester; 
		--get course no and dept_code of the class	 
		select course_no into c_num from classes where classid = p_classid;
		select dept_code into c_dept_code from classes where classid = p_classid; 
		dbms_output.put_line('Error?');
		IF c_size = class_limit then
			errMsg := 'class full';
			dbms_output.put_line(errMsg);
			return;
		END IF;
		
		IF in_class>=1 then
			errMsg := 'already in class';
			dbms_output.put_line(errMsg);
			return;
		END IF;
		
		IF valid_load = 4 then
			errMsg := 'overloaded';
			dbms_output.put_line(errMsg);
			return;
		END IF;

		 /*
		
			find the grade of the student in each direct prereq course 
		*/
		   for i in (select pre_dept_code, pre_course_no from prerequisites  where dept_code = c_dept_code and course_no = c_num) loop
		
		
		
			--need make sure student is actuall enrolled in the preq class before check the grade. Helps to avoid 'no data found' error
		
			select count(*) into pre_req_enrolled from classes c, enrollments e where c.classid = e.classid and e.sid = p_sid and i.pre_dept_code = c.dept_code and i.pre_course_no = c.course_no;
			dbms_output.put_line(pre_req_enrolled);
			if pre_req_enrolled = 0 THEN
                                dbms_output.put_line(errMsg);
				return;
			END IF;
			
                    	select lgrade into pre_req_grade from classes c, enrollments e where c.classid = e.classid and e.sid = p_sid and i.pre_dept_code = c.dept_code and i.pre_course_no = c.course_no;
			--check to see student made prereq grade requirements
			if pre_req_grade > 'C' or pre_req_grade is NULL then
				dbms_output.put_line(errMsg);
				return;
			END if;
		
                   END LOOP;
		insert into enrollments values(p_sid, p_classid,null);

	END;
END;
/
show errors;

