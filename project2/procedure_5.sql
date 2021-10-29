CREATE PROCEDURE prereq(@dc varchar2(4), @cn number(3))
AS 
BEGIN
	DECLARE @prereqs TABLE (
	dept_code varchar2(4),
	course_no number(3), 
	title varchar2(20)
	)
	DECLARE @title VARCHAR2(20);
	SET @title = (Select title from courses where courses.dept_code = @dc and courses.course_no = @cn);
	INSERT INTO @prereqs VALUES (@dc, @cn, @title);
	DECLARE @pdc varchar2(4), @pcn number(3);
	DECLARE prereq_cursor CURSOR FOR
	SELECT pre_dc, pre_cn from prerequisites 
	WHERE dept_code = dc AND course_no = cd;
	OPEN prereq_cursor;
	Fetch Next from prereq_cursor into @pdc, @pcn;
	while @@FETCH_STATUS = 0
	BEGIN 
		insert into @prereqs select * from prereq(@pdc, @pcn);
	END
	RETURN @prereqs;
		
		
END;
--var n number
--exec procedure_name(:n)
--print n
