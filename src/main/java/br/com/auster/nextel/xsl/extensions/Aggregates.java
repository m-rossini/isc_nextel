package br.com.auster.nextel.xsl.extensions;

import java.util.HashMap;
import java.util.Iterator;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class Aggregates {

    protected static final String TAG_AGGREGATE  = "aggregate";
    protected static final String TAG_KEY        = "key";
    protected static final String TAG_NAME       = "name";
    protected static final String TAG_VALUE      = "value";
    
    // Instance variables
    protected HashMap aggregates;
    
    public Aggregates() {
        this.aggregates = new HashMap();
    }
    
    // ##############################
    // ELEMENTS
    // ##############################
    public void reset(XSLProcessorContext context, Element elem) 
    throws ParserConfigurationException
    {
      this.reset( elem.getAttribute(TAG_AGGREGATE) );
    }
    
    public void addKey(XSLProcessorContext context, Element elem) {
      this.addKey( elem.getAttribute(TAG_AGGREGATE), 
		   elem.getAttribute(TAG_NAME),
		   elem.getAttribute(TAG_KEY) ); 
    }

    public void assembleKey(XSLProcessorContext context, Element elem) {
      this.assembleKey( elem.getAttribute(TAG_AGGREGATE) );
    }
    
    public String getValue(XSLProcessorContext context, Element elem) {
      return this.getValue( elem.getAttribute(TAG_AGGREGATE), 
			    elem.getAttribute(TAG_KEY),
			    elem.getAttribute(TAG_NAME) );
    }

    public String getKey(XSLProcessorContext context, Element elem) {
      return this.getKey( elem.getAttribute(TAG_AGGREGATE), 
			  elem.getAttribute(TAG_KEY), 
			  elem.getAttribute(TAG_NAME) );
    }

    public void setValue(XSLProcessorContext context, Element elem) {
      this.setValue( elem.getAttribute(TAG_AGGREGATE), 
		     elem.getAttribute(TAG_NAME), 
		     elem.getAttribute(TAG_VALUE) );
    }
    
    // ##############################
    // FUNCTIONS
    // ##############################
    
    /**
     * Tells this <code>aggregate</code> object to discard all the composed keys and its
     * variables, and be ready for more composed keys and variables to be added.
     * @param aggregateName the aggregate name.
     */
    public void reset(String aggregateName) 
    throws ParserConfigurationException
    {
      if (aggregateName != null) {
	if ( this.aggregates.containsKey(aggregateName) ) {
	  ( (Aggregate) this.aggregates.get(aggregateName) ).reset();
	} else {
	  Aggregate aggregate = new Aggregate();
	  aggregate.reset();
	  this.aggregates.put(aggregateName, aggregate);
	}
      } else {
	Iterator it = this.aggregates.values().iterator();
	while ( it.hasNext() ) {
	  ( (Aggregate) it.next() ).reset();
	}
      }
    }

    /**
     * Adds a key to the <code>aggregate</code> object, so it will be used to compose
     * the final key (the composed key) to define where to get and set variables.
     * @param aggregateName the aggregate name.
     * @param key the variable value (which will be used to compose the final key).
     * @param name the variable name.
     */
    public void addKey(String aggregateName, String name, String key) {
      this.findAggregate(aggregateName).addKey(name, key);
    }

    /**
     * Called when no more key will be added.
     * @param aggregateName the aggregate name.
     */
    public void assembleKey(String aggregateName) {
      this.findAggregate(aggregateName).assembleKey();
    }

    /**
     * Gets the value of an variable, using the current composed key.
     * @param aggregateName the aggregate name.
     * @param key the composed key which has the variable.
     * @param name the variable name.
     */
    public String getValue(String aggregateName, String key, String name) { 
      Aggregate aggregate = this.findAggregate(aggregateName);
      if (key == null)
	return aggregate.getValue(name);
      else
	return aggregate.getValue(key, name);
    }

    /**
     * Gets the value of an variable, using the current composed key.
     * @param aggregateName the aggregate name.
     * @param name the variable name.
     */
    public String getValue(String aggregateName, String name) { 
      return this.findAggregate(aggregateName).getValue(name);
    }

    /**
     * Gets the value of an key, using the specified composed key.
     * @param aggregateName the aggregate name.
     * @param key the composed key which has the variable.
     * @param name the key name.
     */
    public String getKey(String aggregateName, String key, String name) { 
      return this.findAggregate(aggregateName).getKey(key, name);
    }

    /**
     * Stores a variable value in the hash table of the current composed key.
     * @param aggregateName the aggregate name.
     * @param name the variable name.
     * @param value the variable value.
     */
    public void setValue(String aggregateName, String name, String value) {
      this.findAggregate(aggregateName).setValue(name, value);
    }
    
    /**
     * Gets the root node that contains all the composed keys.
     * @param aggregateName the aggregate name.
     * @return a node named "keys" whose each child node is in the form: <key value="key_value"/>
     */
    public Node getKeys(String aggregateName) 
    throws ParserConfigurationException
    {
      return this.findAggregate(aggregateName).getKeys();
    }

  private Aggregate findAggregate(String name) {
    if (name == null) {
      throw new IllegalArgumentException("["+this.getClass().getName()+"/verifyAggregate] '" +
					 TAG_NAME + "' cannot be null.");
    }
    if ( !this.aggregates.containsKey(name) ) {
      throw new IllegalArgumentException("["+this.getClass().getName()+"/verifyAggregate] " +
					 "aggregate '" + name + "' does not exist.");
    }
    return (Aggregate) this.aggregates.get(name);
  }
	
}
