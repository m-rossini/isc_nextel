/*
 * Copyright (c) 2004-2005 Auster Solutions do Brasil. All Rights Reserved.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Created on Apr 13, 2005
 */
package br.com.auster.nextel.isc;

import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.DataAware;
import br.com.auster.dware.manager.GraphManager;
import br.com.auster.dware.manager.LocalGraphGroup;
import br.com.auster.dware.manager.PriorityQueueWishGraphGroup;


/**
 * TODO class comments
 *
 * @author Ricardo Barone
 * @version $Id: Bootstrap.java 27 2006-08-25 15:45:53Z rbarone $
 */

public class BootstrapDevel extends br.com.auster.dware.Bootstrap {
	
	private char[] productId;
  
  private static final String LICENSE_WARN = 
    "#############################################################\n" +
    " WARNING WARNING WARNING\n\n" +
    " This is a development license only! Consumers are fixed to 1\n" +
    " Use another license file for production.\n" +
    "#############################################################";
  
  private boolean isCompatibleMode = false; 

  /**
   * @param configRoot
   */
  public BootstrapDevel() throws java.rmi.RemoteException {
    super();
  }

  /**
   * This method is called in order to check if the resource manage by this run
   * of data-aware is for the same product as this main class
   *
   * @return Returns 0 if the productID is the same or -1 otherwise
   */
  protected final int check() {
    int result = 0;
    final char[] productId = this.dataAware.getLicense().getProductID().toCharArray();
    if (this.productId != null && this.productId.length == productId.length) {
    	for (int i = 0; i < productId.length; i++) {
    		if (this.productId[i] != productId[i]) {
          result = -1;
          break;
    		}
    	}
    } else {
      result = -1;
    }
    
    if (this.isCompatibleMode) {
      log.warn(LICENSE_WARN);
      System.out.println(LICENSE_WARN);
      System.err.println(LICENSE_WARN);
    }
    
    return result;
  }
  
  protected final void preInit(Element config) throws Exception {
  	super.preInit(config);
    Element dwareConf = DOMUtils.getElement(config, DataAware.DWARE_NAMESPACE_URI,
                                            DataAware.CONFIGURATION_ELEMENT, true);
    Element managerConf = DOMUtils.getElement(dwareConf, DataAware.DWARE_NAMESPACE_URI,
                                              DataAware.GRAPH_MANAGER_ELEMENT, true);
    NodeList list = DOMUtils.getElements(managerConf, DataAware.DWARE_NAMESPACE_URI,
                                         GraphManager.LOCAL_GROUP_ELEMENT);
    // counting number of currently configured graph groups
    int graphCount = 0;
    for (int i = 0; i < list.getLength(); i++) {
      Element currentNode = (Element) list.item(i);
      graphCount += DOMUtils.getIntAttribute(currentNode,
                                             LocalGraphGroup.GRAPHS_PER_PROCESSOR_ATTR, false);
      graphCount += DOMUtils.getIntAttribute(currentNode, LocalGraphGroup.MAX_GRAPH_ATTR, false);
    }
    for (int i = 0; i < list.getLength(); i++) {
      Element elt = (Element) list.item(i);
      try {
        if (i == 0) {
          elt.removeAttribute(LocalGraphGroup.GRAPHS_PER_PROCESSOR_ATTR);
          elt.setAttribute(LocalGraphGroup.MAX_GRAPH_ATTR, "1");
          elt.setAttribute(PriorityQueueWishGraphGroup.MAX_WEIGHT, "-1");
        } else {
          managerConf.removeChild(elt);
        }
      } catch (DOMException de) {
        throw new IllegalStateException("This application cannot be run in this machine. Exiting ISC...");
      }
    }
    this.isCompatibleMode = true;
    this.productId = new char[] {
    		'N','X','T','#','I','S','C','D','E','V','#','V','1','.','0','.','0'
    };
  }

  public static final void main(String[] args) throws Exception {
    BootstrapDevel boot = new BootstrapDevel();
    try {
      boot.execute(args);
    } catch (Throwable e) {
      e.printStackTrace();
      if (boot.dataAware != null) {
        boot.dataAware.shutdown(true);
      }
      System.exit(1);
    } 
    System.exit(0);
  }

}
