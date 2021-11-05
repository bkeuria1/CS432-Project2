start project2_tables.sql;
start dummyData.sql;
start q2.sql;
var p refcursor;


exec srs.show_students(:p);
print p;

exec srs.show_enrollments(:p);
print p;

--print 'Contents of the Classes Table';
exec srs.show_classes(:p);
print p;

--dbms_output.put_line('Contents of the Courses Table');
exec srs.show_courses(:p);
print p;

--dbms_output.put_line('Contents of the Prereq Table');
exec srs.show_pre(:p);
print p;

--dbms_output.put_line('Contents of the logs Table');
exec srs.show_logs(:p);
print p;


