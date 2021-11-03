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
	}catch(SQLException ex){
		 System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());	
	}
	}
}
