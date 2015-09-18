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

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import br.com.auster.dware.sax.MultiHandlerReceiverBase;
import br.com.auster.nextel.xsl.extensions.DurationFormat;

/**
 * 
 * @author framos
 * @version $Id: ContractServicesHandler.java 363 2008-10-24 21:33:13Z gportuga $
 */
public class ContractServicesHandler extends MultiHandlerReceiverBase {

	
	
	private static final String ALL_NOL_SERVICES = "|" +
	"SMST|"  +	"WP|"    +	"TWM|"   + 	"WPTWM|" +  
	"CLIRB|" +  "GPSDA|" +	"NMSIM|" +  "NMPLS|" +  
	"NMBAS|" +  "N200K|" +	"MDD3|"  +	"N1200|" +  
	"N2200|" +	"N4200|" +	"N5200|" +	"N2300|" + 
	"N3300|" +	"N4300|" +	"N5300|" +	"N1600|" + 
	"N2600|" +	"N3600|" +	"N4600|" +	"N5600|" +  
	"N11MB|" +	"N21MB|" +	"N31MB|" +	"N41MB|" +  
	"N51MB|" +	"N13MB|" +	"N23MB|" +	"N33MB|" +  
	"N43MB|" +	"N53MB|" +	"N110M|" +	"N210M|" +  
	"N310M|" +	"N410M|" +	"N510M|" +	"MDD1|"  +
	"MDD2|"  +	"MDD4|"  +	"MDD4|"  +	"N1300|" +  
	"EQON|"  +	"NOWAS|" +	"LONEX|" + 	"AGBKP|" + "EQLOC|" +  
	"ITAUW|" +	"ITAUA|" +  "DOWNS|" +	"E930|";		
	
	
	
	
	
	public static final String CONTEXT_SERVICE_HEADER = "service.header";
	public static final String CONTEXT_SERVICE_DETAILS = "service.details";
	// item names for each service description 	
	public static final String CONTEXT_SERVICE_NAME = "service.name";
	public static final String CONTEXT_SERVICE_DESCRIPTION = "service.description";
	public static final String CONTEXT_SERVICE_STATUS = "service.status";		
	public static final String CONTEXT_SERVICE_TARIFF = "service.tariff";
	public static final String CONTEXT_SERVICE_STARTDATE = "service.date.start";
	public static final String CONTEXT_SERVICE_ENDATE = "service.date.end";
	public static final String CONTEXT_SERVICE_CHARGE_TYPE = "service.charge.type";
	public static final String CONTEXT_SERVICE_CHARGE_VALUE = "service.charge.value";
	public static final String CONTEXT_SERVICE_CHARGE_QUANTITY = "service.charge.quantity";
	public static final String CONTEXT_SERVICE_CHARGE_PERIOD = "service.charge.period";
	public static final String CONTEXT_SERVICE_DISCOUNTS = "service.charge.discounts";
	// online details list
	public static final String CONTEXT_ONLINE_LIST = "online.list";
	public static final String CONTEXT_ONLINE_CHARGE_TYPE = "online.detail.charge.type";
	public static final String CONTEXT_ONLINE_SERVICE_NAME = "online.detail.name";
	public static final String CONTEXT_ONLINE_SERVICE_DESCRIPTION = "online.detail;description";
	public static final String CONTEXT_ONLINE_QUANTITY = "online.detail.charge.quantity";
	public static final String CONTEXT_ONLINE_STATUS = "online.detail.status";
	public static final String CONTEXT_ONLINE_START_DATE = "detail.date.start";
	public static final String CONTEXT_ONLINE_END_DATE = "online.detail.date.end";
	public static final String CONTEXT_ONLINE_CHARGE_DAYS = "online.detail.charge.days";
	public static final String CONTEXT_ONLINE_VALUE = "online.detail.charge.value";
  
  /**
   * Map<String(service ID),String(service description)>
   */
  public static final String CONTEXT_SERVICES_MAP = "services.map";
	
	private static final Logger log = Logger.getLogger(ContractServicesHandler.class);
  
	private String currentService;
	private String currentStatusDateType;
	private String currentChargeType;
	private String currentChargeValue;
	private String currentPeriod;
	private String currentDescription;
	private double currentQuantity;
	private String currentTariff;
	private String currentDiscount;
	private List statusList;
	private ServiceStatusInfo currentStatus;
	private Map currentDiscountList;
		
	public ContractServicesHandler() {
		this.currentDiscountList = new LinkedHashMap();
		this.statusList = new LinkedList();
	}
	
	
	/**
	 * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes) 
	 */
	public void startElement(String _uri, String _localName, String _qName, Attributes _attributes) throws SAXException {

		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
    
    // handle rateplans for MPRP
    Boolean isMinutePackage = (Boolean) this.context.getAttribute(ContractPackagesListHandler.CONTEXT_IN_MINUTEPACKAGE);
    if (isMinutePackage != null && isMinutePackage.booleanValue() && 
        XMLConstants.MINUTEPACKAGE_PATH.equals(this.context.getCurrentPath())) {
      if (XMLConstants.CONTRACT_CD_TM_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
        final String name = _attributes.getValue(XMLConstants.CONTRACT_MINUTEPACKAGE_NAME_ATTR);
        if (name.contains(XMLConstants.MINUTEPACKAGE_NAME_MPRP_VALUE)) {
          this.context.setAttribute(ContractPackagesListHandler.CONTEXT_MINUTEPACKAGE_CONTAINS_MPRP, 
                                    Boolean.TRUE);
        }
      }
    }
		
		//getting service information
		if (XMLConstants.SERVICE_INFO_PATH.equals(this.context.getCurrentPath())) {
			// saving service description & its charge type
			if (XMLConstants.CONTRACT_CD_SN_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				this.currentService = _attributes.getValue(XMLConstants.SERVICE_SHORTVALUE_ATTR);
				log.trace("found service [" + this.currentService + "]");
				this.currentDescription = _attributes.getValue(XMLConstants.CONTRACT_SN_FULLVALUE_ATTR);
        Map services = (Map) this.context.getAttribute(CONTEXT_SERVICES_MAP);
        if (!services.containsKey(this.currentService)) {
          synchronized (services) {
            services.put(this.currentService, this.currentDescription); 
          }
        }
			} else if (XMLConstants.CONTRACT_CD_TM_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				this.currentTariff = _attributes.getValue(XMLConstants.CONTRACT_SN_FULLVALUE_ATTR);
			}
		// handles service charge unit
		} else if (XMLConstants.SERVICE_INFO_DETAIL_PATH.equals(this.context.getCurrentPath())) {
			this.currentChargeType = _attributes.getValue(XMLConstants.SERVICE_CHARGE_TYPE_ATTR);
			log.trace("found service charge type [" + this.currentChargeType + "]");
		// handles service charge amount
		} else if (XMLConstants.SERVICE_VALUE_PATH.equals(this.context.getCurrentPath())) {
			if (XMLConstants.SERVICE_MOA_TYPE_203_VALUE.equals(_attributes.getValue(XMLConstants.SERVICE_MOA_TYPE_ATTR))) {
				this.currentChargeValue = _attributes.getValue(XMLConstants.SERVICE_MOA_VALUE_ATTR);
				log.trace("found service charge value [" + this.currentChargeValue + "]");
			}
		// handles service quantity
		} else if (XMLConstants.SERVICE_QUANTITY_PATH.equals(this.context.getCurrentPath())) {
			if (XMLConstants.SERVICE_QUANTITY_TYPE_110_VALUE.equals(_attributes.getValue(XMLConstants.SERVICE_QUANTITY_TYPE_ATTR))) {
				ParserHelper parser = (ParserHelper) this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
				Number qty = parser.parseNumber(_attributes.getValue(XMLConstants.SERVICE_QUANTITY_VOLUME_ATTR));
				if (qty == null) { qty = new Double(0); }
				this.currentQuantity = qty.doubleValue();
				if (this.currentQuantity == Double.NaN) { this.currentQuantity = 0.0d; }
				log.trace("found service charge quantity [" + this.currentQuantity + "]");
			} else if (XMLConstants.SERVICE_QUANTITY_TYPE_111_VALUE.equals(_attributes.getValue(XMLConstants.SERVICE_QUANTITY_TYPE_ATTR))) {
				this.currentPeriod = _attributes.getValue(XMLConstants.SERVICE_QUANTITY_VOLUME_ATTR);
				log.trace("found service charge period [" + this.currentPeriod + "]");
			}
		// handles service status
		} else if (XMLConstants.SERVICE_STATUS_PATH.equals(this.context.getCurrentPath())) {
			if (XMLConstants.CONTRACT_CD_STATE_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR))) {
				// initializing current status
				this.currentStatus = new ServiceStatusInfo();				
				this.currentStatus.status = _attributes.getValue(XMLConstants.SERVICE_STATUS_ATTR);
				
				log.trace("found service status [" + this.currentStatus.status + "]");
			}
		//  marks which date (start or end) is being handled
		} else if ((XMLConstants.SERVICE_STATUS_DATETIME_PATH.equals(this.context.getCurrentPath())) && (this.currentStatus != null) && (this.currentStatus.status != null)) {
				this.currentStatusDateType = _attributes.getValue(XMLConstants.SERVICE_DATETIME_TYPE_ATTR);
		// next two handle discounts 
		} else if ((this.context.getCurrentPath().equals(XMLConstants.SERVICE_DISCOUNT_PATH)) &&
				   (XMLConstants.CONTRACT_CD_DISC_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_CD_ATTR)))) {

			this.currentDiscount = _attributes.getValue(XMLConstants.CONTRACT_FULLVALUE_ATTR);
			
		} else if ((this.context.getCurrentPath().equals(XMLConstants.SERVICE_DISCOUNT_VALUE_PATH)) &&
				   (XMLConstants.CONTRACT_AMOUNT_TYPE_919_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_TYPE_ATTR))) &&
				   (this.currentDiscount != null)) {
			// saving discount details
			ParserHelper parser = (ParserHelper) this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
			Number value = parser.parseNumber(_attributes.getValue(XMLConstants.CONTRACT_AMOUNT_VALUE_ATTR));
			Number nbr = this.setOrAccumulate((Number)this.currentDiscountList.get(this.currentDiscount), value);
			this.currentDiscountList.put(this.currentDiscount, nbr);
			// setting discount accumulator for this subscriber
			Number accDiscountNbr = (Number)this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_DISCOUNTS_VALUE);
			double accDiscount = value.doubleValue();
			if (accDiscountNbr != null) {
				accDiscount += accDiscountNbr.doubleValue(); 
			}
			this.context.setAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_DISCOUNTS_VALUE, new Double(accDiscount));
		}
	}

	
	/**
	 * @see org.xml.sax.ContentHandler#endElement(java.lang.String, java.lang.String, java.lang.String) 
	 */
	public void endElement(String uri, String localName, String qName) throws SAXException {

		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		// marking that the service info block has finished
		if (XMLConstants.SERVICE_PATH.equals(this.context.getCurrentPath())) {

			String invoiceStartDate = (String) this.context.getAttribute(TIMMBalanceHandler.CONTEXT_CYCLE_STARTDATE);
			String invoiceEndDate = DateHelper.rolloverMonths(invoiceStartDate, 1);
			// when status should be M
			
			ParserHelper currencyParser = (ParserHelper) this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
			ParserHelper numberParser = (ParserHelper) this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
			
			boolean foundAnyOK = false;
			Number amount = currencyParser.parseNumber((String) this.currentChargeValue);
			for (Iterator it=this.statusList.iterator(); it.hasNext();) {
				foundAnyOK |= isStatusOKWithValue(amount, ((ServiceStatusInfo) it.next()).status); 
			}
			String lastStatus = null, lastStartDate = null, lastEndDate = null;
			for (Iterator it=this.statusList.iterator(); it.hasNext();) {
				ServiceStatusInfo ssi = (ServiceStatusInfo) it.next();
				if ((!foundAnyOK) || isStatusOKWithValue(amount, ssi.status)) {
					lastStatus = ssi.status;
					lastStartDate = DateHelper.minDate(lastStartDate, ssi.startDate);
					lastEndDate = DateHelper.maxDate(lastEndDate, ssi.endDate);
				}
			}
			
			if ( XMLConstants.SERVICE_STATUS_ACTIVE_VALUE.equals(lastStatus)    && 
				 ((lastStartDate != null) && (lastStartDate.length() > 0)) &&
				 ((lastEndDate	 != null) && (lastEndDate.length() > 0))       &&
				 (!(DateHelper.sameDate(lastStartDate, invoiceStartDate) && DateHelper.sameDate(lastEndDate, invoiceEndDate))) 
			   ) {
				lastStatus = XMLConstants.SERVICE_STATUS_MODIFIED_VALUE;
				log.debug("service status changed to 'm'");
				// when should move start/end date due to errors in the TIMM message
				if ( ((this.currentChargeValue != null) && (this.currentChargeValue.indexOf("-") >= 0)) &&
					 (!this.currentPeriod.equals(String.valueOf(DateHelper.getInterval(lastEndDate, lastStartDate))))
				   ) {
					lastStatus = XMLConstants.SERVICE_STATUS_DEACTIVE_VALUE;
					log.debug("service status changed to 'd' with startDt="+lastStartDate+"and endDt="+lastEndDate);
					lastEndDate = DateHelper.rolloverDays(lastStartDate, -1);
					Number chargeDaysAsLong = numberParser.parseNumber(this.currentPeriod);
					lastStartDate = DateHelper.rolloverDays(lastStartDate, (chargeDaysAsLong != null ? -chargeDaysAsLong.intValue()-1 : -1));
				}
			}
			// if last Start/End dates are null, then set with the invoice start/end dates
			if (lastStartDate == null) {
				lastStartDate = invoiceStartDate;
			}
			if (lastEndDate == null) {
				lastEndDate = invoiceEndDate;
			}
			
			// save service info if its OK
			if ((this.currentService != null) && (this.currentChargeType != null) && (this.currentChargeValue != null)) {
				
				final Map currentServiceInfo = this.getCurrentServiceInfo();
				final Map currentServiceHeader = this.getCurrentServiceHeader();
				
				Number chargeValue = currencyParser.parseNumber(this.currentChargeValue);
				// accumulating service charge
				Number serviceValue = setOrAccumulate((Number)currentServiceInfo.get(CONTEXT_SERVICE_CHARGE_VALUE), chargeValue);
				currentServiceInfo.put(CONTEXT_SERVICE_CHARGE_VALUE, serviceValue);
				this.accumulateNOL(lastStatus, lastStartDate, lastEndDate);
				
				String mrktType = (String)this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_TYPE);
				if (XMLConstants.SERVICE_CHARGE_TYPE_A_VALUE.equals(this.currentChargeType) ||
					 (XMLConstants.SERVICE_CHARGE_TYPE_S_VALUE.equals(this.currentChargeType) 
					  && XMLConstants.CONTRACT_MRKT_AMP_TYPE.equals(mrktType))        ||
					  XMLConstants.SERVICE_NAME_IDCD_VALUE.equals(this.currentService)) {
					
					if (this.isMonthlyFeeService()) {
						Number n = setOrAccumulate((Number)this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_MONTHLYFEE_VALUE), chargeValue);
						this.context.setAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_MONTHLYFEE_VALUE, n);
					} else if (this.isAdditionalService()) {
						Number n = setOrAccumulate((Number)this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ADDITIONAL_VALUE), chargeValue);
						this.context.setAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ADDITIONAL_VALUE, n);
					}
				}
					
				if (this.isOnlineService()) {
					Number n = setOrAccumulate((Number)this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ONLINE_VALUE), chargeValue);
					this.context.setAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_ONLINE_VALUE, n);
				}
				
				//setting service main information
				// TODO look which fields are CHARGE-ONLY and remove then
				log.debug("service [" + this.currentService + "] added to map");
				currentServiceInfo.put(CONTEXT_SERVICE_STATUS, lastStatus);
				currentServiceInfo.put(CONTEXT_SERVICE_STARTDATE, lastStartDate);
				currentServiceInfo.put(CONTEXT_SERVICE_ENDATE, lastEndDate);
				// adding description per service + chargeType, and a global reference too
				currentServiceInfo.put(CONTEXT_SERVICE_CHARGE_TYPE, this.currentChargeType);
				currentServiceHeader.put(CONTEXT_SERVICE_CHARGE_TYPE, this.currentChargeType);
				currentServiceInfo.put(CONTEXT_SERVICE_CHARGE_PERIOD, this.currentPeriod);
				String quantity = DurationFormat.formatFromMinutes(this.currentQuantity);
				currentServiceInfo.put(CONTEXT_SERVICE_CHARGE_QUANTITY, quantity);
				// adding description per service + chargeType, and a global reference too
				currentServiceInfo.put(CONTEXT_SERVICE_DESCRIPTION, this.currentDescription);
				currentServiceHeader.put(CONTEXT_SERVICE_DESCRIPTION, this.currentDescription);
				// other service info 
				currentServiceInfo.put(CONTEXT_SERVICE_NAME, this.currentService);
				currentServiceInfo.put(CONTEXT_SERVICE_TARIFF, this.currentTariff);
				
				// setting each charge 
				Map serviceChargeDetails = new LinkedHashMap();
				serviceChargeDetails.put(CONTEXT_SERVICE_CHARGE_VALUE, chargeValue);
				serviceChargeDetails.put(CONTEXT_SERVICE_STATUS, lastStatus);
				serviceChargeDetails.put(CONTEXT_SERVICE_STARTDATE, lastStartDate);
				serviceChargeDetails.put(CONTEXT_SERVICE_ENDATE, lastEndDate);
				serviceChargeDetails.put(CONTEXT_SERVICE_CHARGE_TYPE, this.currentChargeType);
				serviceChargeDetails.put(CONTEXT_SERVICE_CHARGE_PERIOD, this.currentPeriod);
				serviceChargeDetails.put(CONTEXT_SERVICE_CHARGE_QUANTITY, quantity);
				serviceChargeDetails.put(CONTEXT_SERVICE_DESCRIPTION, this.currentDescription);
				serviceChargeDetails.put(CONTEXT_SERVICE_NAME, this.currentService);
				serviceChargeDetails.put(CONTEXT_SERVICE_TARIFF, this.currentTariff);
				serviceChargeDetails.put(CONTEXT_SERVICE_DISCOUNTS, this.currentDiscountList);
				log.debug("current service charges set to " + serviceChargeDetails);
				this.getCurrentServiceDetails().add(serviceChargeDetails);
			}
			// reset service information
			this.reset();
			
		// set last end/start date
		} else if (XMLConstants.SERVICE_STATUS_ROOTPATH.equals(this.context.getCurrentPath())) {
			this.statusList.add(this.currentStatus);
		}
	}

	/**
	 * @see org.xml.sax.ContentHandler#characters(char[], int, int)
	 */
	public void characters(char[] _chars, int _start, int _length) throws SAXException {

		if (! TIMMTypeSelectorHandler.DOCUMENT_TYPE_SUMSHEET_VALUE.equals(this.context.getAttribute(TIMMTypeSelectorHandler.CONTEXT_DOCUMENT_TYPE))) {
			return;
		}
		
		//TODO does it really need this isOk()?
		if ((XMLConstants.SERVICE_STATUS_DATETIME_TEXT_PATH.equals(this.context.getCurrentPath())) //&& 
//			(this.isStatusOK(this.lastStatus))
		   ) {
			if (XMLConstants.SERVICE_DATETIME_TYPE_ENDATE_VALUE.equals(this.currentStatusDateType)) {
				this.currentStatus.endDate = new String(_chars, _start, _length);
				log.debug("found current end date=" + this.currentStatus.endDate);
			} else if (XMLConstants.SERVICE_DATETIME_TYPE_STARTDATE_VALUE.equals(this.currentStatusDateType)) {
				this.currentStatus.startDate = new String(_chars, _start, _length);
				log.debug("found current start date=" + this.currentStatus.startDate);
			}
		}
	}
	
	public void reset() {
		this.currentService = null;
		this.currentStatus = new ServiceStatusInfo();
		this.statusList.clear();
		this.currentStatusDateType = null;
		this.currentChargeType = null;
		this.currentChargeValue = null;
		this.currentPeriod = null;
		this.currentQuantity = Double.NaN;
		this.currentDescription = null;
		this.currentTariff = null;
		this.currentDiscount = null;
		
		this.currentDiscountList = new LinkedHashMap();
	}

	private void accumulateNOL(String _lastStatus, String _lastStartDate, String _lastEndDate) {
		if (ALL_NOL_SERVICES.indexOf("|" + this.currentService + "|") > 0) {
			Map serviceDetails = (Map) this.context.getAttribute(CONTEXT_SERVICE_DETAILS);
			List onlineDetails = (List) serviceDetails.get(CONTEXT_ONLINE_LIST);
			if (onlineDetails == null) {
				onlineDetails = new LinkedList();
				serviceDetails.put(CONTEXT_ONLINE_LIST, onlineDetails);
			}
			Map record = new LinkedHashMap();
			onlineDetails.add(record);
			// building online detail
			record.put(CONTEXT_ONLINE_CHARGE_TYPE, this.currentChargeType);
			record.put(CONTEXT_ONLINE_SERVICE_NAME, this.currentService);
			record.put(CONTEXT_ONLINE_SERVICE_DESCRIPTION, this.currentDescription);
			record.put(CONTEXT_ONLINE_QUANTITY, Double.valueOf(this.currentQuantity / 60.0d));
			record.put(CONTEXT_ONLINE_STATUS, _lastStatus);
			record.put(CONTEXT_ONLINE_START_DATE, DateHelper.toDateNoYearFormat(_lastStartDate));
			record.put(CONTEXT_ONLINE_END_DATE, DateHelper.toDateNoYearFormat(_lastEndDate));
			record.put(CONTEXT_ONLINE_CHARGE_DAYS, this.currentPeriod);
			record.put(CONTEXT_ONLINE_VALUE, this.currentChargeValue);
		}
	}	
	
	private boolean isStatusOKWithValue(Number _value, String _status) {
	
		return
		  ((_value.doubleValue() >= 0) && (XMLConstants.SERVICE_STATUS_ACTIVE_VALUE.equals(_status)))     ||
		   ((_value.doubleValue()  < 0) && (XMLConstants.SERVICE_STATUS_DEACTIVE_VALUE.equals(_status) ||
				   						    XMLConstants.SERVICE_STATUS_SUSPENDED_VALUE.equals(_status)));
	}
	
	private List getCurrentServiceDetails() {
		Map serviceDetails = (Map) this.context.getAttribute(CONTEXT_SERVICE_DETAILS);
		String key = this.currentService + "|" + this.currentChargeType + "|DETAILS";
		if (! serviceDetails.containsKey(key)) {
			serviceDetails.put(key, new LinkedList());
		}
		return (List)serviceDetails.get(key);
	}
	
	private Map getCurrentServiceInfo() {
		Map serviceDetails = (Map) this.context.getAttribute(CONTEXT_SERVICE_DETAILS);
		String key = this.currentService + "|" + this.currentChargeType;
		if (! serviceDetails.containsKey(key)) {
			serviceDetails.put(key, new LinkedHashMap());
		}
		return ((Map) serviceDetails.get(key));
	}

	private Map getCurrentServiceHeader() {
		Map serviceDetails = (Map) this.context.getAttribute(CONTEXT_SERVICE_HEADER);
		if (! serviceDetails.containsKey(this.currentService)) {
			serviceDetails.put(this.currentService, new LinkedHashMap());
		}
		return ((Map) serviceDetails.get(this.currentService));
	}
	
	private Number setOrAccumulate(Number _untilNow, Number _addNumber) {
		double d = _addNumber.doubleValue();
		if (_untilNow != null) {
			d += _untilNow.doubleValue();
		}
		return (new Double(d));	
	}

	private boolean isAdditionalService() {
		return (  
		    (this.currentService != null)      &&
			(!this.currentService.equals("SMST") ) && (!this.currentService.equals("WP")   ) && 
      (!this.currentService.equals("TWM")  ) &&	(!this.currentService.equals("WPTWM")) && 
      (!this.currentService.equals("CLIRB")) && (!this.currentService.equals("NMSIM")) && 
      (!this.currentService.equals("NMPLS")) && (!this.currentService.equals("NMBAS")) &&
			(!this.currentService.equals("N200K")) && (!this.currentService.equals("MDD3") ) && 
      (!this.currentService.equals("N1200")) && (!this.currentService.equals("N2200")) && 
      (!this.currentService.equals("N4200")) && (!this.currentService.equals("N5200")) && 
			(!this.currentService.equals("N2300")) && (!this.currentService.equals("N3300")) && 
      (!this.currentService.equals("N4300")) &&	(!this.currentService.equals("N5300")) && 
      (!this.currentService.equals("N1600")) && (!this.currentService.equals("N2600")) &&
			(!this.currentService.equals("N3600")) && (!this.currentService.equals("N4600")) && 
      (!this.currentService.equals("N5600")) && (!this.currentService.equals("N11MB")) && 
      (!this.currentService.equals("N21MB")) && (!this.currentService.equals("N31MB")) &&
			(!this.currentService.equals("N41MB")) && (!this.currentService.equals("N51MB")) && 
      (!this.currentService.equals("N13MB")) && (!this.currentService.equals("N23MB")) && 
      (!this.currentService.equals("N33MB")) && (!this.currentService.equals("N43MB")) &&
			(!this.currentService.equals("N53MB")) && (!this.currentService.equals("N110M")) && 
      (!this.currentService.equals("N210M")) &&	(!this.currentService.equals("N310M")) && 
      (!this.currentService.equals("N410M")) && (!this.currentService.equals("N510M")) &&
			(!this.currentService.equals("MDD1") ) && (!this.currentService.equals("MDD2") ) && 
      (!this.currentService.equals("GPSDA")) &&	(!this.currentService.equals("MDD4") ) && 
      (!this.currentService.equals("N1300")) && (!this.currentService.equals("EQON") ) &&
      (!this.currentService.equals("NOWAS")) && (!this.currentService.equals("LONEX")) &&
      (!this.currentService.equals("AGBKP")) &&
      (!this.currentService.equals("EQLOC")) && (!this.currentService.equals("ITAUW")) &&
      (!this.currentService.equals("ITAUA")) &&
      (!this.currentService.equals("DOWNS")) && (!this.currentService.equals("E930")) &&
      (!this.currentService.equals(XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE)) &&
			(!this.currentService.equals(XMLConstants.SERVICE_NAME_TP_VALUE)) && 
      (!this.currentService.equals(XMLConstants.SERVICE_NAME_CIRDT_VALUE)) &&
			(!this.currentService.equals(XMLConstants.SERVICE_NAME_MMST_VALUE)) && 
		    //EHO: Mudança mms outras operadoras
			(!this.currentService.equals(XMLConstants.SERVICE_NAME_DRin_VALUE)) && 
			(!this.currentService.equals(XMLConstants.SERVICE_NAME_MMSI_VALUE)) &&
      (!this.currentService.equals(XMLConstants.SERVICE_NAME_LOLGT_VALUE))
			    );
	}
	
	private boolean isOnlineService() {
		return ((this.currentService != null) && (!isAdditionalService()));
	}
	
	private boolean isMonthlyFeeService() {
		return (  
			    (this.currentService != null)      &&
				(this.currentService.equals("ME")    || this.currentService.equals("DISPP") ||
				 this.currentService.equals("TELAL") || this.currentService.equals("PPTEL"))  
	           );
	}	
}



final class ServiceStatusInfo {
	
	public String status;
	public String startDate;
	public String endDate;
	
	public ServiceStatusInfo() {}
	
	public ServiceStatusInfo(String _status, String _startDate, String _endDate) {
		this.status = _status;
		this.startDate = _startDate;
		this.endDate = _endDate;
	}
}
