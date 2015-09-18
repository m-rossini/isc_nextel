package br.com.auster.nextel.isc.request.sql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import br.com.auster.common.sql.SQLConnectionManager;
import br.com.auster.common.sql.SQLStatement;
import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.request.BaseRequestBuilder;
import br.com.auster.dware.request.HashRequestFilter;
import br.com.auster.dware.request.RequestFilter;

/***
 * This Class builds requests from a SQL Command.
 * 
 * In order to configure it, one needs to create the requests tag.
 * It represents how the requests are gonna be built.
 * 
 * Inside the request tag weight can be defined, this tag represent how the weight of the request will be populated.
 * Currently the support is for a specific column in result set indicated by the
 * attribute column. Thi sattribute is a ONE-Based list of ordered columns.
 * 
 * Inside the requets tag an id tag can be created and it repreents how the id of the request will be populated.  
 * Currently the support is for a specific column in thre result set of the request builder query.
 * 
 * Another tag inside the requests tag, is the fields tag describing the fields to be populated.
 * Inside the fields tag there is a field tag for each field to populate in the request.
 * Each field will be a request attribute and can be used further the usual way of handling request attributes.
 * Field tag currently supports two attributes. Name and Column. 
 * Name is the attribute/field name and column is a numeric value representing the order of
 * the column in request SQL Statement. It is ONE-based.
 * 
 * Note that fields can be used further during graph processingby the filters, and acctually
 * the SQLMultiRowInputFilter excepts to have attributes in the request.
 * The fields can be used in cases where the SQL for filters uses parameters and the above mentioned
 * filter will use the pair name/column.value to fulfill the filter SQL parameters, thus the number 
 * of fields in request builder must be equals to or greater than the ones used by filter.
 *  
 * @author mtengelm
 *
 */
public class SQLRequestBuilder extends BaseRequestBuilder {

	protected static final String	DB_ELEMENT	= "database";
	protected static final String	SFILE_ATTR	= "sqlfile";
	protected static final String	REQUESTS_ELEMENT	= "requests";
	protected static final String	WEIGHT_ELEMENT	= "weight";
	protected static final String	ID_ELEMENT	= "id";
	protected static final String	COLUMN_ATTR	= "column";
	protected static final String	FIELDS_ELEMENT	= "fields";
	protected static final String	FIELD_ELEMENT	= "field";
	protected static final String	NAME_ATTR	= "name";
	protected static final String	POOL_NAME_ATTR	= "pool-name";
	protected static final String	SQL_NAME_ATTR	= "sql-name";
	private static final String	DEFAULT_POOL_NAME	= "isc-db";
	private static final String	DEFAULT_SQL_NAME	= "sqlRequest";
	
	private static Logger log = Logger.getLogger(SQLRequestBuilder.class);
	
	private Connection	connection;
	private PreparedStatement	prepared;
	private int	weiColumnNumber;
	private int	idColumnNumber;
	private Map reqProps;
	private SQLConnectionManager	connectionManager = null;
	private SQLStatement	statement;
	private String	poolName;
	private String	sqlName;
	
	public SQLRequestBuilder(String name, Element config) {
		super(name, config);
		
		try {
			Element dbElement = DOMUtils.getElement(config, DB_ELEMENT, false);
			if (dbElement != null) {
				poolName = DOMUtils.getAttribute(dbElement, POOL_NAME_ATTR, true);
				sqlName = DOMUtils.getAttribute(dbElement, SQL_NAME_ATTR, true);
			} else {
				poolName = DEFAULT_POOL_NAME;
				sqlName = DEFAULT_SQL_NAME;
			}
			connectionManager = SQLConnectionManager.getInstance(poolName);
			statement = connectionManager.getStatement(sqlName);
			connection = connectionManager.getConnection();
		} catch (NamingException e1) {
			throw new RuntimeException(e1);
		} catch (Exception e) {
      throw new RuntimeException(e);
		}
		
		//Handle Request Creation Parameters
		Element reqsElement = DOMUtils.getElement(config, REQUESTS_ELEMENT, true);
		
		Element weightElement = (Element) DOMUtils.getElement(reqsElement, WEIGHT_ELEMENT, true);
		weiColumnNumber = DOMUtils.getIntAttribute(weightElement, COLUMN_ATTR, true);
		
		Element idElement = (Element) DOMUtils.getElement(reqsElement, ID_ELEMENT, true);				
		idColumnNumber = DOMUtils.getIntAttribute(idElement, COLUMN_ATTR, true);

		//Handle Additional Requests Parameters.
		Element fields = DOMUtils.getElement(reqsElement, FIELDS_ELEMENT, false);
		if (fields != null) {
			reqProps = new HashMap();
			NodeList fieldNode = DOMUtils.getElements(fields, FIELD_ELEMENT);
			int qtd = fieldNode.getLength();
			for (int i=0;i<qtd;i++) {
				Element field = (Element) fieldNode.item(i);
				String fName = DOMUtils.getAttribute(field, NAME_ATTR, true);
				Integer fColumn = new Integer(DOMUtils.getIntAttribute(field, COLUMN_ATTR, true));
				reqProps.put(fName, fColumn);
			}
		}
	}

	public RequestFilter createRequests(Map args) {
		return createRequests(null, args);
	}

	public RequestFilter createRequests(RequestFilter filter, Map args) {
    final RequestFilter requestFilter;
    if (filter == null) {
      requestFilter = new HashRequestFilter();
    } else {
      requestFilter = filter;
    }
    
    final BuilderArgs params = parseArgs(args);
    
    //  request attributes
	Map atts = new HashMap();

    try {
    	ResultSet set = statement.executeQuery(getConnection(), null);		
			while (set.next()) {
				SQLRequest request = new SQLRequest();
				request.setWeight(set.getInt(weiColumnNumber));				
				request.setUserKey(set.getString(idColumnNumber));
				if (reqProps != null) {
					Map properties = new HashMap();
					for (Iterator itr=reqProps.entrySet().iterator();itr.hasNext();) {
						Map.Entry entry = (Entry) itr.next();
						//properties.put(itr, entry);
						int column = ((Integer) entry.getValue()).intValue();
						properties.put(entry.getKey(),set.getString(column));
					}
					atts.putAll(properties);
				}
				
				// insert static attributes and other info
				this.staticAttributes.insertStatics(atts);
				if (params.getTransactionId() != null) {
					request.setTransactionId(params.getTransactionId());
				}
				if (params.getRequestParams() != null) {
					atts.putAll(params.getRequestParams());
				}
				request.setAttributes(atts);
				
				if (!requestFilter.accept(request)) {
					log.debug("Discarded request: " + request);
				}
				
                // prepare the atts map for the next request
				atts.clear();
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		} finally {
  		try {
        if (this.connection != null && !this.connection.isClosed()) {
          this.connection.close();
        }
      } catch (SQLException e) {
        throw new RuntimeException(e);
      }
		}
    
		return requestFilter;
	}

	public Connection getConnection() {
		return this.connection;
	}
	public Statement getStatement() {
		return this.prepared;
	}

}
