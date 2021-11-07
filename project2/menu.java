import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class menu{
	private void insertStudent(String sid, String firstname, String lastname, String status, String gpa, String email, Connection conn) throws SQLException{
		CallableStatement cs = conn.prepareCall("begin  srs.insert_student(?,?,?,?,?,?); end;");
		cs.setString(1, sid);
		cs.setString(2,firstname);
		cs.setString(3,lastname);
		cs.setString(4, status);
		cs.setDouble(5,Double.parseDouble(gpa));
		cs.setString(6, email);
		cs.executeQuery();
		System.out.println("The student with sid " + sid + " has been entered into the system");
	}
	private void getTable(String tableChoice, Connection conn) throws SQLException{
		switch(tableChoice){
			case("1"):{
				CallableStatement cs = conn.prepareCall("begin  srs.show_students(?); end;");
				
				cs.registerOutParameter(1, OracleTypes.CURSOR);
				
				cs.execute();
				
    			    	ResultSet rs = (ResultSet)cs.getObject(1);
				
				while (rs.next()) {
            				System.out.println(rs.getString(1) + "\t" +
             				rs.getString(2) + "\t" + rs.getString(3) +
                			rs.getString(4) +
               			        "\t" + rs.getDouble(5) + "\t" +
                			rs.getString(6));
        			}
				cs.close();
				break;
			}
			case("2"):{
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
                                CallableStatement cs = conn.prepareCall("begin  srs.show_logs(?); end;");

                                cs.registerOutParameter(1, OracleTypes.CURSOR);

                                cs.execute();

                                ResultSet rs = (ResultSet)cs.getObject(1);

                                while (rs.next()) {
                                        System.out.println(rs.getString(1) + "\t" +
                                        rs.getInt(2) + "\t" + rs.getString(3) +
                                         "\t" + rs.getInt(4) + "\t" + rs.getString(5) + "\t" +
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
		OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
        	ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
        	Connection conn = ds.getConnection("bkeuria1", "BingBong");
		while(true){
		System.out.println("Welcome to the student registration system. Please choose an option to begin");
		System.out.println("1. Print out the tables");
		System.out.println("2. Insert a student into a table");
		System.out.println("3. Print out student information");
		System.out.println("5. Get indirect and direct prereq courses");
		System.out.println("6. Get class info");
		System.out.println("7. Enroll Student in a class");
		System.out.println("8. Drop a student from a class");
		System.out.println("9. Delete student from the table");
		System.out.println("10. Exit The Program");
		System.out.print("Your option: ");

		BufferedReader  readKeyBoard;
        	String choice  ;
        	readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
		choice = readKeyBoard.readLine();
		switch(choice){
			case("1"):
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
			case("2"):
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
			case("10"):
				System.out.println("Exiting ...");
				conn.close();
				return;
		}
		
	}
	}	
	catch(SQLException ex){
		 System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());	
	}
	 catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
	}
}
