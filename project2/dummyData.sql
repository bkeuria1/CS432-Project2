
insert into students values ('B001', 'Anne', 'Broder', 'junior', 3.9, 'broder@bu.edu');
insert into students values ('B002', 'Terry', 'Buttler', 'senior', 3.8, 'buttler@bu.edu');
insert into students values ('B003', 'Tracy', 'Wang', 'senior', 3.7, 'wang@bu.edu');
insert into students values ('B004', 'Alice', 'Taylor', 'junior', 2.7, 'callan@bu.edu');
insert into students values ('B005', 'Jack', 'Smith', 'graduate', 3.0, 'smith@bu.edu');
insert into students values ('B006', 'Terry', 'Zillman', 'graduate', 4.0, 'zillman@bu.edu');
insert into students values ('B007', 'Becky', 'Lee', 'senior', 4.0, 'lee@bu.edu');
insert into students values ('B008', 'Tom', 'Baker', 'freshman', null, 'baker@bu.edu');

insert into courses values ('CS', 432, 'database systems');
insert into courses values ('Math', 314, 'discrete math');
insert into courses values ('CS', 240, 'data structure');
insert into courses values ('Math', 221, 'calculus I');
insert into courses values ('CS', 532, 'database systems');
insert into courses values ('CS', 552, 'operating systems');
insert into courses values ('BIOL', 425, 'molecular biology');
insert into courses values ('Math', 222, 'calculus II');
insert into courses values ('CS', 140, 'Intro to Java');
insert into courses values ('BIOL', 400, 'Intro to Elephants');
insert into courses values ('SOM', 100, 'Intro to Money');
insert into courses values ('SOM', 200, 'Finance');
insert into courses values ('Math','400', 'Graph Theory');
insert into courses values ('SOM', 300, 'Tax Evasion');
insert into courses values ('Math',100, 'Algebra');
insert into courses values ('CS', 101, 'Intro to CS');
insert into courses values ('CS', 652, 'Advanced OS');


insert into prerequisites values ('SOM', 200, 'SOM', 100);
insert into prerequisites values ('SOM', 200, 'Math', 222);
insert into prerequisites values ('Math', 222, 'Math', 221);
insert into prerequisites values ('CS', 240, 'CS', 140);
insert into prerequisites values ('Math', 314, 'Math',222);
insert into prerequisites values ('CS', 532, 'CS', 240);
insert into prerequisites values ('CS', 432, 'CS', 240);
insert into prerequisites values ('CS', 552, 'CS', 240);
insert into prerequisites values ('BIOL', 425, 'BIOL', 400);
insert into prerequisites values ('Math', 400, 'Math', 314);
insert into prerequisites values ('SOM', 300, 'SOM', 200);
insert into prerequisites values ('CS', 652, 'CS', 552);


insert into classes values  ('c0001', 'CS', 101, 1, 2019, 'Fall', 50,50);
insert into classes values  ('c0002', 'CS', 140, 1, 2020, 'Spring', 40,38);
insert into classes values  ('c0003', 'CS', 240, 1, 2020, 'Fall', 25,24);
insert into classes values  ('c0004', 'CS', 240, 2, 2020, 'Fall', 25,24);
insert into classes values  ('c0005', 'CS', 432, 1, 2021, 'Spring', 25,25);
insert into classes values  ('c0006', 'CS', 532, 1, 2021, 'Spring', 25,25);
insert into classes values  ('c0007', 'CS', 552, 1, 2020, 'Fall', 15,13);
insert into classes values  ('c0008', 'CS', 652, 1, 2021, 'Spring', 10,10);
insert into classes values  ('c0009', 'BIOL', 400, 1, 2019, 'Fall', 20,15);
insert into classes values  ('c0010', 'BIOL', 425, 1, 2020, 'Spring', 20, 15);
insert into classes values  ('c0011', 'SOM', 100, 1, 2019, 'Fall', 20, 15);
insert into classes values  ('c0012', 'SOM', 100, 2, 2019, 'Fall', 20, 15);
insert into classes values  ('c0013', 'SOM', 200, 1, 2020, 'Spring', 20, 18);
insert into classes values  ('c0014', 'SOM' ,300,1, 2020, 'Fall', 20, 17);
insert into classes values ('c0015', 'Math' ,221, 1, 2019, 'Fall', 20, 19);
insert into classes values ('c0016', 'Math' ,222, 1, 2020, 'Spring', 20, 20);
insert into classes values ('c0017', 'Math' ,222, 2, 2020, 'Spring', 20, 20);
insert into classes values ('c0018', 'Math' ,314, 1, 2020, 'Fall', 20, 20);
insert into classes values ('c0019', 'Math' ,400, 1, 2021, 'Spring', 21, 20);

insert into enrollments values  ('B001', 'c0001', 'B');
insert into enrollments values  ('B001', 'c0002', 'A');
insert into enrollments values  ('B001', 'c0003', 'A');
insert into enrollments values  ('B001', 'c0005', 'B');


insert into enrollments values('B002', 'c0011', 'A');
insert into enrollments values('B002', 'c0013', 'A');
insert into enrollments values('B002', 'c0014', 'A');
insert into enrollments values('B002', 'c0015', 'A');
insert into enrollments values('B002', 'c0016', 'A');

insert into enrollments values('B003', 'c0012', 'A');
insert into enrollments values('B003', 'c0013', 'A');
insert into enrollments values('B003', 'c0014', 'A');
insert into enrollments values('B003', 'c0015', 'A');
insert into enrollments values('B003', 'c0016', 'A');

insert into enrollments values('B004', 'c0009', 'C');
insert into enrollments values('B004', 'c0010', 'A');

insert into enrollments values  ('B005', 'c0001', 'B');
insert into enrollments values  ('B005', 'c0002', 'A');
insert into enrollments values  ('B005', 'c0003', 'A');
insert into enrollments values  ('B005', 'c0006', 'C');
insert into enrollments values  ('B005', 'c0007', 'A');
insert into enrollments values  ('B005', 'c0008', 'B');

insert into enrollments values  ('B006', 'c0015', 'B');
insert into enrollments values  ('B006', 'c0016', 'A');
insert into enrollments values  ('B006', 'c0018', 'A');


insert into enrollments values  ('B007', 'c0015', 'C');
insert into enrollments values  ('B007', 'c0017', 'A');
insert into enrollments values  ('B007', 'c0018', 'B');
insert into enrollments values  ('B007', 'c0019', 'B');
insert into enrollments values('B008', 'c0002', 'D');

