package br.com.auster.nextel.isc;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TIMMLoader {

	public static final String	DRIVER	= "oracle.jdbc.driver.OracleDriver";
	private static final String	URL			= "jdbc:oracle:thin:@//jean:1521/XE";
	private Connection					connection;

	public void connect() throws ClassNotFoundException, SQLException {
		Class.forName(DRIVER);
		connection = DriverManager.getConnection(URL, "nextel", "nextel123");
	}

	public void load(String file) throws IOException, SQLException {
		BufferedReader br = new BufferedReader(new FileReader(file));
		String record;

		String insert = "insert into DOCUMENT_ALL VALUES(?, ?, ?, ?, ?)";
		PreparedStatement statement = connection.prepareStatement(insert);

		while ((record = br.readLine()) != null) {
			String piece[] = record.split(";");
			if (piece.length != 5) {
				System.err.println("Pieces lenght is " + piece.length + " and should be 5");
			}
			statement.clearParameters();
			statement.setInt(1, Integer.parseInt(piece[0]));
			statement.setInt(2, Integer.parseInt(piece[1]));
			statement.setInt(3, Integer.parseInt(piece[2]));
			statement.setInt(4, Integer.parseInt(piece[3]));
			statement.setBytes(5, piece[4].getBytes());

			statement.execute();
		}

		connection.commit();
	}

	public void dumpTable() throws SQLException {
		String SQL = "select * from DOCUMENT_ALL order by cycle_date, customer_id, type_id";
		Statement statement = connection.createStatement();
		ResultSet set = statement.executeQuery(SQL);
		while (set.next()) {
			System.out.println(set.getInt(1));
			System.out.println(set.getInt(2));
			System.out.println(set.getInt(3));
			System.out.println(set.getInt(4));
			//System.out.println(new String(set.getBytes(5)));
		}
	}

	/**
	 * @param args
	 * @throws IOException
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public static void main(String[] args) throws IOException, ClassNotFoundException,
			SQLException {
		TIMMLoader loader = new TIMMLoader();
		loader.connect();
		if (args.length == 1 || (args.length > 1 && args[1].equals("Y"))) {
			loader.load(args[0]);
		}
		loader.dumpTable();
		System.exit(0);
	}

}
