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

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import br.com.auster.common.io.IOUtils;
import br.com.auster.common.security.ResourceReady;
import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.DataAware;
import br.com.auster.dware.manager.GraphManager;
import br.com.auster.dware.manager.LocalGraphGroup;
import br.com.auster.dware.manager.PriorityQueueWishGraphGroup;


/**
 * TODO class comments
 *
 * @author Ricardo Barone
 * @version $Id: Bootstrap.java 85 2008-04-30 23:23:29Z rbarone $
 */

public class Bootstrap extends br.com.auster.dware.Bootstrap {
	
  private static final String VERSION = "1.0.3-b2";
  
  private static final char[] CPU_PATTERN = new char[] { 
      '\\', '[', 'C', 'P', 'U', '=', '(', '-', '?', '\\', 'd', '+', ')', '\\', ']', '$' }; 
  
  private static final float MAX_GRAPHS_FACTOR = 1.5f;
  
  private char[] productId;
  
  private static final String LICENSE_WARN = 
    "##########################################################################\n" +
    " WARNING WARNING WARNING\n\n" +
    " This machine has more processors than what your \n" +
    " license allows. ISC is now ignoring you're consumer (graph)\n" +
    " configuration and will run with a limited quantity of consumers.\n" +
    " To avoid this limitation you have three options:\n" +
    "    1) Upgrade you're license;\n" +
    "    2) Lower the number of consumers in your configuration;\n" +
    "    3) Install and use in a machine with the allowed number of processors.\n" +
    "##########################################################################";
  
  private static final String TRIAL_WARN = 
    "###################################################\n" +
    " TRIAL VERSION - Not Authorized for production use\n" +
    "###################################################\n";
      
  private boolean isCompatibleMode = false; 
  private int cpuPosition = -1;

  /**
   * @param configRoot
   */
  public Bootstrap() throws java.rmi.RemoteException {
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
    final int realLength = this.cpuPosition < 0 ? productId.length : this.cpuPosition; 
    if (this.productId != null && this.productId.length == realLength) {
    	for (int i = 0; i < realLength; i++) {
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
  
  private void preCheckLicense(Element config) {
      ResourceReady license;
      ObjectInputStream ois = null;
      try {
        InputStream fis = IOUtils.openFileForRead(ResourceReady.LICENSE_FILE);
        GZIPInputStream gis = new GZIPInputStream(fis);
        ois = new ObjectInputStream(gis);
        Object myObj = ois.readObject();
        license = (ResourceReady) myObj;
      } catch (FileNotFoundException e) {
        throw new IllegalAccessError("License file not found at: " + 
                                     ResourceReady.LICENSE_FILE.getPath());
      } catch (IOException e) {
        e.printStackTrace();
        throw new IllegalAccessError("See previous exception.");
      } catch (ClassNotFoundException e) {
        e.printStackTrace();
        throw new IllegalAccessError("See previous exception.");
      } finally {
        try { 
          if (ois != null) {
            ois.close();
          }
        } catch (IOException e) {}
      }
      
      int maxCpu = 4;
      final Matcher matcher = Pattern.compile(new String(CPU_PATTERN)).matcher(license.getProductID());
      if (matcher.find()) {
          try {
              maxCpu = Integer.parseInt(matcher.group(1));
              this.cpuPosition = matcher.start();
          } catch (Exception e) {}
      }
      
      // if maxCpu < 0, this is an unlimited version
      // if maxCpu == 0, this is a trial version (mandatory to have a date-limit)
      // if maxCpu > 0, this is a cpu-limited version
      if (maxCpu > 0 || (maxCpu == 0 && license.getData().get(5) == null) || license.canRun() > 0) {
          // CPU limit will be enforced
          checkCPU(config, maxCpu);
      } else if (maxCpu == 0) {
          log.warn(TRIAL_WARN);
          System.out.println(TRIAL_WARN);
          System.err.println(TRIAL_WARN);
      }
  }
  
  private final void checkCPU(Element config, int maxCpu) {
      final int availableCpu = Runtime.getRuntime().availableProcessors();
        if (availableCpu <= maxCpu) {
            return;
        }
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
            graphCount += availableCpu * DOMUtils.getIntAttribute(currentNode,
                    LocalGraphGroup.GRAPHS_PER_PROCESSOR_ATTR, false);
            graphCount += DOMUtils.getIntAttribute(currentNode,
                    LocalGraphGroup.MAX_GRAPH_ATTR, false);
        }
        System.out.println("GRAPH COUNT = " + graphCount);
        // only override configuration if previous count is higher then maxCpu * factor
        final int maxGraphs = (int) (maxCpu * MAX_GRAPHS_FACTOR);
        if (graphCount > maxGraphs) {
            for (int i = 0; i < list.getLength(); i++) {
                Element elt = (Element) list.item(i);
                try {
                    if (i == 0) {
                        elt.removeAttribute(LocalGraphGroup.GRAPHS_PER_PROCESSOR_ATTR);
                        elt.setAttribute(LocalGraphGroup.MAX_GRAPH_ATTR, String.valueOf(maxGraphs));
                        elt.setAttribute(PriorityQueueWishGraphGroup.MAX_WEIGHT, "-1");
                    } else {
                        managerConf.removeChild(elt);
                    }
                } catch (DOMException de) {
                    throw new IllegalStateException(
                            "This application cannot be run in a machine with more than " +
                            maxCpu + " CPUs. Exiting ISC...");
                }
            }
            this.isCompatibleMode = true;
        }
    }
  
  protected final void preInit(Element config) throws Exception {
    log.info("AUSTER ISC v" + VERSION + " - INITIALIZING");
  	super.preInit(config);
  	preCheckLicense(config);
    this.productId = new char[] {
    		'N','X','T','#','I','S','C','#','V','1','.','0','.','0'
    };
  }

  public static final void main(String[] args) throws Exception {
    Bootstrap boot = new Bootstrap();
    try {
      boot.execute(args);
    } catch (Throwable e) {
      e.printStackTrace();
      if (boot.dataAware != null) {
        boot.dataAware.shutdown(true);
      }
      System.exit(1);
    }
    log.info("AUSTER ISC v" + VERSION + " - SHUTTING DOWN");
    System.exit(0);
  }

}
