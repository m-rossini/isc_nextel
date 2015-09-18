package br.com.auster.nextel.xsl.extensions;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeSet;

import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;

import br.com.auster.common.sql.SQLConnectionManager;

public class CGIPrefix {

	protected static final String CGI_TAG = "cgi";

	protected static final String CGI_QUERY = "CGIPrefix";

	protected final static TreeSet cgis = new TreeSet();

	// ##############################
	// ELEMENTS
	// ##############################
	public String getPrefix(XSLProcessorContext context, Element elem) {
		return this.getPrefix(elem.getAttribute(CGI_TAG));
	}

	// ##############################
	// FUNCTIONS
	// ##############################

	/**
	 * Gets the prefix for the given CGI. It will try to match the largers CGI first.
	 * @param cgi the CGI.
	 * @return the prefix for the matched CGI, or null if not found.
	 */
	public static String getPrefix(String cgi) {
		Iterator it = cgis.iterator();
		while (it.hasNext()) {
			CGIObject cgiObj = (CGIObject) it.next();
			if (cgi.startsWith(cgiObj.cgi))
				return cgiObj.prefix;
		}
		return "";
	}

	/******************/
	/* STATIC METHODS */
	/******************/

	/**
	 * Reads the configuration for the CGIs in the table bit.tbit_cgi_prefix 
	 *  in BSCS database. Must be called before any other method.
	 * Each row in the table is one CGI to use in BGH.
	 * @param SQLConnection - connection to BSCS.
	 */
	static {
		Connection conn = null;
		ResultSet rs = null;
		try {
			SQLConnectionManager sql = SQLConnectionManager.getInstance("bscs");
			conn = sql.getConnection();
			rs = sql.getStatement(CGI_QUERY).executeQuery(conn, null);
			while (rs.next()) {
				// be carefull with changes in CGI_QUERY statement in the file of the 
				// configuration of BSCS statements (bscs-statements.xml), because the name 
				// of columns.
				cgis.add(new CGIObject(	rs.getString("ZOCODE"),
																(rs.getString("PREFIX") == null) ? "" : rs
																		.getString("PREFIX"),
																rs.getString("DES"),
																rs.getString("CGI")));
				//System.out.println("Linha: "+rs.getString("ZOCODE")+ " "+((rs.getString("PREFIX")==null)?"":rs.getString("PREFIX"))+" "+rs.getString("DES")+ " "+	rs.getString("CGI"));
			}
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (conn != null) {
					conn.close();			
				}
			} catch (Throwable s) {
				s.printStackTrace();
			}
		}
	}

	/**
	 * This class represents a CGI tag and its attributes.
	 */
	protected static class CGIObject implements Comparable {

		public String zocode;

		public String prefix;

		public String des;

		public String cgi;

		public CGIObject(String zocode, String prefix, String des, String cgi) {
			this.zocode = zocode;
			this.prefix = prefix;
			this.des = des;
			this.cgi = cgi;
		}

		public int compareTo(Object obj) {
			if (obj != null && obj instanceof CGIObject) {
				CGIObject cgiObj = (CGIObject) obj;
				if (cgiObj.cgi.length() < this.cgi.length())
					return -1;
				else
					return 1;
			} else {
				throw new IllegalArgumentException("Must be instance of CGIObject.");
			}
		}
	}

}
