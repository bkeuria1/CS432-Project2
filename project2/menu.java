import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class menu{

	private void deleteStudent(String sid, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.delete_student(?,?); end;");
		cs.setString(1,sid); //pass the sid as the first parameter
		cs.registerOutParameter(2,Types.VARCHAR); //register output parameter
		cs.execute(); //execute query
		String error = cs.getString(2); //get the error message, if needed
		if(error == null){ //if error is null, then there is no error
			System.out.println("Student: " + sid + " was dropped from the table");
		}else{
			System.out.println(error);
		}
		cs.close(); //close connection

	}
	private void dropStudent(String sid, String classid, Connection conn) throws SQLException{
                CallableStatement cs = conn.prepareCall("begin  srs.drop_student(?,?,?); end;");
                cs.setString(1,sid);
                cs.setString(2,classid);

                cs.registerOutParameter(3, Types.VARCHAR); //register the error msg
		cs.registerOutParameter(4, Types.VARCHAR); //register the class status variable
                cs.execute();


                String error = cs.getString(3);
		String classStatus = cs.getString(4); 
                if(error == null){
                        System.out.println("Student: "+ sid + " was dropped from " + classid);
                	if(classStatus!=null){ //if no error and the classStatus message is not null, print out the classStatus msg
				System.out.println(classStatus);
			}
		}else{
                        System.out.println(error);
                }
                cs.close();
        }
     	private void enrollStudent(String sid, String classid, Connection conn) throws SQLException{
                CallableStatement cs = conn.prepareCall("begin  srs.enroll_student(?,?,?); end;");
                cs.setString(1,sid);
		cs.setString(2,classid);
           
                cs.registerOutParameter(3, Types.VARCHAR);
                cs.execute();

        
                String error = cs.getString(3);
                if(error == null){
                	System.out.println("Student: "+ sid + " was enrolled in " + classid);
                }else{
                        System.out.println(error);
                }
                cs.close();
        }
	
	private void getPre(String dept_code, String course_no, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.get_pre(?,?,?); end;");
		cs.setString(1, dept_code);
		cs.setString(2, course_no);
		cs.registerOutParameter(3, OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(3);
	
		//get to see if the cursor is empty
		if(!rs.next()){
			System.out.println("There are no prereq course for this course");
			return;	
		}else{
			 //print out the contents of the cursor
			  do{
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2));
                          }while(rs.next());
		}
	}
	private void getStudentInfo(String sid, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.get_student_info(?,?,?); end;");
		cs.setString(1,sid);
		System.out.println("Getting Student Info");	
		cs.registerOutParameter(2, OracleTypes.CURSOR);	//register the cursor output	
		cs.registerOutParameter(3, Types.VARCHAR); //register the error msg, if any
		cs.execute();		

		ResultSet rs = (ResultSet)cs.getObject(2);
		String error = cs.getString(3); //store the error msg if necessary
		if(error == null){
	   		while (rs.next()) {
                                      	System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getString(3) +
                                        rs.getDouble(4) +
                                        "\t" + rs.getString(5));
                                }
		}else{
			System.out.println(error);
		}
		cs.close();
	}

		private void getClassInfo(String classid, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.get_class_info(?,?,?); end;");
		cs.setString(1,classid);
		System.out.println("Getting Student Info");	
		cs.registerOutParameter(2, OracleTypes.CURSOR);		
		cs.registerOutParameter(3, Types.VARCHAR); 
		cs.execute();		

		ResultSet rs = (ResultSet)cs.getObject(2); //get the cursor
		String error = cs.getString(3); //get the error msg
		if(error == null){ //if no error, print out the contents of the cursor
	   		while (rs.next()) {
                                      	System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getString(3) +
                                        rs.getInt(4) +
                                        "\t" + rs.getString(5)
					+ "\t" + rs.getString(6)  + "\t" + rs.getString(7)  + "\t" + rs.getString(8));
                                }
		}else{
			System.out.println(error);
		}
		cs.close();
	}


	private void insertStudent(String sid, String firstname, String lastname, String status, String gpa, String email, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.insert_student(?,?,?,?,?,?); end;");
		cs.setString(1, sid);
		cs.setString(2,firstname);
		cs.setString(3,lastname);
		cs.setString(4, status);
		cs.setDouble(5,Double.parseDouble(gpa)); //need to conver the GPA into a double
		cs.setString(6, email);
		cs.executeQuery();
		//Any violation of the table constraints
		//will be caught
		//If the insertion is succesfull, print out a message
		System.out.println("The student with sid " + sid + " has been entered into the system");
	}
	private void getTable(String tableChoice, Connection conn) throws SQLException{
		switch(tableChoice){
			case("1"):{
				//print out the students table
				CallableStatement cs = conn.prepareCall("begin  srs.show_students(?); end;");
				
				cs.registerOutParameter(1, OracleTypes.CURSOR);
				
				cs.execute();
				
    			    	ResultSet rs = (ResultSet)cs.getObject(1);
				
				while (rs.next()) {
            				System.out.println(rs.getString(1) + "\t" +
             				rs.getString(2) + "\t" + rs.getString(3) +
                			"\t"+rs.getString(4) +
               			        "\t" + rs.getDouble(5) + "\t" +
                			rs.getString(6));
        			}
				cs.close();
				break;
			}
			case("2"):{
				//print out the enrollments table
			 	CallableStatement cs = conn.prepareCall("begin  srs.show_enrollments(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getString(3));
                                }
				cs.close();
                                break;
			}
			 case("3"):{
				//print out the courses table
                                CallableStatement cs = conn.prepareCall("begin  srs.show_courses(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getString(3));
                                }
				cs.close();
                                break;
                        }
			  case("4"):{
				//print out the classes table
                                CallableStatement cs = conn.prepareCall("begin  srs.show_classes(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getInt(3) 
					+ "\t" + rs.getInt(4) + "\t" + rs.getInt(5) + "\t" +
					rs.getString(6) + "\t" + rs.getInt(7) + "\t" + rs.getInt(8));
                                }
				cs.close();
                                break;
                        }
				
		

		      	case("5"):{
				//print out the prerequisites table
                                CallableStatement cs = conn.prepareCall("begin  srs.show_pre(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getInt(2) + "\t" + rs.getString(3)
                                        + "\t" + rs.getInt(4));
                                }
				cs.close();
                                break;
                        }
		  	case("6"):{
				//print out the logs table
                                CallableStatement cs = conn.prepareCall("begin  srs.show_logs(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getString(2) + "\t" + rs.getString(3) +
                                         "\t" + rs.getString(4) + "\t" + rs.getString(5) + "\t" +
					rs.getString(6));
                                }
				cs.close();
                                break;
                        }

                }
	
                //  conn.close();
	}
	public static void main(String args [])throws SQLException{
		
	try{	
		menu m = new menu();	
		//establish a connection with oracle
		OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
        	ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
        	Connection conn = ds.getConnection("bkeuria1", "BingBong");
		while(true){
		//display the menu options
		System.out.println("Welcome to the student registration system. Please choose an option to begin");
		System.out.println("1. Print out the tables");
		System.out.println("2. Insert a student into a table");
		System.out.println("3. Print out student information");
		System.out.println("4. Get indirect and direct prereq courses");
		System.out.println("5. Get class info");
		System.out.println("6. Enroll Student in a class");
		System.out.println("7. Drop a student from a class");
		System.out.println("8. Delete student from the table");
		System.out.println("9. Exit The Program");
		System.out.print("Your option: ");
		//get user input
		BufferedReader  readKeyBoard;
        	String choice  ;
        	readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
		choice = readKeyBoard.readLine();
		switch(choice){
			case("1"):{
				System.out.println("You chose to print out a table");
				System.out.println("Which table?");
				System.out.println("1. Students");
				System.out.println("2. Enrollments");
				System.out.println("3. Courses");
				System.out.println("4. Classes");
				System.out.println("5. Prereq");
				System.out.println("6. Logs");
				System.out.print("Your Choice: ");
				String tableChoice = readKeyBoard.readLine();
				m.getTable(tableChoice,conn);
				break;
			}
			case("2"):{
				String sid, firstname, lastname, status, gpa, email;
				System.out.print("Enter SID: ");
				sid = readKeyBoard.readLine();
				
				 System.out.print("Enter First Name: ");
                                 firstname = readKeyBoard.readLine();
				
				  System.out.print("Enter Last Name: ");
                                  lastname = readKeyBoard.readLine();

				  System.out.print("Enter Status: ");
                                  status = readKeyBoard.readLine();	
				
                                  System.out.print("Enter GPA: ");
                                  gpa = readKeyBoard.readLine();
				
				  System.out.print("Enter Email: ");
                                  email = readKeyBoard.readLine();
				  m.insertStudent(sid,firstname,lastname,status,gpa,email,conn);
				  break;
			}
			case("3"):{
				String sid;
				System.out.print("Enter sid: ");
				sid = readKeyBoard.readLine();
				m.getStudentInfo(sid,conn);
				break;
			}
			case("4"):{
				String dept_code, course_no;
				System.out.print("Enter department code: ");
				dept_code = readKeyBoard.readLine();
			 	System.out.print("Enter Course No : ");
                                course_no = readKeyBoard.readLine();
				m.getPre(dept_code,course_no, conn);
				break;
			}
		        case("5"):{
				String classid;
				System.out.print("Enter classid: ");
				classid = readKeyBoard.readLine();
				m.getClassInfo(classid,conn);
				break;
                        }
			case("6"):{
				String sid, classid;	
				System.out.print("Enter sid: ");
				sid = readKeyBoard.readLine();	
				System.out.print("Enter classid: ");
				classid = readKeyBoard.readLine();
				m.enrollStudent(sid, classid, conn);
				break;
			
			}
			case("7"):{
				String sid, classid;
                                System.out.print("Enter sid: ");
                                sid = readKeyBoard.readLine();
                                System.out.print("Enter classid: ");
                                classid = readKeyBoard.readLine();
                                m.dropStudent(sid, classid, conn);
                                break;
			}
			case("8"):{
				String sid;
				System.out.print("Enter sid: ");
				sid = readKeyBoard.readLine();
				m.deleteStudent(sid,conn);
				break;
			}
			case("9"):
				System.out.println("Exiting ...");
				conn.close();
				return;
		}
		
	}
	}
	//catch exceptions	
	catch(SQLException ex){
		 System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());	
	}
	 catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n"+ e.getMessage());}
	}
}
