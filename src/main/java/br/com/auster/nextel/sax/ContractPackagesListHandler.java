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
 * Created on 08/06/2006
 */
package br.com.auster.nextel.sax;

import java.util.Collection;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.MultiHandlerReceiverBase;

/**
 * @author framos
 * @version $Id: ContractPackagesListHandler.java 36 2006-09-18 22:55:58Z rbarone $
 */
public class ContractPackagesListHandler extends MultiHandlerReceiverBase {
  
  /**
   * {@value} - Boolean: true if parent LIN3 is a contract (CODE = 'CT').
   */
  public static final String CONTEXT_IN_MINUTEPACKAGE = "package.inMinutePackage";
  
  /**
   * {@value} - Boolean: true if this contract has a package that contains
   * the text "MPRP" in it's name, false otherwise.
   */
  public static final String CONTEXT_MINUTEPACKAGE_CONTAINS_MPRP = "package.list.mprp";
	
	
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		
		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		// checking if current LIN3 handles minutePackage
		if (XMLConstants.MINUTEPACKAGE_CTPATH.equals(this.context.getCurrentPath()) &&
        XMLConstants.CONTRACT_CD_CT_VALUE.equals(attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
      this.context.setAttribute(CONTEXT_IN_MINUTEPACKAGE, Boolean.TRUE);
    }
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {

		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		if (XMLConstants.MINUTEPACKAGE_ROOTPATH.equals(this.context.getCurrentPath())) {
      this.context.setAttribute(CONTEXT_IN_MINUTEPACKAGE, Boolean.FALSE);
		}
	}
	
}
