/*
 * Copyright (c) 2004-2006 Auster Solutions do Brasil. All Rights Reserved.
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
 * Created on Jun 21, 2006
 */
package br.com.auster.nextel.sax;

import org.w3c.dom.Element;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.ContentHandlerPipe;

/**
 * Ugly class to fix LIN4/LIN6 nesting in TIMM message.
 * 
 * @author rbarone
 * @version $Id: TIMMFixerContentHandlerPipe.java 2 2006-07-24 22:57:04Z rbarone $
 */
public class TIMMFixerContentHandlerPipe extends ContentHandlerPipe {
	
	private static final String LIN_4_TAG = "LIN4";
	private static final String LIN_5_TAG = "LIN5";
	private static final String LIN_6_TAG = "LIN6";

	
	
    // -------------------------
    // instance variables
    // -------------------------
	
	private ContentHandler output;
	
	private boolean isParentLin4 = false;
	
	
	public TIMMFixerContentHandlerPipe(Element _config) {
	}

	

	// --------------------
	// ContentHandler API
	// --------------------
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		this.output.characters(ch, start, length);
	}

	public void endDocument() throws SAXException {
		this.output.endDocument();
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		this.output.endElement(uri, localName, qName);
		if (this.isParentLin4) {
			if (localName.equals(LIN_6_TAG)) {
				this.output.endElement(uri, LIN_5_TAG, LIN_5_TAG);
			} else if (localName.equals(LIN_4_TAG)) {
				this.isParentLin4 = false;
			}
		} else if (localName.equals(LIN_5_TAG)) {
			this.isParentLin4 = true;
		}
	}
	
	public void endPrefixMapping(String prefix) throws SAXException {
		this.output.endPrefixMapping(prefix);
	}
	
	public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
		this.output.ignorableWhitespace(ch, start, length);
	}
	
	public void processingInstruction(String target, String data) throws SAXException {
		this.output.processingInstruction(target, data);
	}
	
	public void setDocumentLocator(Locator locator) {
		this.output.setDocumentLocator(locator);
	}
	
	public void skippedEntity(String name) throws SAXException {
		this.output.skippedEntity(name);
	}
	
	public void startPrefixMapping(String prefix, String uri) throws SAXException {
		this.output.startPrefixMapping(prefix, uri);
	}
	
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (localName.equals(LIN_4_TAG)) {
			this.isParentLin4 = true;
		} else if (localName.equals(LIN_5_TAG)) {
			this.isParentLin4 = false;
		} else if (this.isParentLin4 && localName.equals(LIN_6_TAG)) {
			this.output.startElement(uri, LIN_5_TAG, LIN_5_TAG, attributes);
		}
		this.output.startElement(uri, localName, qName, attributes);
	}
	
	public void startDocument() throws SAXException {
		this.isParentLin4 = false;
		this.output.startDocument();
	}

	/**
	 * @see br.com.auster.dware.sax.ContentHandlerPipe#setOutput(org.xml.sax.ContentHandler)
	 */
	public void setOutput(ContentHandler _output) {
		this.output = _output;
	}
}
