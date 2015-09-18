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
 * Created on Jun 06, 2006
 */
package br.com.auster.nextel.sax;

import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.MultiHandlerReceiverBase;

/**
 * Handles by-contract details  
 * 
 * @author framos
 * @version $Id: ContractOCCHandler.java 159 2008-08-18 22:56:09Z lmorozow $
 */
public class ContractOCCHandler extends MultiHandlerReceiverBase {

	
	

	
	public static final String CONTEXT_CONTRACT_OCC = "contract.occ";

	
	private static final Logger log = Logger.getLogger(ContractOCCHandler.class);

	
	
	
	public ContractOCCHandler() {
	}
	
	/**
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if ("LIN1".equals(_localName)) {
				this.context.setAttribute(CONTEXT_CONTRACT_OCC, new LinkedHashMap());
				log.debug("set new contract-occ map to context");
			}
		}

		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.startElement(_uri, _localName, _qName, _attributes);
	}

	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String _uri, String _localName, String _qName) throws SAXException {
		
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if ("LIN1".equals(_localName)) {
				CallDetailWriter writer = new CallDetailWriter();
				writer.writeOCC(this.context, (Map) this.context.removeAttribute(CONTEXT_CONTRACT_OCC));
			}
		}
		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.endElement(_uri, _localName, _qName);
	}
	
	/**
	 * @see org.xml.sax.ContentHandler#characters(char[], int, int)
	 */
	public void characters(char[] _chars, int _start, int _length) throws SAXException {
		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.characters(_chars, _start, _length);
	}	

}
