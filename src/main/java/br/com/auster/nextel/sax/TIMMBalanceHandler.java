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
 * @version $Id: TIMMBalanceHandler.java 2 2006-07-24 22:57:04Z rbarone $
 */
public class TIMMBalanceHandler extends MultiHandlerReceiverBase {

	
	
	
	public static final String CONTEXT_CYCLE_STARTDATE = "cycle.start";
	public static final String CONTEXT_BALANCE_TOTAL = "balance.total";
	
	
	
	// handles cycle start date
	private boolean foundCycleStartDate;
	private StringBuffer cycleStartDateBuffer;
	
	
	public TIMMBalanceHandler() {
		this.cycleStartDateBuffer = new StringBuffer();
	}
	
	
	/**
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_BALANCE_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if (XMLConstants.INVOICE_DATES_PATH.equals(this.context.getCurrentPath())) {
				this.foundCycleStartDate = XMLConstants.INVOICE_DATETIME_TYPE_STARTDATE_VALUE.equals(_attributes.getValue(XMLConstants.INVOICE_DATETIME_TYPE_ATTR));
			}
		}
		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.startElement(_uri, _localName, _qName, _attributes);
		
	}

	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String _uri, String _localName, String _qName) throws SAXException {

		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_BALANCE_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if ("UNB".equals(_localName)) {
				this.context.setAttribute(CONTEXT_CYCLE_STARTDATE, this.cycleStartDateBuffer.toString());
				this.reset();
			}
		}
		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.endElement(_uri, _localName, _qName);
		
	}

	/**
	 * @see org.xml.sax.ContentHandler#characters(char[], int, int)
	 */
	public void characters(char[] _chars, int _start, int _length) throws SAXException {
		if (TIMMTypeSelectorHandler.DOCUMENT_TYPE_BALANCE_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			if (XMLConstants.INVOICE_DATES_TEXT_PATH.equals(this.context.getCurrentPath())) {
				if (this.foundCycleStartDate) {
					this.cycleStartDateBuffer.append(_chars, _start, _length);
				}
			}
		}
		ContentHandler ch = ((ContentHandler) this.context.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER));
		ch.characters(_chars, _start, _length);
	}
	
	private void reset() {
		this.cycleStartDateBuffer.delete(0, this.cycleStartDateBuffer.length());
	}
}
