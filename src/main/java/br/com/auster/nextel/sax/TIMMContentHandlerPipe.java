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

import org.w3c.dom.Element;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.sax.ContentHandlerPipe;
import br.com.auster.dware.sax.MultiHandlerForwarder;
import br.com.auster.dware.sax.MultiHandlerReceiverCHWrapper;

/**
 * @author framos
 * @version $Id: TIMMContentHandlerPipe.java 2 2006-07-24 22:57:04Z rbarone $
 */
public class TIMMContentHandlerPipe extends ContentHandlerPipe {


	
    // -------------------------
    // configuration constants
    // -------------------------	
	
	public static final String CONF_NUMBER_FORMAT = "number-format";
	public static final String CONF_NUMBER_FORMAT_DEFAULT = "###,###,##0";
	
	public static final String CONF_CURRENCY_FORMAT = "currency-format";
	public static final String CONF_CURRENCY_FORMAT_DEFAULT = "#,###,##0.00";

	public static final String CONTEXT_OUTPUT_HANDLER = "context.output";
	
	
    // -------------------------
    // instance variables
    // -------------------------
	
	private ContentHandler output;
	private MultiHandlerForwarder forwarder;
	
	private ParserHelper numberFormatter;
	private ParserHelper currencyFormatter;	
	
	
	
	
	public TIMMContentHandlerPipe(Element _config) {
		this.forwarder = new MultiHandlerForwarder();
		this.init(_config);
	}

	

	// --------------------
	// ContentHandler API
	// --------------------
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		this.forwarder.characters(ch, start, length);
	}

	public void endDocument() throws SAXException {
		this.forwarder.endDocument();
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		this.forwarder.endElement(uri, localName, qName);
	}
	
	public void endPrefixMapping(String prefix) throws SAXException {
		this.forwarder.endPrefixMapping(prefix);
	}
	
	public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
		this.forwarder.ignorableWhitespace(ch, start, length);
	}
	
	public void processingInstruction(String target, String data) throws SAXException {
		this.forwarder.processingInstruction(target, data);
	}
	
	public void setDocumentLocator(Locator locator) {
		this.forwarder.setDocumentLocator(locator);
	}
	
	public void skippedEntity(String name) throws SAXException {
		this.forwarder.skippedEntity(name);
	}
	
	public void startPrefixMapping(String prefix, String uri) throws SAXException {
		this.forwarder.startPrefixMapping(prefix, uri);
	}
	
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		this.forwarder.startElement(uri, localName, qName, attributes);
	}
	
	public void startDocument() throws SAXException {
		this.forwarder.startDocument();
		// init. context
		this.forwarder.getCurrentContext().setAttribute(CONF_NUMBER_FORMAT, numberFormatter);
		this.forwarder.getCurrentContext().setAttribute(CONF_CURRENCY_FORMAT, currencyFormatter);
		// set output in context
		this.forwarder.getCurrentContext().setAttribute(CONTEXT_OUTPUT_HANDLER, this.output);
	}

	/**
	 * @see br.com.auster.dware.sax.ContentHandlerPipe#setOutput(org.xml.sax.ContentHandler)
	 */
	public void setOutput(ContentHandler _output) {
		this.output = _output;
		this.overrideDefaultHandler();
	}
	
	
	
	// ------------------------
	// private methods
	// ------------------------
	
	private void init(Element _configuration) {

		String nbrFormat = DOMUtils.getAttribute(_configuration, CONF_NUMBER_FORMAT, false);
		if ((nbrFormat == null) || (nbrFormat.length() <= 0)) {
			nbrFormat = CONF_NUMBER_FORMAT_DEFAULT;
		}
		this.numberFormatter = new ParserHelper(nbrFormat);
		
		// configuring currency formatter
		String crcFormat = DOMUtils.getAttribute(_configuration, CONF_CURRENCY_FORMAT, false);
		if ((crcFormat == null)  || (crcFormat.length() <= 0)) {
			crcFormat = CONF_CURRENCY_FORMAT_DEFAULT;
		}
		this.currencyFormatter = new ParserHelper(crcFormat);
		
		this.forwarder.init(_configuration);
		this.overrideDefaultHandler();
	}

	private void overrideDefaultHandler() {
		if ((this.forwarder != null) && (this.output != null)) {
			MultiHandlerReceiverCHWrapper wrapper = new MultiHandlerReceiverCHWrapper();
			wrapper.setContentHandler(this.output);
			this.forwarder.setDefaultHandler(wrapper);
		}
	}
}
