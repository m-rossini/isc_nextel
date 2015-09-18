package br.com.auster.nextel.isc.filter;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import br.com.auster.common.sql.SQLConnectionManager;
import br.com.auster.common.sql.SQLStatement;
import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.graph.FilterException;
import br.com.auster.dware.graph.Request;
import br.com.auster.dware.graph.ThreadedFilter;
import br.com.auster.nextel.isc.request.sql.SQLRequest;

/**
 * This class is able to get a request (SQLRequest) and and read the data from
 * SQL Tables. In order to do this some configurations are needed.
 * 
 * First in config element a attribute with output buffer size must be defined.
 * 
 * Inside the config element, a database element describing the SQL and DB
 * Connection must be defined. The database element requires the following
 * attributes: driver, wich is the JDBC driver url, wich is the access URL to
 * database (Without usr neither password) userid, which is the userid to be
 * connected to the database passwdfile, with a path to file where the password
 * is stored encrypted, indicates if the password is encrypted in the
 * passwdfile. sqlfile, with the SQL Statement to be executed and read by the
 * filter. If parameters are used (? character) then the element (see below)
 * parameters is required.
 * 
 * 
 * Other configurations are: Inside the config element a parameters element can
 * be configured without attributes Inside this a parameter element (Note:
 * Without the "S" letter) can be configured. The parameter element, represents
 * variable data in the case of parametrized queries
 * 
 * For each SQL parameter one parameter element must be defined. A parameter
 * element has the attributes: name, with the name of the parameter. This name
 * MUST MATCH the key in the request (SQLRequest) attributes Map. With the value
 * in this map being the value to be used on SQL.
 * 
 * And the element columns can also be configured. This element can have
 * multiple column elements inside it. Each of the column elements has the
 * attributes: column, which specifies (In ONE-Based) a list of columns the are
 * gonna be used to generate the request data. The order it is specified is the
 * order that will be used.
 * 
 */
public class SQLMultiRowInputFilter extends ThreadedFilter {

    protected static final String DB_ELEMENT = "database";

    protected static final String URL_ATTR = "url";

    protected static final String DRIVER_ATTR = "driver";

    protected static final String USER_ID_ATTR = "userid";

    protected static final String PFILE_ATTR = "passwdfile";

    protected static final String ENCRYPTED_ATTR = "encrypted";

    protected static final String SFILE_ATTR = "sqlfile";

    protected static final String PARAMETERS_ELEMENT = "parameters";

    protected static final String PARAMETER_ELEMENT = "parameter";

    protected static final String COLUMNS_ELEMENT = "columns";

    protected static final String COLUMN_ELEMENT = "column";

    protected static final String NAME_ATTR = "name";

    protected static final String COLUMN_ATTR = "column";

    protected static final String BUFFER_SIZE_ATTR = "buffer-size";

    protected static final String POOL_NAME_ATTR = "pool-name";

    protected static final String SQL_NAME_ATTR = "sql-name";

    protected static final String DEFAULT_POOL_NAME = "isc-db";

    protected static final String DEFAULT_SQL_NAME = "sqlRequest";

    private WritableByteChannel writer;

    // private final I18n i18n = I18n.getInstance(SQLMultiRowInputFilter.class);
    private static Logger log = Logger.getLogger(SQLMultiRowInputFilter.class);

    // private Connection connection;
    private List parmList = new ArrayList();

    private List colList = new ArrayList();

    private SQLRequest request;

    private ByteBuffer bb;

    private String poolName;

    private String sqlName;

    private SQLConnectionManager connectionManager;

    private SQLStatement sqlStatement;

    private Connection conn = null;
    
    private ResultSet rs = null;

    public SQLMultiRowInputFilter(String name) {
        super(name);
    }

    /*
     * (non-Javadoc)
     * 
     * @see br.com.auster.dware.graph.DefaultFilter#configure(org.w3c.dom.Element)
     */
    public void configure(Element config) throws FilterException {
        this.bb = ByteBuffer.allocateDirect(DOMUtils.getIntAttribute(config,
                BUFFER_SIZE_ATTR, true));

        try {
            Element dbElement = DOMUtils.getElement(config, DB_ELEMENT, false);
            if (dbElement != null) {
                this.poolName = DOMUtils.getAttribute(dbElement, POOL_NAME_ATTR, true);
                this.sqlName = DOMUtils.getAttribute(dbElement, SQL_NAME_ATTR, true);
            } else {
                this.poolName = DEFAULT_POOL_NAME;
                this.sqlName = DEFAULT_SQL_NAME;
            }
            this.connectionManager = SQLConnectionManager.getInstance(this.poolName);
            this.sqlStatement = this.connectionManager.getStatement(this.sqlName);
        } catch (NamingException e1) {
            throw new FilterException(e1);
        } catch (Exception e) {
            throw new FilterException(e);
        }
        // Handle Parameters
        Element parameters = DOMUtils.getElement(config, PARAMETERS_ELEMENT, false);
        NodeList parameter = DOMUtils.getElements(parameters, PARAMETER_ELEMENT);
        int qtd = parameter.getLength();
        for (int i = 0; i < qtd; i++) {
            Element parm = (Element) parameter.item(i);
            this.parmList.add(DOMUtils.getAttribute(parm, NAME_ATTR, true));
        }
        // Handle Columns
        Element columns = DOMUtils.getElement(config, COLUMNS_ELEMENT, false);
        NodeList column = DOMUtils.getElements(columns, COLUMN_ELEMENT);
        qtd = column.getLength();
        for (int i = 0; i < qtd; i++) {
            Element col = (Element) column.item(i);
            int colNo = DOMUtils.getIntAttribute(col, COLUMN_ATTR, true);
            this.colList.add(new Integer(colNo));
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see br.com.auster.dware.graph.DefaultFilter#prepare(br.com.auster.dware.graph.Request)
     */
    public void prepare(Request request) throws FilterException {
        if (request instanceof SQLRequest) {
            this.request = (SQLRequest) request;
        } else {
            throw new IllegalArgumentException("Invalid request type."
                    + request.getClass());
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see br.com.auster.dware.graph.ThreadedFilter#commit()
     */
    public void commit() {
        reset();
    }

    /*
     * (non-Javadoc)
     * 
     * @see br.com.auster.dware.graph.ThreadedFilter#rollback()
     */
    public void rollback() {
         reset();
    }

    /**
     * Sets the writer for this filter, for not using a pipe.
     */
    public final void setOutput(String sinkName, Object output) {
        this.writer = (WritableByteChannel) output;
    }

    public void process() throws FilterException {
        int index = 0, timmCount = 0;;
        this.bb.clear();

        Object[] sqlParms = new Object[parmList.size()];
        for (Iterator itr = this.parmList.iterator(); itr.hasNext();) {
            sqlParms[index] = this.request.getAttributes().get(
                    (String) itr.next());
            index++;
        }
        
        try {
            this.conn = this.connectionManager.getConnection();
            this.rs = this.sqlStatement.executeQuery(conn, sqlParms);
            while (this.rs.next()) {
                timmCount++;
                for (Iterator itr = this.colList.iterator(); itr.hasNext();) {
                    int col = ((Integer) itr.next()).intValue();
                    ReadableByteChannel channel = 
                        Channels.newChannel(this.rs.getBinaryStream(col));
                    int read;
                    while ((read = channel.read(this.bb)) != -1) {
                        this.bb.flip();
                        this.writer.write(this.bb);
                        this.bb.compact();
                    }
                    channel.close();
                    this.bb.clear();
                }
            }
            if (timmCount != 3) {
                throw new FilterException(
                        "Esta fatura não possui 3 TIMM Messages no banco de dados - abortando o processamento.");
            }
        } catch (SQLException sqle) {
            throw new FilterException(sqle);
        } catch (IOException ioe) {
            throw new FilterException(ioe);
        } finally {
            reset();
        }
    }
    
    private void reset() {
        try {
            if (this.writer.isOpen()) {
                this.writer.close();
            }
        } catch (IOException e) {
            log.error("Could not close writer", e);
        }
        try {
            if (this.rs != null) {
                this.rs.close();
                this.rs = null;
            }
        } catch (SQLException e) {
            log.error("Could not close resultset", e);
        }
        try {
            if (this.conn != null && !this.conn.isClosed()) {
                this.conn.close();
                this.conn = null;
            }
        } catch (SQLException e) {
            log.error("Could not close connection", e);
        }
    }
}
