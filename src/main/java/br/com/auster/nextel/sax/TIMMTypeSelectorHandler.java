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

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.MultiHandlerReceiverBase;

/**
 * Handles all information related to the invoice balance block
 * 
 * @author framos
 * @version $Id: TIMMTypeSelectorHandler.java 2 2006-07-24 22:57:04Z rbarone $
 */
public class TIMMTypeSelectorHandler extends MultiHandlerReceiverBase {

	
	public static final String DOCUMENT_ELEMENT = "DOCUMENT";
	public static final String DOCUMENT_TYPE_ATTR = "TYPE";
	public static final String DOCUMENT_TYPE_INVOICE_VALUE = "BCH-PAYMENT";
	public static final String DOCUMENT_TYPE_SUMSHEET_VALUE = "BCH-SUMSHEET";
	public static final String DOCUMENT_TYPE_BALANCE_VALUE = "BCH-BALANCE";
	
	
	
	public static final String CONTEXT_DOCUMENT_TYPE = "document.type";
	
	
	
	
	public TIMMTypeSelectorHandler() {
	}
	
	
	/**
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		if (DOCUMENT_ELEMENT.equals(_localName)) {
			this.context.setAttribute(CONTEXT_DOCUMENT_TYPE, _attributes.getValue(DOCUMENT_TYPE_ATTR));
		}
		ContentHandler handler = (ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER);
		handler.startElement(_uri, _localName, _qName, _attributes);
	}

	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String _uri, String _localName, String _qName) throws SAXException {
		ContentHandler handler = (ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER);
		handler.endElement(_uri, _localName, _qName);
	}
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		ContentHandler handler = (ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER);
		handler.characters(ch, start, length);
	}
}
