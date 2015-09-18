package br.com.auster.nextel.xsl.extensions;

import gnu.trove.TObjectDoubleHashMap;

import java.util.HashMap;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class Aggregate {

    protected static final String TAG_KEY   = "key";
    protected static final String TAG_NAME  = "name";
    protected static final String TAG_VALUE = "value";
    
    // Instance variables
    protected HashMap keysVarMap;
    protected HashMap keysNameMap;
    protected HashMap keysNameMapAux;
    protected String key, auxKey;
    protected Document document;
    
    public Aggregate() 
    throws ParserConfigurationException
    {
        document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        this.keysVarMap = new HashMap();
        this.keysNameMap = new HashMap();
        this.keysNameMapAux = new HashMap();
    }
    
    // ##############################
    // ELEMENTS
    // ##############################
    public void reset(XSLProcessorContext context, Element elem) {
        this.reset();
    }
    
    public void addKey(XSLProcessorContext context, Element elem) {
        this.addKey(elem.getAttribute(TAG_NAME), elem.getAttribute(TAG_KEY));
    }

    public void assembleKey(XSLProcessorContext context, Element elem) {
        this.assembleKey();
    }
    
    public String getValue(XSLProcessorContext context, Element elem) {
        String key = elem.getAttribute(TAG_KEY);
        if (key == null)
            return this.getValue(elem.getAttribute(TAG_NAME));
        else
            return this.getValue(key, elem.getAttribute(TAG_NAME));
    }

    public String getKey(XSLProcessorContext context, Element elem) {
        return this.getKey(elem.getAttribute(TAG_KEY), elem.getAttribute(TAG_NAME));
    }

    public void setValue(XSLProcessorContext context, Element elem) {
        this.setValue(elem.getAttribute(TAG_NAME), elem.getAttribute(TAG_VALUE));
    }
    
    // ##############################
    // FUNCTIONS
    // ##############################
    
    /**
     * Tells this <code>aggregate</code> object to discard all the composed keys and its
     * variables, and be ready for more composed keys and variables to be added.
     */
    public void reset() {
        this.keysVarMap.clear();
        this.keysNameMap.clear();
        this.keysNameMapAux.clear();
        this.auxKey = "";
    }

    /**
     * Adds a key to the <code>aggregate</code> object, so it will be used to compose
     * the final key (the composed key) to define where to get and set variables.
     * @param name the variable name.
     * @param key the variable value (which will be used to compose the final key).
     */
    public void addKey(String name, String key) {
        this.keysNameMapAux.put(name, key);
        this.auxKey += key;
    }

    /**
     * Called when no more key will be added.
     */
    public void assembleKey() {
        // No more key will come. Sets the composed key and prepares for coming variables.
        this.key = this.auxKey;
        this.keysNameMap.put(this.key, this.keysNameMapAux);
        // Clear the auxiliar variables
        this.keysNameMapAux = new HashMap();
        this.auxKey = "";
    }

    /**
     * Gets the value of an variable, using the current composed key.
     * @param name the variable name.
     */
    public String getValue(String name) { 
        return this.getValue(this.key, name);
    }

    /**
     * Gets the value of an variable, using the specified composed key.
     * @param key the composed key which has the variable.
     * @param name the variable name.
     */
    public String getValue(String key, String name) { 
        TObjectDoubleHashMap variables = (TObjectDoubleHashMap)this.keysVarMap.get(key);
        // If we don't have an entry to this composed key then we don't have an entry to this variable.
        if (variables == null) {
            return "0.00";
        }
        // Looks for the variable
        if (variables.containsKey(name))
            return ""+variables.get(name);
        else
            return "0.00";
    }

    /**
     * Gets the value of an key, using the specified composed key.
     * @param key the composed key which has the variable.
     * @param name the key name.
     */
    public String getKey(String key, String name) { 
        HashMap keys = (HashMap)this.keysNameMap.get(key);
        // If we don't have an entry to this composed key then we don't have an entry to this key.
        if (keys == null) {
            return "";
        }
        // Looks for the key
        if (keys.containsKey(name))
            return keys.get(name).toString();
        else
            return "";
    }

    /**
     * Stores a variable value in the hash table of the current composed key.
     * @param name the variable name.
     * @param value the variable value.
     */
    public void setValue(String name, String value) {
        if (name == null) {
            throw new IllegalArgumentException("["+this.getClass().getName()+"/setValue] '" +
                                               TAG_NAME + "' cannot be null.");
        }
        TObjectDoubleHashMap variables = (TObjectDoubleHashMap)this.keysVarMap.get(this.key);
        // If we don't have an entry to this composed key then create one.
        if (variables == null) {
            variables = new TObjectDoubleHashMap();
            this.keysVarMap.put(this.key, variables);
        }
        double val;
        if (value == null || value.length() == 0) {
            val = 0.00;
        } else {
            try {
                val = Double.parseDouble(value);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                val = 0.00;
            }
        }
        variables.put(name, val);
    }
    
    /**
     * Gets a Node that contains all the composed keys.
     * @return a node named "keys" whose each child node is in the form: <key value="key_value"/>
     */
    public Node getKeys() {
      Element root = document.createElement("keys");
      
      Iterator it = this.keysNameMap.keySet().iterator();
      while (it.hasNext()) {
	// For each key, constructs a tag as follows: <key value="key_value"/>
	String key = (String) it.next();
	Element element = document.createElement("key");
	root.appendChild(element);
	element.setAttribute("value", key);
      }
//        System.out.println(COM.nextel.xml.XMLUtils.nodeList2String(root.getChildNodes(), 0, true));
      return root;
    }
	
	
}
