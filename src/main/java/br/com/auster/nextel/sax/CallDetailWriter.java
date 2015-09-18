/**
 * 
 */
package br.com.auster.nextel.sax;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

import br.com.auster.common.lang.StringUtils;
import br.com.auster.dware.sax.MultiHandlerContext;
import br.com.auster.nextel.xsl.extensions.DurationFormat;

/**
 * @author framos
 *
 */
public class CallDetailWriter {

	
	private static final Logger log = Logger.getLogger(CallDetailWriter.class);
	
	
//	private DecimalFormat numberFormatter;
//	private DecimalFormat currencyFormatter;

	
	
	public CallDetailWriter() {	
	}


	/**
	 * Write out the header of the contract details (the {@value XMLConstants.XML_CONTRACT_ELEMENT}, and separates 
	 *    download, torpedo and dispatches from IDCD and telephony using the {@value XMLConstants.XML_CONTRACT_CALLS_ELEMENT} tag. 
	 */
	public void writeContractCalls(MultiHandlerContext _source) throws SAXException {
		
		ContentHandler handler = (ContentHandler) _source.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER);
		
		// header
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_ID_ATTR, 
				          (String) _source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_CODE));

		Boolean hasMprp = (Boolean) _source.getAttribute(ContractPackagesListHandler.CONTEXT_MINUTEPACKAGE_CONTAINS_MPRP);
    if ((hasMprp != null) && hasMprp.booleanValue()) {
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_FID_ATTR, "");
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_MID_ATTR, "");
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_U_ATTR, 
                        XMLConstants.MINUTEPACKAGE_USER_NAME);
		} else {
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_FID_ATTR, 
					          ((String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_FLEET)).trim());
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_MID_ATTR, 
					          ((String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_MEMBER)).trim());
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_U_ATTR, 
					          ((String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_HOLDER)).trim());
		}

		// TODO update
		String pptel = (String)_source.getAttribute(XMLConstants.XML_CONTRACT_PP_ATTR);
		if ((pptel != null) && (XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(pptel))) {
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_PP_ATTR, "Y");
		} else {
			this.addAttribute(attrs, XMLConstants.XML_CONTRACT_PP_ATTR, "N");
		}
		
//		PhoneNumber pn = new PhoneNumber();
//		pn.parse((String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_PHONENUMBER));
//		if (pn.getFirstDigit() != "1") {
//			if ((hasMprp != null) && hasMprp.booleanValue()) {
//				this.addAttribute(attrs, XMLConstants.XML_CONTRACT_N_ATTR, "");
//			} else {
//				this.addAttribute(attrs, XMLConstants.XML_CONTRACT_N_ATTR, pn.getOriginalPhoneNumber());
//			}
//		}

		//Phone number by mibas
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_N_ATTR, 
                (String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_PHONENUMBER));
		
		
		// attributes @T and @A must be added with the discount accumulator for this contract
		Number discountAcc = (Number)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_DISCOUNTS_VALUE);
		if (discountAcc == null) {
			discountAcc = new Double(0);
		}
		
		Double amount = (Double) _source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_SUBTOTAL_VALUE);
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_T_ATTR, 
						  this.getCurrencyFormatter(_source).formatNumber(amount.doubleValue() + discountAcc.doubleValue()));

		amount = (Double) _source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_MONTHLYFEE_VALUE);
		if (amount == null) { amount = new Double(0); }
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_M_ATTR, 
						  this.getCurrencyFormatter(_source).formatNumber(amount.doubleValue()));
			
		amount = (Double) _source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ADDITIONAL_VALUE);
		if (amount == null) { amount = new Double(0); }
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_A_ATTR, 
				  		  this.getCurrencyFormatter(_source).formatNumber(amount.doubleValue() + discountAcc.doubleValue()));

		amount = (Double) _source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ONLINE_VALUE);
		if (amount == null) { amount = new Double(0); }
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_O_ATTR, 
		  		  	     this.getCurrencyFormatter(_source).formatNumber(amount.doubleValue()));

		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_IMEI_ATTR, 
		                  (String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_IMEI));
		this.addAttribute(attrs, XMLConstants.XML_CONTRACT_TP_ATTR, 
				          (String)_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_TYPE));

		
		this.startElement(handler, XMLConstants.XML_CONTRACT_ELEMENT, attrs);
		// download and torpedos
		this.startElement(handler, XMLConstants.XML_CONTRACT_SERVICES_ELEMENT, null);
		writeServices(_source, handler);
		writeNOL(_source, handler);
		
//		EHO: Mudança mms outras operadoras
 		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_DRin_VALUE, XMLConstants.XML_TORPEDO_ELEMENT);
//		
		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_CIRDT_VALUE, XMLConstants.XML_ONLINE_ELEMENT);
		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_TP_VALUE, XMLConstants.XML_TORPEDO_ELEMENT);
		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_MMST_VALUE, XMLConstants.XML_TORPEDO_ELEMENT);
		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_MMSI_VALUE, XMLConstants.XML_TORPEDO_ELEMENT);
		writeDataServices(_source, handler,  XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE, XMLConstants.XML_DOWNLOAD_ELEMENT);						
		writeDataTotal(_source, handler);
		this.endElement(handler, XMLConstants.XML_CONTRACT_SERVICES_ELEMENT);
		// charges
		writeCharges(_source, handler);
		// dispatch 
		writeDispatches(_source, handler);
		// calls block
		this.startElement(handler, XMLConstants.XML_CONTRACT_CALLS_ELEMENT, null);
		writeIDCD(_source, handler);
		writeTelephony(_source, handler);
    // online details inside calls block
    this.startElement(handler, XMLConstants.XML_ONLINE_ELEMENT, null);
    writeOnline(_source, handler);
    this.endElement(handler, XMLConstants.XML_ONLINE_ELEMENT);
		this.endElement(handler, XMLConstants.XML_CONTRACT_CALLS_ELEMENT);
		// footer
		this.endElement(handler, XMLConstants.XML_CONTRACT_ELEMENT);
	}

	/**
	 * Write out the {@value XMLConstants.XML_CONTRACT_SERVICE_ELEMENT} sub-elements and their attributes.
	 * 
	 * Those sub-elements are named {@value XMLConstants.XML_SERVICE_DETAIL_ELEMENT}.
	 */
	protected void writeServices(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		
		Map serviceDescription = (Map) _source.getAttribute(ContractServicesHandler.CONTEXT_SERVICE_DETAILS);
		for (Iterator it = serviceDescription.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			int idx1 = key.indexOf("|");
			int idx2 = key.indexOf("|DETAILS", idx1);
			// both must be positive non-zero integers, with idx1 < idx2
			if ((idx1 > 0) && (idx2 <= 0)) {
//			if ((idx1 < idx2) && (idx1 > 0)) {
				AttributesImpl attrs = new AttributesImpl();
				this.addAttribute(attrs, XMLConstants.XML_SERVICE_ID_ATTR, key.substring(0, idx1));
				this.addAttribute(attrs, XMLConstants.XML_SERVICE_TP_ATTR, key.substring(idx1+1));
//				this.addAttribute(attrs, XMLConstants.XML_SERVICE_TP_ATTR, key.substring(idx1+1, idx2));
				Number value = (Number)((Map)serviceDescription.get(key)).get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_VALUE);
				if (value == null) {
					value = new Double(0);
				}
				this.addAttribute(attrs, XMLConstants.XML_SERVICE_V_ATTR , this.getCurrencyFormatter(_source).formatNumber(value.doubleValue()));
				// write out XML
				this.startElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT, attrs);
				this.endElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT);
			}
		}
	}
	
	/**
	 * Write out the {@value XMLConstants.XML_ONLINE_ELEMENT} element and its attributes.
	 */
	protected void writeNOL(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		
		Map serviceDescription =  (Map) _source.getAttribute(ContractServicesHandler.CONTEXT_SERVICE_DETAILS);
		List nolList = (List) serviceDescription.get(ContractServicesHandler.CONTEXT_ONLINE_LIST);
		if (nolList != null) {
			for (Iterator it=nolList.iterator(); it.hasNext();) {
				Map record = (Map) it.next();
				AttributesImpl attrs = new AttributesImpl();
				
				double quantity = ((Double)record.get(ContractServicesHandler.CONTEXT_ONLINE_QUANTITY)).doubleValue();
				Number value = this.getCurrencyFormatter(_source).parseNumber((String)record.get(ContractServicesHandler.CONTEXT_ONLINE_VALUE));
				
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_TP_ATTR, (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_CHARGE_TYPE));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_ID_ATTR, (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_SERVICE_NAME));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_DS_ATTR, (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_SERVICE_DESCRIPTION));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_Q_ATTR , this.getCurrencyFormatter(_source).formatNumber(quantity));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_ST_ATTR, (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_STATUS));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_S_ATTR , (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_START_DATE));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_E_ATTR , (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_END_DATE));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_ND_ATTR, (String)record.get(ContractServicesHandler.CONTEXT_ONLINE_CHARGE_DAYS));
				this.addAttribute(attrs, XMLConstants.XML_ONLINE_V_ATTR , this.getCurrencyFormatter(_source).formatNumber(value.doubleValue()));
				this.startElement(_handler, XMLConstants.XML_ONLINE_ELEMENT, attrs);
				this.endElement(_handler, XMLConstants.XML_ONLINE_ELEMENT);
			}
		}
	}
	
	/**
	 * Write out the three elements, all data services. 
	 * 
	 * The first, {@value XMLConstants.XML_ONLINE_ELEMENT} tag, displays all information about {@value XMLConstants.SERVICE_NAME_CIRDT_VALUE} service.
	 * 
	 * The second, named {@value XMLConstants.XML_TORPEDO_ELEMENT}, shows all torpedo totals. There are three torpedo services,
	 * 	each displayed separately. They are: 
 	 *  <ul> {@value XMLConstants.SERVICE_NAME_TP_VALUE} </ul>
	 *  <ul> {@value XMLConstants.SERVICE_NAME_MMST_VALUE} </ul>
	 *  <ul> {@value XMLConstants.SERVICE_NAME_MMSI_VALUE} </ul>
	 *  
	 * The last element, {@value XMLConstants.XML_DOWNLOAD_ELEMENT} tag, is the summarization for {@value XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE} service.
	 */
	protected void writeDataServices(MultiHandlerContext _source, ContentHandler _handler, String _service, String _tag) throws SAXException {

		// do not write service if it doesnot exist
		Map serviceHeader =  (Map) _source.getAttribute(ContractServicesHandler.CONTEXT_SERVICE_HEADER);
		if (!serviceHeader.containsKey(_service)) {
			return;
		}
		String description = (String)((Map)serviceHeader.get(_service)).get(ContractServicesHandler.CONTEXT_SERVICE_DESCRIPTION);
		String chargeType = (String)((Map)serviceHeader.get(_service)).get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_TYPE);
		if (chargeType == null) {
			chargeType = "U";
		}
		double[] totals = (double[]) _source.getAttribute(_service);
		// building attributes
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_DS_ATTR, description); 
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_ID_ATTR, _service);
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_Q_ATTR , this.getNumberFormatter(_source).formatNumber(totals[AccumulatorConstants.SERVICE_DATA_QTTY_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_V_ATTR , this.getCurrencyFormatter(_source).formatNumber(totals[AccumulatorConstants.SERVICE_DATA_AMNT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_TP_ATTR, chargeType);
		// this next 2 attributes are hardcoded values in XSL
		this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_ST_ATTR, "a");
		
	    //EHO: Mudança mms outras operadoras
		if (XMLConstants.SERVICE_NAME_MMSI_VALUE.equals(_service)  ||
		   (XMLConstants.SERVICE_NAME_MMST_VALUE.equals(_service)) || 
    	   (XMLConstants.SERVICE_NAME_DRin_VALUE.equals(_service)) || 
		   (XMLConstants.SERVICE_NAME_TP_VALUE.equals(_service))) {
			double unitPrice = 0;
			if (totals[AccumulatorConstants.SERVICE_DATA_QTTY_ACCUM] != 0) {
				unitPrice = totals[AccumulatorConstants.SERVICE_DATA_AMNT_ACCUM] / totals[AccumulatorConstants.SERVICE_DATA_QTTY_ACCUM];
			}
			this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_U_ATTR, this.getCurrencyFormatter(_source).formatNumber(unitPrice));
		}
		// write out XML
		this.startElement(_handler, _tag, attrs);
		if (XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE.equals(_service)) {
			writeDownloadDetails(_source, (List)_source.getAttribute(XMLConstants.DOWNLOAD_DETAIL_LIST), _handler);
		}
		this.endElement(_handler, _tag);
	}
	
	protected void writeDownloadDetails(MultiHandlerContext _source, List _details, ContentHandler _handler) throws SAXException {
		if (_details != null) {
			for (Iterator it = _details.iterator(); it.hasNext();) {
				Map detail = (Map) it.next();
				// building detail XML element
				AttributesImpl attrs = new AttributesImpl();
				String remark = StringUtils.trimToEmpty((String)detail.get(XMLConstants.DOWNLOAD_VAS_REMARK_ATTR));
				int pipeIdx = remark.indexOf("|");
				String ds = "";
				String t = "";
				if (pipeIdx > 0) {
					ds = remark.substring(0, pipeIdx);
					t = remark.substring(pipeIdx+1);
				}
				// main number
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_MN_ATTR, (String) detail.get(XMLConstants.DOWNLOAD_MAINNUMBER_ATTR));
				// amount
				Number amt = this.getCurrencyFormatter(_source).parseNumber((String) detail.get(XMLConstants.DOWNLOAD_AMOUNT_ATTR));
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_VU_ATTR, 
								  this.getCurrencyFormatter(_source).formatNumber(amt.doubleValue()));
				// description				
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_DS_ATTR, ds);
				// type
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_T_ATTR, t);
				// date
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_DT_ATTR, 
						          DateHelper.toDateFormat((String) detail.get(XMLConstants.DOWNLOAD_CRTIME_DATE_ATTR)));
				// time
				this.addAttribute(attrs, XMLConstants.XML_DOWNLOAD_DETAIL_TM_ATTR, 
						          DateHelper.toTimeFormat((String) detail.get(XMLConstants.DOWNLOAD_CRTIME_TIME_ATTR)));
				// write out XML
				this.startElement(_handler, XMLConstants.XML_DOWNLOAD_DETAIL_ELEMENT, attrs);
				this.endElement(_handler, XMLConstants.XML_DOWNLOAD_DETAIL_ELEMENT);
			} 
		}
	}
	
	protected void writeDataTotal(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		
		// do not write service if it doesnot exist
		double[] totals = (double[]) _source.getAttribute(XMLConstants.SERVICE_NAME_CIRDT_VALUE);
		double cdataTotal = 0D;
		if (totals != null) {
			cdataTotal = totals[AccumulatorConstants.SERVICE_DATA_AMNT_ACCUM];
		}
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_DATA_AMOUNT_ATTR, this.getCurrencyFormatter(_source).formatNumber(cdataTotal));
		this.startElement(_handler, XMLConstants.XML_DATA_TOTAL_ELEMENT, attrs);
		this.endElement(_handler, XMLConstants.XML_DATA_TOTAL_ELEMENT);
	}

	protected void writeCharges(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		
		Map serviceDescription =  (Map) _source.getAttribute(ContractServicesHandler.CONTEXT_SERVICE_DETAILS);
		if ((serviceDescription == null) || (serviceDescription.size() <= 0)) {
			return;
		}
		double[] totals = new double[3];
		for (Iterator it=serviceDescription.keySet().iterator(); it.hasNext();) {
			String key = (String)it.next();
			int idx1 = key.indexOf("|"); 
			if (idx1 <= 0) { continue; }
			int idx2 = key.indexOf("|DETAILS", idx1);
			if (idx2 >= 0) { continue; }
			Map svcInfo = (Map) serviceDescription.get(key);
			
			log.debug("writing charges for service: " + key);
			log.debug("dumpping service information: " + svcInfo);
			Number value = (Number)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_VALUE);
			if (XMLConstants.SERVICE_CHARGE_TYPE_A_VALUE.equals(svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_TYPE))) {
				totals[0] += value.doubleValue();
			} else if ((XMLConstants.SERVICE_CHARGE_TYPE_U_VALUE.equals(svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_TYPE))) && 
					   key.startsWith(XMLConstants.SERVICE_NAME_IDCD_VALUE)) {
				totals[1] += value.doubleValue();
			} else if ((XMLConstants.SERVICE_CHARGE_TYPE_S_VALUE.equals(svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_TYPE))) &&
					   XMLConstants.CONTRACT_MRKT_AMP_TYPE.equals(_source.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_TYPE)))  {
				totals[2] += value.doubleValue();
			}
		}
		
		this.startElement(_handler, XMLConstants.XML_SERVICE_CHARGE_ELEMENT, null);
		writeChargeDetails(_source, _handler, XMLConstants.SERVICE_CHARGE_TYPE_A_VALUE ,serviceDescription, totals[0]);
		writeIDCDChargeDetails(_source, _handler, XMLConstants.SERVICE_CHARGE_TYPE_U_VALUE ,serviceDescription, totals[1]);
		writeChargeDetails(_source, _handler, XMLConstants.SERVICE_CHARGE_TYPE_S_VALUE ,serviceDescription, totals[2]);		
		this.endElement(_handler, XMLConstants.XML_SERVICE_CHARGE_ELEMENT);
	}

	protected void writeChargeDetails(MultiHandlerContext _source, ContentHandler _handler, String _type, Map _svcDetails, double _total) throws SAXException {
		if (_total == 0) {
			return;
		}
		
		AttributesImpl attr = new AttributesImpl();
		this.addAttribute(attr, XMLConstants.XML_SERVICE_TP_ATTR, _type);
		this.addAttribute(attr, XMLConstants.XML_SERVICE_V_ATTR, this.getCurrencyFormatter(_source).formatNumber(_total));
		
		this.startElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DETAIL_ELEMENT, attr);
		for (Iterator it= _svcDetails.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			int typeIdx = key.indexOf("|");
			if (typeIdx <= 0) { continue; }
			if (key.indexOf("|DETAILS", typeIdx) <= 0) { continue; }		
			String thisSvcType = key.substring(typeIdx+1, key.indexOf("|DETAILS", typeIdx));
			if (_type.equals(thisSvcType)) {
				
				List svcInfoList = (List) _svcDetails.get(key);
				for (Iterator it2=svcInfoList.iterator(); it2.hasNext();) {
					Map svcInfo = (Map) it2.next(); 
				
					AttributesImpl attrDetails = new AttributesImpl();
					// type
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_TP_ATTR, _type);
					// id
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ID_ATTR, 
									  (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_NAME));
					// description
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_DS_ATTR, 
							  (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_DESCRIPTION));
					// tariff plan
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_TR_ATTR, 
							  (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_TARIFF));
					// status
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ST_ATTR, 
							  (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_STATUS));
					// start date
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_S_ATTR, 
							DateHelper.toDateNoYearFormat((String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_STARTDATE)));
					// end date
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_E_ATTR, 
							 DateHelper.toDateNoYearFormat((String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_ENDATE)));
					// charge days
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ND_ATTR, 
							  (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_PERIOD));
					// charge days
					Number n = (Number)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_CHARGE_VALUE);
					this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_V_ATTR, 
							          this.getCurrencyFormatter(_source).formatNumber(n.doubleValue()));
					
					// write info
					this.startElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT, attrDetails);
					
					// write charge discounts
					this.writeChargeDiscounts(_source, _handler, (Map)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_DISCOUNTS));
					
					this.endElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT);
				}
			}
		}
		this.endElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DETAIL_ELEMENT);
	}
	
	protected void writeIDCDChargeDetails(MultiHandlerContext _source, ContentHandler _handler, String _type, Map _svcDetails, double _total) throws SAXException {
		if (_total == 0) {
			return;
		}
		
		AttributesImpl attr = new AttributesImpl();
		this.addAttribute(attr, XMLConstants.XML_SERVICE_TP_ATTR, _type);
		this.addAttribute(attr, XMLConstants.XML_SERVICE_V_ATTR, this.getCurrencyFormatter(_source).formatNumber(_total));
		String id = null, ds = null, tr = null;
		
		Map svcDiscounts = new LinkedHashMap();
		for (Iterator it= _svcDetails.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			int typeIdx = key.indexOf("|");
			if (typeIdx <= 0) { continue; }
			if (key.indexOf("|DETAILS", typeIdx) <= 0) { continue; }		
			String thisSvcType = key.substring(typeIdx+1, key.indexOf("|DETAILS", typeIdx));
			if (_type.equals(thisSvcType)) {
				
				List svcInfoList = (List) _svcDetails.get(key);
				for (Iterator it2=svcInfoList.iterator(); it2.hasNext();) {
					Map svcInfo = (Map) it2.next(); 
					// id
					if (XMLConstants.SERVICE_NAME_IDCD_VALUE.equals((String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_NAME))) {
						
						id = (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_NAME);
						ds = (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_DESCRIPTION);
						tr = (String)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_TARIFF);
						
						Map m = (Map)svcInfo.get(ContractServicesHandler.CONTEXT_SERVICE_DISCOUNTS);
						if (m != null) {
							for (Iterator it3=m.keySet().iterator(); it3.hasNext();) {
								String k3 = (String) it3.next();
								double discountValue = ((Number)m.get(k3)).doubleValue();
								if (svcDiscounts.containsKey(k3)) {
									discountValue += ((Number)svcDiscounts.get(k3)).doubleValue();
								}
								svcDiscounts.put(k3, new Double(discountValue));
							}
						}
					}
				}
			}
		}
			
		AttributesImpl attrDetails = new AttributesImpl();
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_TP_ATTR, _type);
		// the next 3 attributes are hardcoded in the XSL
		// status
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ST_ATTR, XMLConstants.SERVICE_STATUS_ACTIVE_VALUE);
		// start date
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_S_ATTR, 
						  DateHelper.toDateNoYearFormat((String)_source.getAttribute(TIMMSummsheetHandler.CONTEXT_SUMMSHEET_STARTDATE)));
		// end date
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_E_ATTR, 
						  DateHelper.toDateNoYearFormat((String)_source.getAttribute(TIMMSummsheetHandler.CONTEXT_SUMMSHEET_ENDDATE)));
		
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_V_ATTR, this.getCurrencyFormatter(_source).formatNumber(_total));
		// service id
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ID_ATTR, id);
		// description
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_DS_ATTR, ds);
		// tariff plan
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_TR_ATTR, tr);		
		// charge days
		// this field is never set in the XSL
		this.addAttribute(attrDetails, XMLConstants.XML_ONLINE_ND_ATTR, "0");
		
		// write XML
		this.startElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DETAIL_ELEMENT, attr);
		this.startElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT, attrDetails);
		// write charge discounts
		this.writeChargeDiscounts(_source, _handler, svcDiscounts);
		this.endElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT);			
		this.endElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DETAIL_ELEMENT);
	}	
	
	protected void writeChargeDiscounts(MultiHandlerContext _source, ContentHandler _handler, Map _discounts) throws SAXException {
		if (_discounts == null) {
			return;
		}
		for (Iterator it=_discounts.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			AttributesImpl attr = new AttributesImpl();
			
			this.addAttribute(attr, XMLConstants.XML_CHARGE_DISCOUNT_DS_ATTR, (String)entry.getKey());
			this.addAttribute(attr, XMLConstants.XML_CHARGE_DISCOUNT_V_ATTR, 
					          this.getCurrencyFormatter(_source).formatNumber(((Number)entry.getValue()).doubleValue()));
			
			this.startElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DISCOUNT_ELEMENT, attr);
			this.endElement(_handler, XMLConstants.XML_SERVICE_CHARGE_DISCOUNT_ELEMENT);
		}
	}
	
	/**
	 * Write out the {@value XMLConstants.XML_DISPATCH_ELEMENT} element, its attributes and sub-elements.
	 * 
	 * Expected sub-elements are named {@value XMLConstants.SERVICE_NAME_DISPP_VALUE} or {@value XMLConstants.SERVICE_NAME_DISPG_VALUE}.
	 */
	protected void writeDispatches(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		
		double[] accums = new double[AccumulatorConstants.DISPATCH_ACCUM_SIZE];
		if (_source.hasAttribute(XMLConstants.DISPATCH_ACC_SUMMARY)) {
			accums = (double[])_source.getAttribute(XMLConstants.DISPATCH_ACC_SUMMARY);
		}
		AttributesImpl attrsSummary = new AttributesImpl();
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_CH_ATTR, 
						  DurationFormat.formatFromMinutes(accums[AccumulatorConstants.DISPATH_SUBAPAGAR_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_CH_M_ATTR, 
				          this.getCurrencyFormatter(_source).formatNumber(accums[AccumulatorConstants.DISPATH_SUBAPAGAR_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_DR_ATTR, 
				          DurationFormat.formatFromMinutes(accums[AccumulatorConstants.DISPATH_SUBTOTAL_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_DR_M_ATTR, 
				          this.getCurrencyFormatter(_source).formatNumber(accums[AccumulatorConstants.DISPATH_SUBTOTAL_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_F_ATTR , 
				          DurationFormat.formatFromMinutes(accums[AccumulatorConstants.DISPATH_SUBFRANQUIA_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_F_M_ATTR , 
				          this.getCurrencyFormatter(_source).formatNumber(accums[AccumulatorConstants.DISPATH_SUBFRANQUIA_ACCUM]));
		this.addAttribute(attrsSummary, XMLConstants.XML_DISPATCH_V_ATTR , 
						  this.getCurrencyFormatter(_source).formatNumber(accums[AccumulatorConstants.DISPATH_SUBVALOR_ACCUM]));
		// start DISPATCH element
		this.startElement(_handler, XMLConstants.XML_DISPATCH_ELEMENT, attrsSummary);
		// Radio Individual
		if (_source.hasAttribute(XMLConstants.SERVICE_NAME_DISPP_VALUE)) {
			Attributes attrs = writeDispatchDetails(_source, 
					                                (double[]) _source.getAttribute(XMLConstants.SERVICE_NAME_DISPP_VALUE), 
					                                "Rádio Digital - Individual");
			this.startElement(_handler, XMLConstants.XML_DISPATCH_DETAIL_ELEMENT, attrs);
			this.endElement(_handler, XMLConstants.XML_DISPATCH_DETAIL_ELEMENT);
		}
		// Radio Grupo
		if (_source.hasAttribute(XMLConstants.SERVICE_NAME_DISPG_VALUE)) {
			Attributes attrs = writeDispatchDetails(_source, 
					                                (double[]) _source.getAttribute(XMLConstants.SERVICE_NAME_DISPG_VALUE), 
					                                "Rádio Digital - Grupo");
			this.startElement(_handler, XMLConstants.XML_DISPATCH_DETAIL_ELEMENT, attrs);
			this.endElement(_handler, XMLConstants.XML_DISPATCH_DETAIL_ELEMENT);
		}
		// end DISPATCH element
		this.endElement(_handler, XMLConstants.XML_DISPATCH_ELEMENT);
	}
	
	protected Attributes writeDispatchDetails(MultiHandlerContext _source, double[] _accums, String _description) {
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_CH_ATTR, 
				           DurationFormat.formatFromMinutes(_accums[AccumulatorConstants.DISPATH_APAGAR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_CH_M_ATTR, 
				           this.getCurrencyFormatter(_source).formatNumber(_accums[AccumulatorConstants.DISPATH_APAGAR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_DR_ATTR, 
				           DurationFormat.formatFromMinutes(_accums[AccumulatorConstants.DISPATH_TOTAL_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_DR_M_ATTR, 
						   this.getCurrencyFormatter(_source).formatNumber(_accums[AccumulatorConstants.DISPATH_TOTAL_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_DS_ATTR, _description);
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_F_ATTR ,
				           DurationFormat.formatFromMinutes(_accums[AccumulatorConstants.DISPATH_FRANQUIA_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_F_M_ATTR ,
				           this.getCurrencyFormatter(_source).formatNumber(_accums[AccumulatorConstants.DISPATH_FRANQUIA_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_DISPATCH_DETAIL_V_ATTR , 
						   this.getCurrencyFormatter(_source).formatNumber(_accums[AccumulatorConstants.DISPATH_AMNT_ACCUM]));
		return attrs; 
	}
	
	/**
	 * Write out the {@value XMLConstants.XML_IDCD_ELEMENT} element, its attributes and sub-elements.
	 * 
	 * Expected sub-elements are named {@value XMLConstants.XML_TEL_DETAIL}.
	 */
	protected void writeIDCD(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		AttributesImpl attrs = new AttributesImpl();
		if (_source.hasAttribute(XMLConstants.SERVICE_NAME_IDCD_VALUE)) {
			double[] totals = (double[]) _source.getAttribute(XMLConstants.SERVICE_NAME_IDCD_VALUE);
			this.addAttribute(attrs, XMLConstants.XML_IDCD_V_ATTR ,  
					 		   this.getCurrencyFormatter(_source).formatNumber(totals[AccumulatorConstants.IDCD_AMNT_ACCUM]));
			this.addAttribute(attrs, XMLConstants.XML_IDCD_DR_ATTR, 
					           DurationFormat.formatFromMinutes(totals[AccumulatorConstants.IDCD_TIME_ACCUM]));
			this.addAttribute(attrs, XMLConstants.XML_IDCD_DR_M_ATTR, 
					           this.getCurrencyFormatter(_source).formatNumber(totals[AccumulatorConstants.IDCD_TIME_ACCUM]));
		} else {
			this.addAttribute(attrs, XMLConstants.XML_IDCD_V_ATTR , this.getCurrencyFormatter(_source).formatNumber(0));
			this.addAttribute(attrs, XMLConstants.XML_IDCD_DR_ATTR, DurationFormat.formatFromMinutes(0));
			this.addAttribute(attrs, XMLConstants.XML_IDCD_DR_M_ATTR, this.getCurrencyFormatter(_source).formatNumber(0));
		}
		// write out XML
		this.startElement(_handler, XMLConstants.XML_IDCD_ELEMENT, attrs);
		// details
		if (_source.hasAttribute(XMLConstants.IDCD_DETAIL_LIST)) {
			List details = (List) _source.getAttribute(XMLConstants.IDCD_DETAIL_LIST);
			for (Iterator it = details.iterator(); it.hasNext();) {
				writeIDCDDetails((Map)it.next(), _handler);
			}
		}
		this.endElement(_handler, XMLConstants.XML_IDCD_ELEMENT);  
	}
	
	protected void writeIDCDDetails(Map _details, ContentHandler _handler) throws SAXException {

		AttributesImpl attrs = new AttributesImpl();
		// main number
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_MN_ATTR, 
				                 (String) _details.get(XMLConstants.IDCD_MAIN_NUMBER_ATTR));
		// type indicator
		String typeInd = (String) _details.get(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR);
		if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeInd) || 
				XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeInd)) {
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SN_ATTR,
									 XMLConstants.TEL_CALL_CHARGETYPE_AIR);
		} else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeInd)) {
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SN_ATTR,
					                 XMLConstants.TEL_CALL_CHARGETYPE_TOLL);
		}
		// call number type
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_CL_ATTR, 
						  XMLConstants.TEL_CALL_NUMBERTYPE_OTHER);
		// date
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DT_ATTR, 
				          DateHelper.toDateFormat((String) _details.get(XMLConstants.IDCD_CRTIME_DATE_ATTR)));
		// time
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TM_ATTR, 
				          DateHelper.toTimeFormat((String) _details.get(XMLConstants.IDCD_CRTIME_TIME_ATTR)));
		// duration
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DR_ATTR, 
 				 		  (String) _details.get(XMLConstants.IDCD_TIMECALL_ACC_VALUE));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DR_M_ATTR, 
		 		  (String) _details.get(XMLConstants.IDCD_TIMECALL_M_ACC_VALUE));
		
		// value
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_V_ATTR, 
                		  (String) _details.get(XMLConstants.IDCD_AMOUNT_ATTR));
		// tariff
		this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TP_ATTR, 
                		  (String) _details.get(XMLConstants.IDCD_TARIFF_TIMESHORT_ATTR));

		this.startElement(_handler, XMLConstants.XML_TEL_DETAIL, attrs);
		this.endElement(_handler, XMLConstants.XML_TEL_DETAIL);
	}
	
	/**
	 * Write out the {@value XMLConstants.XML_TEL_HOME_ELEMENT}  and {@value XMLConstants.XML_TEL_ROAM_ELEMENT} elements, its attributes and sub-elements.
	 * 
	 * Expected sub-elements, for each tag listed above,  are :
	 *   <ul>{@value XMLConstants.XML_TEL_OUTGOING_ELEMENT}
	 *   	<ul>{@value XMLConstants.XML_TEL_LO_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_LD_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_INT_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_NOZ300_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_Z300_ELEMENT}</ul>
	 *   </ul>
	 *   <ul>{@value XMLConstants.XML_TEL_INCOMING_ELEMENT}
	 *   	<ul>{@value XMLConstants.XML_TEL_RECEIVED_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_COLLECT_ELEMENT}</ul>
	 *   	<ul>{@value XMLConstants.XML_TEL_DISC_ELEMENT}</ul>
	 *   </ul>
	 */
	protected void writeTelephony(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
		// HOME block
		Attributes attrs = buildTelHeadersAttrs(_source, (double[]) _source.getAttribute(XMLConstants.TEL_LOCATION_HOME_CALL) );
		this.startElement(_handler, XMLConstants.XML_TEL_HOME_ELEMENT, attrs);
		this.writeTelephonyOutGoingSummary(_source, _handler, XMLConstants.TEL_LOCATION_HOME_CALL);
		this.writeTelephonyIncomingSummary(_source, _handler, XMLConstants.TEL_LOCATION_HOME_CALL);
		this.endElement(_handler, XMLConstants.XML_TEL_HOME_ELEMENT);
		// ROAM block
		Attributes attrs2 = buildTelHeadersAttrs(_source, (double[]) _source.getAttribute(XMLConstants.TEL_LOCATION_ROAM_CALL) );
		this.startElement(_handler, XMLConstants.XML_TEL_ROAM_ELEMENT, attrs2);
		this.writeTelephonyOutGoingSummary(_source, _handler, XMLConstants.TEL_LOCATION_ROAM_CALL);
		this.writeTelephonyIncomingSummary(_source, _handler, XMLConstants.TEL_LOCATION_ROAM_CALL);
		this.endElement(_handler, XMLConstants.XML_TEL_ROAM_ELEMENT);
	}
	
	protected void writeTelephonyOutGoingSummary(MultiHandlerContext _source, ContentHandler _handler, String _locale) throws SAXException {

		Attributes attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING));
		this.startElement(_handler, XMLConstants.XML_TEL_OUTGOING_ELEMENT, attrs);
		// if ROAM, then print first NO_Z3_SUMMARY
		if (XMLConstants.TEL_LOCATION_ROAM_CALL.equals(_locale)) {
			// outgoing local
			attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_DIRECTION_OUTGOING + "|" + XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY));
			this.startElement(_handler, XMLConstants.XML_TEL_NOZ300_ELEMENT, attrs);
			this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);
			this.endElement(_handler, XMLConstants.XML_TEL_NOZ300_ELEMENT);  
		}
		// outgoing local
		attrs = buildTelSubSectionAttrs(_source,(double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LOCAL));
		this.startElement(_handler, XMLConstants.XML_TEL_LO_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_LOCAL);
		this.endElement(_handler, XMLConstants.XML_TEL_LO_ELEMENT);  
		// outgoing LDs
		attrs = buildTelSubSectionAttrs(_source,(double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE));
		this.startElement(_handler, XMLConstants.XML_TEL_LD_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE);
		this.endElement(_handler, XMLConstants.XML_TEL_LD_ELEMENT);  
		// outgoing Internationals
		attrs = buildTelSubSectionAttrs(_source,(double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL));
		this.startElement(_handler, XMLConstants.XML_TEL_INT_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL);
		this.endElement(_handler, XMLConstants.XML_TEL_INT_ELEMENT);  
		// outgoing Internationals
		attrs = buildTelSubSectionAttrs(_source,(double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_Z3));
		this.startElement(_handler, XMLConstants.XML_TEL_Z300_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_Z3);
		this.endElement(_handler, XMLConstants.XML_TEL_Z300_ELEMENT);
		
		this.endElement(_handler, XMLConstants.XML_TEL_OUTGOING_ELEMENT);
	}
	
	protected void writeTelephonyIncomingSummary(MultiHandlerContext _source, ContentHandler _handler, String _locale) throws SAXException {

		Attributes attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_DIRECTION_INCOMING));
		this.startElement(_handler, XMLConstants.XML_TEL_INCOMING_ELEMENT, attrs);
		// incoming received
		attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED));
		this.startElement(_handler, XMLConstants.XML_TEL_RECEIVED_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED);
		this.endElement(_handler, XMLConstants.XML_TEL_RECEIVED_ELEMENT);
		// incoming collect calls
		attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_COLLECT));
		this.startElement(_handler, XMLConstants.XML_TEL_COLLECT_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_COLLECT);
		this.endElement(_handler, XMLConstants.XML_TEL_COLLECT_ELEMENT);
		// incoming discounts
		attrs = buildTelSubSectionAttrs(_source, (double[]) _source.getAttribute(_locale + "|" + XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT));
		this.startElement(_handler, XMLConstants.XML_TEL_DISC_ELEMENT, attrs);
		this.writeTelephonyDetails(_source, _handler, _locale, XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT);
		this.endElement(_handler, XMLConstants.XML_TEL_DISC_ELEMENT);

		this.endElement(_handler, XMLConstants.XML_TEL_INCOMING_ELEMENT);
	}
	
	protected Attributes buildTelHeadersAttrs(MultiHandlerContext _source, double[] _totals) {
		double total = 0;
		double apagar = 0;
		double franquia = 0;
		double amount = 0;
		if (_totals != null) {
			total = _totals[AccumulatorConstants.TELEPHONY_TOT_ACCUM];
			apagar = _totals[AccumulatorConstants.TELEPHONY_APA_ACCUM];
			franquia = _totals[AccumulatorConstants.TELEPHONY_FRA_ACCUM];
			amount = _totals[AccumulatorConstants.TELEPHONY_AMT_ACCUM];
		}
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_TEL_DNF_ATTR, DurationFormat.formatFromMinutes(total));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DNF_M_ATTR, this.getCurrencyFormatter(_source).formatNumber(total));
		this.addAttribute(attrs, XMLConstants.XML_TEL_F_ATTR  , DurationFormat.formatFromMinutes(franquia));
		this.addAttribute(attrs, XMLConstants.XML_TEL_F_M_ATTR  , this.getCurrencyFormatter(_source).formatNumber(franquia));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CH_ATTR , DurationFormat.formatFromMinutes(apagar));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CH_M_ATTR , this.getCurrencyFormatter(_source).formatNumber(apagar));
		this.addAttribute(attrs, XMLConstants.XML_TEL_V_ATTR  , this.getCurrencyFormatter(_source).formatNumber(amount));
		return attrs;
	}

	protected Attributes buildTelSubSectionAttrs(MultiHandlerContext _source, double[] _totals) {

        if (_totals == null) {
        	return null;
        }
		AttributesImpl attrs = new AttributesImpl();
		this.addAttribute(attrs, XMLConstants.XML_TEL_DNF_ATTR, 
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_NOFREE_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DNF_M_ATTR, 
				this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_NOFREE_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DA_ATTR,
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_TOTAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DA_M_ATTR,
				 this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_TOTAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_FA_ATTR,
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_FRAAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_FA_M_ATTR,
				 this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_FRAAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CHA_ATTR,
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_APAAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CHA_M_ATTR,
				 this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_APAAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_VA_ATTR,
						   this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_VALAIR_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CHT_ATTR,
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_APATOT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_CHT_M_ATTR,
				 this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_APATOT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_VT_ATTR,
						   this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_VALTOT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DR_ATTR,
				DurationFormat.formatFromMinutes(_totals[AccumulatorConstants.TELEPHONY_SUMM_TOT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_DR_M_ATTR,
				 this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_TOT_ACCUM]));
		this.addAttribute(attrs, XMLConstants.XML_TEL_V_ATTR, 
						   this.getCurrencyFormatter(_source).formatNumber(_totals[AccumulatorConstants.TELEPHONY_SUMM_VAL_ACCUM]));
		return attrs;
	}

	protected void writeTelephonyDetails(MultiHandlerContext _source, ContentHandler _handler, String _locale, String _type) throws SAXException {
		List details = (List) _source.getAttribute(_locale + "|" + _type + "|" + XMLConstants.USAGE_ELEMENT);
		if (details == null) {
			return;
		}
		for (Iterator it=details.iterator(); it.hasNext();) {
			Map detail = (Map) it.next();

			AttributesImpl attrs = new AttributesImpl();
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_MN_ATTR, 
					                 (String) detail.get(XMLConstants.TEL_MAINNUMBER_ATTR));
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SN_ATTR, 
	                                (String) detail.get(XMLConstants.TEL_CALL_CHARGETYPE));
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_CL_ATTR, 
	                  				 (String) detail.get(XMLConstants.TEL_CALL_NUMBERTYPE));
			String typeInd = (String)detail.get(XMLConstants.TEL_TYPE_INDICATOR_ATTR);
			// type indicator specific attributes
			if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeInd) || 
				XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeInd) || 
				XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeInd)) {
				
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DT_ATTR, 
						                 DateHelper.toDateFormat((String) detail.get(XMLConstants.TEL_CRTIME_DATE_ATTR)));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TM_ATTR, 
						                 DateHelper.toTimeFormat((String) detail.get(XMLConstants.TEL_CRTIME_TIME_ATTR)));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SC_ATTR, 
       				 					 (String) detail.get(XMLConstants.TEL_CALL_SOURCE));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DN_ATTR, 
		 					 			 (String) detail.get(XMLConstants.TEL_CALL_DESTINATION));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_N_ATTR, 
			 			 				 (String) detail.get(XMLConstants.TEL_CALL_FROMNUMBER));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DR_ATTR, 
		 				 				 (String) detail.get(XMLConstants.TEL_CALL_DURATION));
				this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DR_M_ATTR, 
		 				                 (String) detail.get(XMLConstants.TEL_CALL_DURATION_M));			
			}
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_V_ATTR, 
                    (String) detail.get(XMLConstants.TEL_AMOUNT_RATED_ATTR));
			//SMS + MIT
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SV_ATTR,					
                    (String) detail.get(XMLConstants.TEL_SERVICE_SHORT));							

 	        this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TZ_ATTR, 
                    (String) detail.get(XMLConstants.TEL_TARIFF_ZONE_SHORT));				

 	        this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_ZD_ATTR, 
                    (String) detail.get(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR));				 	        

			//EHO: Faltando para tratar tipo de ligação
			this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TP_ATTR, 
			        (String) detail.get(XMLConstants.TEL_TARIFF_ATTR));
			
 	        //SMS + MIT
			this.startElement(_handler, XMLConstants.XML_TEL_DETAIL, attrs);
			this.endElement(_handler, XMLConstants.TEL_TARIFF_ZONE_ATTR);
					
		}
	}

  /**
   * Write out the {@value XMLConstants.XML_IDCD_ELEMENT} element, its attributes and sub-elements.
   * 
   * Expected sub-elements are named {@value XMLConstants.XML_TEL_DETAIL}.
   */
  protected void writeOnline(MultiHandlerContext _source, ContentHandler _handler) throws SAXException {
    Map onlineCalls = (Map) _source.getAttribute(CallDetailAccumulator.CONTEXT_DETAILS_ONLINE);
    if (onlineCalls == null) {
      return;  // nothing to do...
    }
    Map services = (Map) _source.getAttribute(ContractServicesHandler.CONTEXT_SERVICES_MAP);
    Iterator it = onlineCalls.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry svc = (Map.Entry) it.next();
      AttributesImpl attrs = new AttributesImpl();
      this.addAttribute(attrs, XMLConstants.XML_ONLINE_ID_ATTR, (String) svc.getKey());
      String description = (String) services.get((String) svc.getKey());
      this.addAttribute(attrs, XMLConstants.XML_ONLINE_DS_ATTR, description);
      Map info = (Map) svc.getValue();
      double[] nbr = (double[]) info.get(XMLConstants.SERVICE_DATA_AMOUNT_ATTR);
      this.addAttribute( attrs, XMLConstants.XML_ONLINE_V_ATTR, 
                         getCurrencyFormatter(_source).formatNumber(nbr[0]) );
      int[] qty = (int[]) info.get(XMLConstants.SERVICE_QUANTITY_VOLUME_ATTR);
      this.addAttribute(attrs, XMLConstants.XML_SERVICE_DATA_Q_ATTR , 
                        this.getNumberFormatter(_source).formatNumber(qty[0]));
      // write out XML
      this.startElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT, attrs);
      // write details
      if (info.containsKey(XMLConstants.USAGE_ELEMENT)) {
        List details = (List) info.get(XMLConstants.USAGE_ELEMENT);
        for (Iterator dit = details.iterator(); dit.hasNext();) {
          writeOnlineDetails( (Map) dit.next(), _handler );
        }
      }
      // end XML tag
      this.endElement(_handler, XMLConstants.XML_SERVICE_DETAIL_ELEMENT);  
    }
  }
  
  protected void writeOnlineDetails(Map _details, ContentHandler _handler) throws SAXException {

    AttributesImpl attrs = new AttributesImpl();
    // main number
    this.addAttribute( attrs, XMLConstants.XML_TEL_DETAIL_MN_ATTR, 
                       (String) _details.get(XMLConstants.TEL_MAINNUMBER_ATTR) );
    // type indicator
    String typeInd = (String) _details.get(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR);
    if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeInd) || 
        XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeInd)) {
      this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SN_ATTR,
                   XMLConstants.TEL_CALL_CHARGETYPE_AIR);
    } else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeInd)) {
      this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_SN_ATTR,
                           XMLConstants.TEL_CALL_CHARGETYPE_TOLL);
    }
    
    // date
    this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DT_ATTR, 
                  DateHelper.toDateFormat((String) _details.get(XMLConstants.TEL_CRTIME_DATE_ATTR)));
    // time
    this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_TM_ATTR, 
                  DateHelper.toTimeFormat((String) _details.get(XMLConstants.TEL_CRTIME_TIME_ATTR)));
    
    // value
    this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_V_ATTR, 
                      (String) _details.get(XMLConstants.TEL_AMOUNT_RATED_ATTR));
      
    //SMS Description
    this.addAttribute(attrs, XMLConstants.XML_TEL_DETAIL_DS_ATTR, 
            (String) _details.get(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR));
    //SMS Description   
    this.startElement(_handler, XMLConstants.XML_TEL_DETAIL, attrs);
    this.endElement(_handler, XMLConstants.XML_TEL_DETAIL);
  }
  
	
	public void writeOCC(MultiHandlerContext _source, Map _occs) throws SAXException {
	
		ContentHandler handler = (ContentHandler) _source.getAttribute(TIMMContentHandlerPipe.CONTEXT_OUTPUT_HANDLER);
		
		if (_occs != null) {
			for (Iterator it = _occs.keySet().iterator(); it.hasNext(); ) {
				String key = (String) it.next();
				int idx = key.indexOf("|");
				if (idx <= 0) { continue; }
				
				AttributesImpl attrs = new AttributesImpl();
				this.addAttribute(attrs, XMLConstants.XML_OCC_DETAIL_DS_ATTR, key.substring(idx+1));
				this.addAttribute(attrs, XMLConstants.XML_OCC_DETAIL_DT_ATTR, key.substring(0, idx));
				Number nbr = (Number) _occs.get(key);
				this.addAttribute(attrs, XMLConstants.XML_OCC_DETAIL_V_ATTR, getCurrencyFormatter(_source).formatNumber(nbr.doubleValue()));
				
				this.startElement(handler, XMLConstants.XML_OCC_DETAIL, attrs);
				this.endElement(handler, XMLConstants.XML_OCC_DETAIL);
				
			}
		}
	}
	
	//
	// XML Building methods
	//
	
	private void addAttribute(AttributesImpl _attr, String _attrName, String _value) {
		if (_value == null) {
			_attr.addAttribute(null, _attrName, _attrName, "CDATA", "");
		} else {
			_attr.addAttribute(null, _attrName, _attrName, "CDATA", _value);
		}
	}
	
	private void startElement(ContentHandler _handler, String _tag, Attributes _attrs) throws SAXException {
		log.debug("starting " + _tag + " element");
		if (_attrs != null) {
			_handler.startElement(null, _tag, _tag, _attrs);
		} else {
			_handler.startElement(null, _tag, _tag, new AttributesImpl());
		}
	}
	
	private void endElement(ContentHandler _handler, String _tag) throws SAXException {
		log.debug("ending " + _tag + " element");
		_handler.endElement(null, _tag, _tag);
	}

	//
	// Format helper classes
	//
	private ParserHelper getNumberFormatter(MultiHandlerContext _context) {
		return (ParserHelper)_context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
	}

	private ParserHelper getCurrencyFormatter(MultiHandlerContext _context) {
		return (ParserHelper)_context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
	}
	

}
