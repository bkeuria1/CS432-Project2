create or replace package srs as 
procedure show;
end;
/
show errors

create or replace package body srs as
 PROCEDURE show IS
     CURSOR s IS SELECT * FROM students;
BEGIN
    OPEN s;
       
END;
END;
/
show errors
