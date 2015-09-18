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

 
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import br.com.auster.common.sql.SQLConnectionManager;
import br.com.auster.dware.sax.MultiHandlerReceiverBase;
import br.com.auster.nextel.xsl.extensions.PhoneNumber;

/**
 * Handles by-contract details  
 * 
 * @author framos
 * @version $Id: ContractSummaryHandler.java 363 2008-10-24 21:33:13Z gportuga $
 */
public class ContractSummaryHandler extends MultiHandlerReceiverBase {

	
	public static final String CONTEXT_CONTRACT_CODE = "contract.code";
	public static final String CONTEXT_CONTRACT_IMEI = "contract.imei";
	public static final String CONTEXT_CONTRACT_TYPE = "contract.type";
	public static final String CONTEXT_CONTRACT_FLEET = "contract.fleet";
	public static final String CONTEXT_CONTRACT_MEMBER = "contract.member";
	public static final String CONTEXT_CONTRACT_HOLDER = "contract.holder";
	public static final String CONTEXT_CONTRACT_PHONENUMBER = "contract.phoneNumber";
	public static final String CONTEXT_CONTRACT_PHONENUMBER_PREFIX = "contract.phoneNumber.prefix";
	
	public static final String CONTEXT_CONTRACT_MONTHLYFEE_VALUE = "contract.value.monthlyfee";
	public static final String CONTEXT_CONTRACT_ADDITIONAL_VALUE = "contract.value.additional";
	public static final String CONTEXT_CONTRACT_ONLINE_VALUE = "contract.value.online";
	public static final String CONTEXT_CONTRACT_SUBTOTAL_VALUE = "contract.value.subtotal";
	public static final String CONTEXT_CONTRACT_DISCOUNTS_VALUE = "contract.value.discounts";

	
	private static final Logger log = Logger.getLogger(ContractSummaryHandler.class);
	
	
	private double contractSubtotal;
	private boolean previousWasSN;
	private Map occDetail;
	
	private CallDetailWriter writer;
	
	
	public ContractSummaryHandler() {
		this.writer = new CallDetailWriter();
	}
	
	
	
	/** 
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {
		
		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		//EHO: SYSOUT CUSTCODE

		if (XMLConstants.CONTRACT_PATH.equals(this.context.getCurrentPath())) {
			//System.out.println(this.context.getAttribute(XMLConstants.CONTEXT_CUSTCODE));		

			// contract id
			if (XMLConstants.CONTRACT_CD_CO_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				this.reset();
				this.context.setAttribute(CONTEXT_CONTRACT_CODE, _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR));
				
				log.debug("started contract [" + this.context.getAttribute(CONTEXT_CONTRACT_CODE) + "]");
			// imei
			} else if (XMLConstants.CONTRACT_CD_SMNUM_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				this.context.setAttribute(CONTEXT_CONTRACT_IMEI, _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR));
				this.findMibasInformation();
			// contract type
			} else if (XMLConstants.CONTRACT_CD_MRKT_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				this.context.setAttribute(CONTEXT_CONTRACT_TYPE, _attributes.getValue(XMLConstants.CONTRACT_SHORTVALUE_ATTR));
			// phone number
			} else if ((XMLConstants.CONTRACT_CD_DIRNUM_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) && previousWasSN) {
//				String contractPhoneNumber = _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR);
//				PhoneNumber pn = new PhoneNumber();
//				pn.parse(contractPhoneNumber);
//				this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER_PREFIX, pn.getAreaCode());
//				this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER, contractPhoneNumber);
				this.findMibasInformation();

				// other credits & charges
			} else if (XMLConstants.CONTRACT_CD_FE_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR)) && (this.occDetail != null)) {
				this.occDetail.put(XMLConstants.CONTRACT_FULLVALUE_ATTR, _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR));
				log.debug("found occDetail fullValue of " + _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR));
			}
			// marks if this IMD/ITEM has CODE='SN' and service is telephony
			previousWasSN = ((XMLConstants.CONTRACT_CD_SN_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) &&
			                  (XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_SHORTVALUE_ATTR)) || 
			                   XMLConstants.SERVICE_NAME_TELAL_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_SHORTVALUE_ATTR))));
			
		} else if (XMLConstants.CONTRACT_OCC_PATH.equals(this.context.getCurrentPath())) {
			if (XMLConstants.CONTRACT_OCC_TMDES_O_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_OCC_TMDES_ATTR))) {
//				this.occDetail = new LinkedHashMap();
				this.occDetail = (Map) this.context.getAttribute(ContractOCCHandler.CONTEXT_CONTRACT_OCC);
				log.debug("reset occDetail list");
			}
		} else if (XMLConstants.CONTRACT_OCC_DATETIME_PATH.equals(this.context.getCurrentPath()) && (this.occDetail != null)) {
			this.occDetail.put(XMLConstants.INVOICE_DATETIME_TYPE_ATTR, _attributes.getValue(XMLConstants.INVOICE_DATETIME_TYPE_ATTR));
			log.debug("found occDetail type of " + _attributes.getValue(XMLConstants.INVOICE_DATETIME_TYPE_ATTR));			
		} else if (XMLConstants.CONTRACT_SUBTOTAL_PATH1.equals(this.context.getCurrentPath())) {
			// occ charge
			if (XMLConstants.CONTRACT_AMOUNT_TYPE_203_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_TYPE_ATTR)) && (this.occDetail != null)) {
				
				String occDate = (String)this.occDetail.remove(XMLConstants.INVOICE_DATETIME_TYPE_ATTR);
				String occDesc = (String)this.occDetail.remove(XMLConstants.CONTRACT_FULLVALUE_ATTR);
				if ((occDate != null) && (occDesc != null)) {
					String key = occDate + "|" + occDesc;
					ParserHelper parser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
					Number amount = parser.parseNumber(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_VALUE_ATTR));
					if (this.occDetail.containsKey(key)) {
						Number previous = (Number)this.occDetail.get(key);
						amount = new Double(previous.doubleValue() + amount.doubleValue());
					}
					this.occDetail.put(key, amount);
					log.debug("added occDetail charge of " + amount + " for key " + key);
				} else {
					log.warn("occDetail discarded since no qualifier or description was found");
				}
			} else if (XMLConstants.CONTRACT_AMOUNT_TYPE_931_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_TYPE_ATTR))) {
				ParserHelper parser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
				Number nb = parser.parseNumber(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_VALUE_ATTR));
				if (nb != null) { 
					this.contractSubtotal += nb.doubleValue(); 
				}
			}
			
//			--------------------------------------------------
//			--------------------------------------------------
//			TODO: REVEW THIS!!!!
//			THIS CONDITION IS DEFINED IN bgh-invoice-contract.xsl (line 123)
//			THERE, ITS SAID THAT THIS DOES NOT LOOK CORRECT, SO ITS NOT BEING HANDLED HERE
//			--------------------------------------------------
//		} else if (CONTRACT_SUBTOTAL_PATH2.equals(this.context.getCurrentPath()) &&
//			       CONTRACT_AMOUNT_TYPE_919_VALUE.equals(_attributes.getValue(CONTRACT_AMOUNT_TYPE_ATTR))) {
//			this.accumulator.handleContractSubtotal(attributes.getValue(CONTRACT_AMOUNT_VALUE_ATTR));
//			--------------------------------------------------
//			--------------------------------------------------
		}
	}

	
	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String _uri, String _localName, String _qName) throws SAXException {
		
		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		if (XMLConstants.CONTRACT_ELEMENT.equals(_localName)) {
			if (this.context.hasAttribute(CONTEXT_CONTRACT_CODE)) {
				// setting final values
				this.context.setAttribute(CONTEXT_CONTRACT_SUBTOTAL_VALUE, new Double(this.contractSubtotal));
				// write out
				log.debug("my OCCDetails is " + this.occDetail);
				this.writer.writeContractCalls(this.context);
				this.reset();
			}
		}
	}

	
	/**
	 * @see org.xml.sax.ContentHandler#characters(char[], int, int) 
	 */
	public void characters(char[] _chars, int _start, int _length) throws SAXException {

		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}

		if (XMLConstants.CONTRACT_OCC_DATETIME_TEXT_PATH.equals(this.context.getCurrentPath()) &&
		    (this.occDetail != null)) {
			
			String type = (String)this.occDetail.get(XMLConstants.INVOICE_DATETIME_TYPE_ATTR);
			if ((type != null) && (XMLConstants.CONTRACT_OCC_DATETIME_VALUE.equals(type))) {
				this.occDetail.put(XMLConstants.INVOICE_DATETIME_TYPE_ATTR, new String(_chars, _start, _length));
			}
		}
	}
	
	private void findMibasInformation() {
		
		this.context.setAttribute(CONTEXT_CONTRACT_FLEET, "");
		this.context.setAttribute(CONTEXT_CONTRACT_MEMBER, "");
		this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER, "");
		this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER_PREFIX, "");
		this.context.setAttribute(CONTEXT_CONTRACT_HOLDER, "");
		try {

//EHO: Passa o customer code em todas as query para não retornar imei reaproveitado, quando este acabara de ser cancelado.			
			String customerCode = (String) this.context.getAttribute(XMLConstants.CONTEXT_CUSTCODE);
	
			String deviceId = (String) this.context.getAttribute(CONTEXT_CONTRACT_IMEI);
			
			Object[] queryParams = new Object[] { deviceId,customerCode,customerCode,customerCode };
			
			Object[] queryParams1 = new Object[] { deviceId,customerCode,deviceId,customerCode,deviceId,customerCode,deviceId,customerCode,deviceId,customerCode };

			//			System.out.println(customerCode+" "+deviceId);

			
			SQLConnectionManager instance = SQLConnectionManager.getInstance("mibas");
			if (instance == null) {
				log.warn("could not get mibas pool; no information will be queried.");
				return;
			}
			List result = instance.queryList("MibasContract", queryParams );
			if ((result != null) && (result.size() > 0)) {
				List row = (List) result.iterator().next();
				if ((row != null) && (row.size() > 0)) {
					// found member, fleet and holder
					Iterator it = row.iterator();
					// fleet id
					if (it.hasNext()) {
						Object fleet = it.next();
						if (fleet != null)
							this.context.setAttribute(CONTEXT_CONTRACT_FLEET, fleet.toString());
					}
					// member id	
					if (it.hasNext()) {
						Object member = it.next();
						if (member != null)
							this.context.setAttribute(CONTEXT_CONTRACT_MEMBER, member.toString());
					}
					// telephone number	
					if (it.hasNext()) {
						Object telnumber = it.next();
						if (telnumber != null)
							this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER, telnumber.toString());
					}

					// telephone number prefix	
					if (it.hasNext()) {
						Object telnumberpref = it.next();
						if (telnumberpref != null)
							this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER_PREFIX, telnumberpref.toString());
					}
					
					// subscriber name
					if (it.hasNext()) {
						Object holder = it.next();
						if (holder != null)
							this.context.setAttribute(CONTEXT_CONTRACT_HOLDER, holder.toString());
					}
					return;
				}
			} 
			
		    //EHO: Contemplação da function do Mibas.   

			result = instance.queryList("MibasFunction", queryParams1);
			if ((result != null) && (result.size() > 0)) {
				List row = (List) result.iterator().next();
				if ((row != null) && (row.size() > 0)) {
					// found member, fleet and holder
					Iterator it = row.iterator();
					// fleet id
					if (it.hasNext()) {
						Object fleet = it.next();
						if (fleet != null)
							this.context.setAttribute(CONTEXT_CONTRACT_FLEET, fleet.toString());
					}
					// member id	
					if (it.hasNext()) {
						Object member = it.next();
						if (member != null)
							this.context.setAttribute(CONTEXT_CONTRACT_MEMBER, member.toString());
					}
					// telephone number	
					if (it.hasNext()) {
						Object telnumber = it.next();
						if (telnumber != null)
							this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER, telnumber.toString());
					}

					// telephone number prefix	
					if (it.hasNext()) {
						Object telnumberpref = it.next();
						if (telnumberpref != null)
							this.context.setAttribute(CONTEXT_CONTRACT_PHONENUMBER_PREFIX, telnumberpref.toString());
					}

					// subscriber name
					if (it.hasNext()) {
						Object holder = it.next();
						if (holder != null)
							this.context.setAttribute(CONTEXT_CONTRACT_HOLDER, holder.toString());
					}
					}
					}


			
		
			
		} catch (SQLException e) {
			throw new RuntimeException("SQL Error - see stack trace for more info.", e);
		} catch (NamingException e) {
      throw new RuntimeException("SQL Error - see stack trace for more info.", e);
		}
	}

	private void reset() {
		
		this.context.removeAttribute(CONTEXT_CONTRACT_CODE);
		this.context.removeAttribute(CONTEXT_CONTRACT_IMEI);	
		this.context.removeAttribute(CONTEXT_CONTRACT_TYPE);	
		this.context.removeAttribute(CONTEXT_CONTRACT_PHONENUMBER);	
		this.context.removeAttribute(CONTEXT_CONTRACT_PHONENUMBER_PREFIX);	
		this.context.removeAttribute(CONTEXT_CONTRACT_MONTHLYFEE_VALUE);
		this.context.removeAttribute(CONTEXT_CONTRACT_ADDITIONAL_VALUE);
		this.context.removeAttribute(CONTEXT_CONTRACT_ONLINE_VALUE);
		this.context.removeAttribute(CONTEXT_CONTRACT_SUBTOTAL_VALUE);
		this.context.setAttribute(CONTEXT_CONTRACT_DISCOUNTS_VALUE, new Double(0));
		this.context.removeAttribute(CONTEXT_CONTRACT_FLEET);
		this.context.removeAttribute(CONTEXT_CONTRACT_MEMBER);
		this.context.removeAttribute(CONTEXT_CONTRACT_HOLDER);
		this.contractSubtotal = 0D;
		// minute packages with 'MPRP'
    this.context.setAttribute(ContractPackagesListHandler.CONTEXT_IN_MINUTEPACKAGE, 
                              Boolean.FALSE);
    this.context.setAttribute(ContractPackagesListHandler.CONTEXT_MINUTEPACKAGE_CONTAINS_MPRP, 
                              Boolean.FALSE);
		// service information
    HashMap sMap = new HashMap();
    sMap.put(XMLConstants.SERVICE_TARIFFZONE_SMSSI_VALUE, XMLConstants.SERVICE_SMSSI_DESCRIPTION);
    this.context.setAttribute(ContractServicesHandler.CONTEXT_SERVICES_MAP, sMap);
		this.context.setAttribute(ContractServicesHandler.CONTEXT_SERVICE_DETAILS, new LinkedHashMap());
		this.context.setAttribute(ContractServicesHandler.CONTEXT_SERVICE_HEADER, new LinkedHashMap());
		// reset for usage detail
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_CIRDT_VALUE);
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE);
		this.context.removeAttribute(XMLConstants.DOWNLOAD_DETAIL_LIST);
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_TP_VALUE);
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_MMST_VALUE);
	    //EHO: Mudança mms outras operadoras
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_DRin_VALUE);
		//
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_MMSI_VALUE);
    this.context.removeAttribute(CallDetailAccumulator.CONTEXT_DETAILS_ONLINE);
		// dispatch
		this.context.removeAttribute(XMLConstants.DISPATCH_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_DISPP_VALUE);
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_DISPG_VALUE);
		// idcd
		this.context.removeAttribute(XMLConstants.SERVICE_NAME_IDCD_VALUE);
		this.context.removeAttribute(XMLConstants.IDCD_DETAIL_LIST);
		// telephony
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_Z3);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_Z3 + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED+ "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_COLLECT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_COLLECT + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LOCAL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LOCAL + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL + "|" + XMLConstants.USAGE_ELEMENT);
		
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING + "|" + XMLConstants.TEL_Z3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING + "|" + XMLConstants.TEL_Z3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING + "|" + XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_HOME_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING + "|" + XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);

		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_Z3);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_Z3 + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED+ "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_COLLECT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_COLLECT + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LOCAL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LOCAL + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE + "|" + XMLConstants.USAGE_ELEMENT);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL + "|" + XMLConstants.USAGE_ELEMENT);
		
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING + "|" + XMLConstants.TEL_Z3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING + "|" + XMLConstants.TEL_Z3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING + "|" + XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);
		this.context.removeAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING + "|" + XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);
	}
}
