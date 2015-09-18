package br.com.auster.nextel.xsl.extensions;


import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;


public abstract  class Variable {

  protected static final String TAG_NAME  = "name";
  protected static final String TAG_VALUE = "value";

  // ##############################
  // ELEMENTS
  // ##############################
  public void setValue(XSLProcessorContext context, Element elem) {
    this.store( elem.getAttribute(TAG_NAME),
		elem.getAttribute(TAG_VALUE) );
  }

  public String getValue(XSLProcessorContext context, Element elem) {
    return this.getValue( elem.getAttribute(TAG_NAME) );
  }


  // ##############################
  // FUNCTIONS
  // ##############################
  public abstract String getValue(String name);

  public String setValue(String name, String value) { 
    this.store(name, value);
    return this.getValue(name);
  }


  // ##############################
  // PROTECTED METHODS
  // ##############################
  protected abstract void store(String name, String value);

}
