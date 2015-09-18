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
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.MultiHandlerReceiverBase;

/**
 * Handles all information related to the invoice summsheet block.
 * 
 * This ContentHandler doesnot need to forward all SAX events since the TIMMBalanceHandler class
 * 	already does it. 
 * 
 * @author framos
 * @version $Id: TIMMSummsheetHandler.java 113 2008-08-08 00:44:02Z lmorozow $
 */
public class TIMMSummsheetHandler extends MultiHandlerReceiverBase {

	
	
	
	public static final String CONTEXT_SUMMSHEET_STARTDATE = "summsheet.start";
	public static final String CONTEXT_SUMMSHEET_ENDDATE = "summsheet.end";
	
	
	
	private boolean foundStartDate;
	private boolean foundEndDate;
	
	
	public TIMMSummsheetHandler() {
		this.reset();
	}
	
	
	/**
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if (XMLConstants.SUMMSHEET_DATES_PATH.equals(this.context.getCurrentPath())) {
				String qualifier = _attributes.getValue(XMLConstants.SUMMSHEET_DATETIME_TYPE_ATTR);
				this.foundStartDate = XMLConstants.SUMMSHEET_DATETIME_TYPE_167_VALUE.equals(qualifier);
				this.foundEndDate = XMLConstants.SUMMSHEET_DATETIME_TYPE_168_VALUE.equals(qualifier);
			
		} else if (XMLConstants.SUMMSHEET_REFERENCE_PATH.equals(this.context.getCurrentPath())) {
		      if (XMLConstants.SUMMSHEET_REFERENCE_CODE_IT_ATTR.equals(_attributes.getValue(XMLConstants.SUMMSHEET_REFERENCE_CODE_ATTR))) {
		        this.context.setAttribute(XMLConstants.CONTEXT_CUSTCODE, _attributes.getValue(XMLConstants.SUMMSHEET_REFERENCE_VALUE_ATTR));
		      }
		    }

		}
//		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
//		ch.startElement(_uri, _localName, _qName, _attributes);
		
	}

	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String _uri, String _localName, String _qName) throws SAXException {

		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if ("UNB".equals(_localName)) {
				this.reset();
			}
		}
//		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
//		ch.endElement(_uri, _localName, _qName);
		
	}

	/**
	 * @see org.xml.sax.ContentHandler#characters(char[], int, int)
	 */
	public void characters(char[] _chars, int _start, int _length) throws SAXException {
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if (this.foundStartDate) {
				this.context.setAttribute(CONTEXT_SUMMSHEET_STARTDATE, new String(_chars, _start, _length));
			} else if (this.foundEndDate) {
				this.context.setAttribute(CONTEXT_SUMMSHEET_ENDDATE, new String(_chars, _start, _length));
			}
		}
//		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
//		ch.characters(_chars, _start, _length);
	}
	
	
	private void reset() {
		this.foundStartDate = false;
		this.foundEndDate = false;
	}
}
