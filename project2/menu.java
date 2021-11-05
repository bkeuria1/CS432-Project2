import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class menu{

	public static void main(String args [])throws SQLException{
		
	try{	
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
				break;
			case("10"):
				System.out.println("Exiting ...");
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
