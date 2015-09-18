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

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

import br.com.auster.dware.sax.MultiHandlerContext;
import br.com.auster.dware.sax.MultiHandlerReceiverBase;

/**
 * @author framos
 * @version $Id: ContractUsageDetailHandler.java 363 2008-10-24 21:33:13Z gportuga $
 */
public class ContractUsageDetailHandler extends MultiHandlerReceiverBase {

	
	
	public static final String CONTEXT_COUNT_USAGE = "usage.count";
	public static final String CONTEXT_VALUE_USAGE = "usage.value";
	
	
	
	private CallDetailAccumulator accumulator;
	
	
	
	
	public ContractUsageDetailHandler() {
	}
	
	public void setContext(MultiHandlerContext _context) {
		super.setContext(_context);
		
		this.accumulator = new CallDetailAccumulator(this.context);
	}
	
	
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		
		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		String serviceId = _attributes.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR);
		String typeIndicator = _attributes.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR);
	
		if (XMLConstants.SERVICE_NAME_CIRDT_VALUE.equals(serviceId)) {
      this.accumulator.handleDataServices(_attributes, serviceId);
//    EHO: Mudança mms outras operadoras
    } else if ( XMLConstants.SERVICE_NAME_LOLGT_VALUE.equals(serviceId) ||
				        XMLConstants.SERVICE_NAME_TP_VALUE.equals(serviceId) ||
   				        XMLConstants.SERVICE_NAME_DRin_VALUE.equals(serviceId) || 
				        XMLConstants.SERVICE_NAME_MMST_VALUE.equals(serviceId) || 
				        XMLConstants.SERVICE_NAME_MMSI_VALUE.equals(serviceId) ) {
			this.accumulator.handleDataServices(_attributes, serviceId);
      this.accumulator.handleOnlineServices(_attributes, _localName);
      
    } else if (this.accumulator.isOnlineUnderAccumulation()) {
      this.accumulator.handleOnlineServices(_attributes, _localName);
      
    } else if (XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE.equals(serviceId)) {
      this.accumulator.handleDataServices(_attributes, serviceId);
      this.accumulator.handleDownloadServices(_attributes, serviceId);
      
		} else if (this.accumulator.isDownloadUnderAccumulation()) {
			this.accumulator.handleDownloadServices(_attributes, _localName);
      
		} else if (XMLConstants.SERVICE_NAME_DISPG_VALUE.equals(serviceId) ||
				       XMLConstants.SERVICE_NAME_DISPP_VALUE.equals(serviceId)) {
			// SEE bgh-invoice-contract-details-xsl (Line 84)
			 this.accumulator.handleDispatch(_attributes);
			 
		} else if ( 
        XMLConstants.SERVICE_NAME_IDCD_VALUE.equals(serviceId) ||
			  ( 
            this.accumulator.isIDCDUnderAccumulation() && 
			      (XMLConstants.IDCD_DISCOUNT_ELEMENT.equals(_localName) || 
             XMLConstants.IDCD_CRTIME_ELEMENT.equals(_localName)) 
        ) 
		  ) {
			// SEE bgh-invoice-contract-details-xsl (Line 171)
			this.accumulator.handleIDCD(new AttributesImpl(_attributes), _localName);
			
			
		} else if ( 
        ( 
            (XMLConstants.SERVICE_NAME_TELAL_VALUE.equals(serviceId) || 
             XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(serviceId)) &&
			      (XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndicator) ||
			       XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndicator) ||
				     XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeIndicator))
			  ) ||
			  (
            this.accumulator.isTelephonyUnderAccumulation() && 
			     (XMLConstants.TEL_INBOUND_ELEMENT.equals(_localName) || 
            XMLConstants.TEL_OUTBOUND_ELEMENT.equals(_localName) || 
			      XMLConstants.TEL_CHARGEINFO_ELEMENT.equals(_localName) || 
            XMLConstants.TEL_CRTIME_ELEMENT.equals(_localName) || 
			      XMLConstants.TEL_CALLORIGIN_ELEMENT.equals(_localName) || 
            XMLConstants.TEL_CALLDESTINATION_ELEMENT.equals(_localName))
        )
			) {
			// SEE bgh-invoice-contract-details-xsl (Line 197 and
			this.accumulator.handleTelephony(new AttributesImpl(_attributes), _localName);
		} else {
      
    }
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		if ( XMLConstants.USAGE_ELEMENT.equals(localName) ) {
			if (this.accumulator.isTelephonyUnderAccumulation()) {
				this.accumulator.accumulateTelephony();
			} else if (this.accumulator.isDownloadUnderAccumulation()) {
				this.accumulator.accumulateDownloads();
			} else if (this.accumulator.isIDCDUnderAccumulation()) {
				this.accumulator.accumulateIDCD();
			} else if (this.accumulator.isOnlineUnderAccumulation()) {
        this.accumulator.accumulateOnline();
      }
		}
	}
	
	public void reset() {
	}
	
}
