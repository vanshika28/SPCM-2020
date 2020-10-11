
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getDBConnection() {
        Connection con;
        try {
        	Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vms", "root", "");
			return con;
        } catch (Exception ex) {
        	ex.printStackTrace();
        	return null;
        }//try catch closed
    }//getDBConnection() closed
}//class closed
 