package br.com.auster.nextel.xsl.extensions;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import br.com.auster.common.lang.StringUtils;


public class DoubleFunctions {
	
	private static final String REPLACE_FROM = ",.";
	private static final String REPLACE_TO = ".";
	
  public static double sum(NodeList nodes) {
    double sum = 0.0;

//    LocalizedNumber ln = new LocalizedNumber();
    
//    long now = System.nanoTime();
    for (int i = 0; i < nodes.getLength(); i++) {
   	 Node node = (Node) nodes.item(i);
   	 
      String value = null;
      switch (node.getNodeType()) {
      case Node.TEXT_NODE:
      case Node.CDATA_SECTION_NODE:
      case Node.ATTRIBUTE_NODE:
     	 value = node.getNodeValue();
     	 break;
      case Node.COMMENT_NODE:
      case Node.PROCESSING_INSTRUCTION_NODE:
      case Node.ELEMENT_NODE:
      case Node.ENTITY_REFERENCE_NODE:
      default:
     	 break;
      }
      
      if (value != null) {
     	 	value = StringUtils.replaceChars(value, REPLACE_FROM, REPLACE_TO);
     	  sum += Double.parseDouble(value);
//      	sum += ln.localizeNumber(null, value, "pt").doubleValue();
      }
    }
//    System.out.println("Time = " + (System.nanoTime() - now));

    return sum;
  }

}
