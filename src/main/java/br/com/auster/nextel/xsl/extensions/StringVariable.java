package br.com.auster.nextel.xsl.extensions;


import java.util.HashMap;

import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;

public class StringVariable extends Variable {

  protected HashMap variables = new HashMap();

  // ##############################
  // ELEMENTS
  // ##############################
  public void reset(XSLProcessorContext context, Element elem) {
    this.variables.clear();
  }

  // ##############################
  // FUNCTIONS
  // ##############################
  public String getValue(String name) { 
    if ( !this.variables.containsKey(name) ) {
      throw new IllegalArgumentException("[" + this.getClass().getName() + "/getValue] " +
                                         "Variable '" + name + "' does not exist.");
    }
    return (String) this.variables.get(name);
  }

  // ##############################
  // PROTECTED METHODS
  // ##############################
  protected void store(String name, String value) {
    if (name == null) {
      throw new IllegalArgumentException("[" + this.getClass().getName() + "/store] '" +
                                         TAG_NAME + "' cannot be null.");
    }
    if (value == null) { value = ""; }
    this.variables.put(name, value);
  }

}
