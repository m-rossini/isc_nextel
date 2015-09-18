/**
 * 
 */
package br.com.auster.nextel.sax;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;

import br.com.auster.common.lang.StringUtils;
import br.com.auster.dware.sax.MultiHandlerContext;
import br.com.auster.nextel.xsl.extensions.CGIPrefix;
import br.com.auster.nextel.xsl.extensions.DurationFormat;
import br.com.auster.nextel.xsl.extensions.PhoneNumber;

/**
 * @author framos
 *
 */
public class CallDetailAccumulator {

  
  public static final String CONTEXT_DETAILS_ONLINE = "usage.online";

	private static final Logger log = Logger.getLogger(CallDetailAccumulator.class);
	
	
	private MultiHandlerContext context;
	private Map attributeStack;

	// boolean indicating which type of XCD if being stacked
	private boolean isIDCD;
	private boolean isTelephony;
	private boolean isDownload;
  private boolean isOnline;
  
  private double currentOnlineAmount;

	
	public CallDetailAccumulator(MultiHandlerContext _context) {
		
		this.context = _context;
		this.attributeStack = new HashMap();
		
		this.isDownload = false;
		this.isIDCD = false;
		this.isTelephony = false;
    this.isOnline = false;
	}
	
	public ParserHelper getNumberFormatter() {
		return (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
	}

	public ParserHelper getCurrencyFormatter() {
		return (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
	}
	
	/**
	 * CIRCUIT DATA service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value XMLConstants.SERVICE_NAME_CIRDT_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE}
	 * description: summary for DOWNLOAD service 
	 * 
	 * key: {@value XMLConstants.DOWNLOAD_DETAIL_LIST}
	 * value: List<Map>
	 * description: each Map contains the attributes needed to write the DOWNLOAD details
	 * 
	 * DOWNLOAD service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE}
	 * description: summary for DOWNLOAD service 
	 * 
	 * TORPEDO service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value XMLConstants.SERVICE_NAME_TP_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE}
	 * description: summary for TORPEDO service 
	 * 
	 * key: {@value XMLConstants.SERVICE_NAME_MMST_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE}
	 * description: summary for MMST service 
	 * 
	 * key: {@value XMLConstants.SERVICE_NAME_MMSI_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE}
	 * description: summary for MMSI service 
	 */
	public void handleDataServices(Attributes _attributes, String _key) {
	  double[] totals = AccumulatorConstants
        .getOrBuildDoubleArray(_key, this.context, AccumulatorConstants.SERVICE_DATA_ACCUM_SIZE);
    
    
    String typeIndicator = _attributes.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR);
    if (isQuantityValid(_key, typeIndicator)) {
      totals[AccumulatorConstants.SERVICE_DATA_QTTY_ACCUM] += 1;
    }
    
    String t = _attributes.getValue(XMLConstants.SERVICE_DATA_AMOUNT_ATTR);
    ParserHelper parser = (ParserHelper) this.context
        .getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
    Number n = parser.parseNumber(t);
    if (n != null) {
      this.currentOnlineAmount = n.doubleValue();
      totals[AccumulatorConstants.SERVICE_DATA_AMNT_ACCUM] += this.currentOnlineAmount;
    }
	}
  
  public boolean isQuantityValid(String serviceId, String typeIndicator) {
    boolean result = false;
    //EHO: mms outra operadora - Drin
    if ( (XMLConstants.SERVICE_NAME_TP_VALUE.equals(serviceId) ||
          XMLConstants.SERVICE_NAME_MMST_VALUE.equals(serviceId) || 
          XMLConstants.SERVICE_NAME_DRin_VALUE.equals(serviceId) || 
          XMLConstants.SERVICE_NAME_MMSI_VALUE.equals(serviceId)) ) {
      // if TORPEDO, update quantity only if it is an 'AIR' usage
      if (XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndicator)) {
        result = true;
      }
    } else {
      result = true;
    }
    return result;
  }
  //EHO: function para contemplar promoção sms, retornar verdadeiro se TP,MMST,MMSI e com valor unit > 0
  //EHO: mms outra operadora - Drin
  public boolean isQuantityValid2(String serviceId, String typeIndicator, double amount_value) {
	    boolean result = false;
	    if ( (XMLConstants.SERVICE_NAME_TP_VALUE.equals(serviceId) ||
	          XMLConstants.SERVICE_NAME_MMST_VALUE.equals(serviceId) || 
	          XMLConstants.SERVICE_NAME_DRin_VALUE.equals(serviceId) || 
	          XMLConstants.SERVICE_NAME_MMSI_VALUE.equals(serviceId) )) {
	    	
	            // if TORPEDO, update quantity only if it is an 'AIR' usage
	            if (XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndicator)) {
	            		if (amount_value > 0) {
	            			result = true;
	            		}
	            }
	    } else {
	    	result = true;
	    }
	    return result;
	  }

  
  public void handleOnlineServices(Attributes _attributes, String _key) {
    // saving attributes for online details
    this.attributeStack.put(_key, _attributes);
    log.trace("stacked online as " + _key);
    this.isOnline = true;
  }
  
  public void accumulateOnline() {
    Attributes xcdAttrs = (Attributes) this.attributeStack.get(XMLConstants.USAGE_ELEMENT);
    String serviceId = xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR);
    String onlineId = serviceId;
    if (XMLConstants.SERVICE_NAME_TP_VALUE.equals(serviceId)) {
      // this is a torpedo (SMS), so we need to store the details
      onlineId = xcdAttrs.getValue(XMLConstants.TEL_TARIFF_ZONE_ATTR);
      if (onlineId != null && onlineId.length() > 0 &&
          !XMLConstants.SERVICE_TARIFFZONE_SMS0_VALUE.equals(onlineId)) {
        onlineId = XMLConstants.SERVICE_TARIFFZONE_SMSSI_VALUE;
      } else {
        onlineId = XMLConstants.SERVICE_NAME_TP_VALUE;
      }
    }
    Map onlineCalls = AccumulatorConstants.getOrBuildMap(CONTEXT_DETAILS_ONLINE, this.context);
    Map svc = AccumulatorConstants.getOrBuildMap(onlineId, onlineCalls);
    
    // accumulate amount and quantity
    double[] v = (double[]) svc.get(XMLConstants.SERVICE_DATA_AMOUNT_ATTR);
    if (v != null) {
      v[0] += this.currentOnlineAmount;
    } else {
      svc.put(XMLConstants.SERVICE_DATA_AMOUNT_ATTR, new double[] { this.currentOnlineAmount });
    }
    
    // accumulate amount and quantity
    int[] q = (int[]) svc.get(XMLConstants.SERVICE_QUANTITY_VOLUME_ATTR);

    boolean isQValid = isQuantityValid(serviceId, xcdAttrs.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR));
    boolean isQValid2 = isQuantityValid2(serviceId, xcdAttrs.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR),this.currentOnlineAmount);

    if (q != null ) {
      if (isQValid2) {
 	      		  q[0]++;
      }
    } else {
      svc.put(XMLConstants.SERVICE_QUANTITY_VOLUME_ATTR, new int[] { isQValid2 ? 1 : 0 }); // {0 } ); //{ isQValid ? 1 : 0 });
    }

    
    // usage details
    List details = AccumulatorConstants.getOrBuildList(XMLConstants.USAGE_ELEMENT, svc);
    Map record = new HashMap();
    // MAIN NUMBER
    record.put(XMLConstants.TEL_MAINNUMBER_ATTR, xcdAttrs.getValue(XMLConstants.TEL_MAINNUMBER_ATTR));
    // SN
    String typeIndXCD = xcdAttrs.getValue(XMLConstants.TEL_TYPE_INDICATOR_ATTR);
    record.put(XMLConstants.TEL_TYPE_INDICATOR_ATTR, typeIndXCD);
    if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
      XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD)) {
      record.put(XMLConstants.TEL_CALL_CHARGETYPE, XMLConstants.TEL_CALL_CHARGETYPE_AIR);
    } else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeIndXCD)) {
      record.put(XMLConstants.TEL_CALL_CHARGETYPE, XMLConstants.TEL_CALL_CHARGETYPE_TOLL);
    }
    Attributes detailAttrs = (Attributes) this.attributeStack.get(XMLConstants.TEL_CRTIME_ELEMENT);
    record.put(XMLConstants.TEL_CRTIME_DATE_ATTR, 
               detailAttrs.getValue(XMLConstants.TEL_CRTIME_DATE_ATTR));
    record.put(XMLConstants.TEL_CRTIME_TIME_ATTR, 
               detailAttrs.getValue(XMLConstants.TEL_CRTIME_TIME_ATTR));
    record.put(XMLConstants.TEL_AMOUNT_RATED_ATTR, 
               this.getCurrencyFormatter().formatNumber(this.currentOnlineAmount));
    //SMS Description
	Attributes callOutboundAttrs = (Attributes)this.attributeStack.get(XMLConstants.TEL_OUTBOUND_ELEMENT_DEST);	
	if (callOutboundAttrs != null)
	{
		if (callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR) != null) 
			{
			 if (callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR).trim().length() > 0) 
		        {			
			     record.put(XMLConstants.TEL_CALL_DESTINATION_ZONE, callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR));
			    } 	
			}
	}				
    //SMS Description
    details.add(record);
    this.currentOnlineAmount = 0d;
    this.attributeStack.clear();
    this.isOnline = false;
  }
  
  public boolean isOnlineUnderAccumulation() {
    return this.isOnline &&    
           this.attributeStack.containsKey(XMLConstants.USAGE_ELEMENT);
  }
  
  public void handleDownloadServices(Attributes _attributes, String _key) {
    // saving attributes for download details
    this.attributeStack.put(_key, _attributes);
    log.trace("stacked download as " + _key);
    this.isDownload = true;
  }

	public void accumulateDownloads() {
		Attributes downAttrs = (Attributes) this.attributeStack.get(XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE);
		Attributes vasAttrs = (Attributes) this.attributeStack.get(XMLConstants.DOWNLOAD_VAS_ELEMENT);
		Attributes timeAttrs = (Attributes) this.attributeStack.get(XMLConstants.DOWNLOAD_CRTIME_ELEMENT);
		if ((downAttrs == null) || (vasAttrs == null) || (timeAttrs == null)) {
			log.warn("skipping this download detail since one of down/vas/time attrs is null: " + 
					 "down=" + (downAttrs == null) + ";" + 
					 "vas=" + (vasAttrs == null) + ";" +
					 "time=" + (timeAttrs == null) + ";" );
		}
		Map record = new HashMap();
		record.put(XMLConstants.DOWNLOAD_MAINNUMBER_ATTR, downAttrs.getValue(XMLConstants.DOWNLOAD_MAINNUMBER_ATTR));
		record.put(XMLConstants.DOWNLOAD_VAS_REMARK_ATTR, vasAttrs.getValue(XMLConstants.DOWNLOAD_VAS_REMARK_ATTR));
		record.put(XMLConstants.DOWNLOAD_AMOUNT_ATTR, downAttrs.getValue(XMLConstants.DOWNLOAD_AMOUNT_ATTR));
		record.put(XMLConstants.DOWNLOAD_CRTIME_TIME_ATTR, timeAttrs.getValue(XMLConstants.DOWNLOAD_CRTIME_TIME_ATTR));
		record.put(XMLConstants.DOWNLOAD_CRTIME_DATE_ATTR, timeAttrs.getValue(XMLConstants.DOWNLOAD_CRTIME_DATE_ATTR));
		// save download detail 
		List details = AccumulatorConstants.getOrBuildList(XMLConstants.DOWNLOAD_DETAIL_LIST, this.context);
		details.add(record);
		this.attributeStack.clear();
		this.isDownload = false;
	}

	public boolean isDownloadUnderAccumulation() {
		return this.isDownload && 
           this.attributeStack.containsKey(XMLConstants.SERVICE_NAME_DOWNLOAD_VALUE);
	}
		
	/**
	 * DISPATCH service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value XMLConstants#DISPATCH_ACC_SUMMARY}
	 * value: double[] of size {@value AccumulatorConstants.DISPATCH_ACCUM_SIZE}
	 * description: summary for all DISPATCH service 
	 * 
	 * key: {@value XMLConstants#SERVICE_NAME_DISPP_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.DISPATCH_ACCUM_SIZE}
	 * description: summary for individual dispatch service 
	 * 
	 * key: {@value XMLConstants#SERVICE_NAME_DISPG_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.DISPATCH_ACCUM_SIZE}
	 * description: summary for group dispatch service 
	 */
	public void handleDispatch(Attributes _attributes) {
		
		ParserHelper currencyParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
		ParserHelper numberParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
		
		Number amtNbr = currencyParser.parseNumber(_attributes.getValue(XMLConstants.DISPATCH_AMOUNT_ATTR));
		double amt = 0;
		if (amtNbr != null) { amt = amtNbr.doubleValue(); }
		double franquia = 0;
		double apagar = 0;
		double total = 0;
		// total geral
		double[] totals = AccumulatorConstants.getOrBuildDoubleArray(XMLConstants.DISPATCH_ACC_SUMMARY, this.context, AccumulatorConstants.DISPATCH_ACCUM_SIZE);
		if (XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(_attributes.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR))) {
			Number ratedBeforeNbr = numberParser.parseNumber(_attributes.getValue(XMLConstants.DISPATCH_RATED_BEFORE_ATTR));
			double ratedBefore = 0;
			if (ratedBeforeNbr != null) { ratedBefore = ratedBeforeNbr.longValue(); }
			Number ratedAfterNbr = numberParser.parseNumber(_attributes.getValue(XMLConstants.DISPATCH_RATED_AFTER_ATTR)); 
			double ratedAfter = 0;
			if (ratedAfterNbr != null) { ratedAfter = ratedAfterNbr.longValue(); }
			Number roundedBeforeNbr = numberParser.parseNumber(_attributes.getValue(XMLConstants.DISPATH_ROUNDED_BEFORE_ATTR)); 
			double roundedBefore = 0;
			if (roundedBeforeNbr != null) { roundedBefore = roundedBeforeNbr.longValue(); }
			Number roundedAfterNbr = numberParser.parseNumber(_attributes.getValue(XMLConstants.DISPATCH_ROUNDED_AFTER_ATTR));
			double roundedAfter = 0;
			if (roundedAfterNbr != null) { roundedAfter = roundedAfterNbr.longValue(); }
			
			total = roundedBefore / 60; 
			if (amt > 0) {
				if ((_attributes.getValue(XMLConstants.DISPATCH_FREEUNIT_SHORT_ATTR) != null) &&
					(_attributes.getValue(XMLConstants.DISPATCH_FREEUNIT_SHORT_ATTR).trim().length() > 0)) {
					franquia = ((ratedBefore-ratedAfter) + (roundedBefore-roundedAfter)) / 60;
				}
				apagar = Math.min(ratedAfter, roundedAfter) / 60;
			} else {
				franquia = total;
				apagar = 0;
			}
		}
        // summary for all dispatch
		totals[AccumulatorConstants.DISPATH_SUBFRANQUIA_ACCUM] += franquia;
		totals[AccumulatorConstants.DISPATH_SUBTOTAL_ACCUM] += total;
		totals[AccumulatorConstants.DISPATH_SUBAPAGAR_ACCUM] += apagar;
		totals[AccumulatorConstants.DISPATH_SUBVALOR_ACCUM] += amt;
		// TODO: ISNT THIS DUPLICATED!?!?!?!?!?
		totals[AccumulatorConstants.DISPATH_SUBDIRETA_ACCUM] += amt;
		// summary for dispp/dispg 
		double[] summByType = AccumulatorConstants.getOrBuildDoubleArray(_attributes.getValue(XMLConstants.DISPATCH_NAME_ATTR), this.context, AccumulatorConstants.DISPATCH_DETAIL_ACCUM_SIZE);
		summByType[AccumulatorConstants.DISPATH_TOTAL_ACCUM] += total;
		summByType[AccumulatorConstants.DISPATH_FRANQUIA_ACCUM] += franquia;
		summByType[AccumulatorConstants.DISPATH_APAGAR_ACCUM] += apagar;
		summByType[AccumulatorConstants.DISPATH_AMNT_ACCUM] += amt;
	}
	
	/**
	 * IDCD service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value XMLConstants#SERVICE_NAME_IDCD_VALUE}
	 * value: double[] of size {@value AccumulatorConstants.IDCD_ACCUM_SIZE}
	 * description: summary for IDCD service 
	 * 
	 * key: {@value XMLConstants#IDCD_DETAIL_LIST}
	 * value: List<Map>
	 * description: each Map contains the attributes needed to write the IDCD details
	 */
	public void handleIDCD(Attributes _attributes, String _tag) {
		this.attributeStack.put(_tag, _attributes);
		this.isIDCD = true;
	}
		
	public void accumulateIDCD() {
		// hadling the IDCD record
		Attributes idcdAttrs = (Attributes) this.attributeStack.get(XMLConstants.USAGE_ELEMENT);
		Attributes idcdDetailAttrs = (Attributes) this.attributeStack.get(XMLConstants.IDCD_CRTIME_ELEMENT);
		Attributes idcdIndAttrs = (Attributes) this.attributeStack.get(XMLConstants.IDCD_DISCOUNT_ELEMENT);
		if ((idcdAttrs != null) && (idcdDetailAttrs != null) && (idcdIndAttrs != null)) {
			if (XMLConstants.IDCD_DISCOUNT_IND_N_VALUE.equals(idcdIndAttrs.getValue(XMLConstants.IDCD_DISCOUNT_IND_ATTR))) {
				// parsing the whole CDIC record
				ParserHelper currencyParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
				ParserHelper numberParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);

				Number amtNbr = currencyParser.parseNumber(idcdAttrs.getValue(XMLConstants.IDCD_AMOUNT_ATTR));
				double amt = 0;
				if (amtNbr != null) { amt = amtNbr.doubleValue(); }
				Number timeNbr = numberParser.parseNumber(idcdAttrs.getValue(XMLConstants.IDCD_ROUNDED_BEFORE_ATTR));
				double time = 0;
				if (timeNbr != null) { time = timeNbr.longValue(); }
				time = time  / 60;
				// accumulators
				double[] totals = AccumulatorConstants.getOrBuildDoubleArray(XMLConstants.SERVICE_NAME_IDCD_VALUE, this.context, AccumulatorConstants.IDCD_ACCUM_SIZE);
				totals[AccumulatorConstants.IDCD_AMNT_ACCUM] += amt;
				totals[AccumulatorConstants.IDCD_TIME_ACCUM] += time;
				// details
				List details = AccumulatorConstants.getOrBuildList(XMLConstants.IDCD_DETAIL_LIST, this.context);
				Map record = new HashMap();
				record.put(XMLConstants.IDCD_MAIN_NUMBER_ATTR, idcdAttrs.getValue(XMLConstants.IDCD_MAIN_NUMBER_ATTR));
				record.put(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR, idcdAttrs.getValue(XMLConstants.CONTRACT_TYPE_INDICATOR_ATTR));
				record.put(XMLConstants.IDCD_TARIFF_TIMESHORT_ATTR, idcdAttrs.getValue(XMLConstants.IDCD_TARIFF_TIMESHORT_ATTR));
				record.put(XMLConstants.IDCD_AMOUNT_ATTR, this.getCurrencyFormatter().formatNumber(amt));
				record.put(XMLConstants.IDCD_TIMECALL_ACC_VALUE, DurationFormat.formatFromMinutes(time));
				record.put(XMLConstants.IDCD_TIMECALL_M_ACC_VALUE, this.getCurrencyFormatter().formatNumber(time));
				record.put(XMLConstants.IDCD_CRTIME_TIME_ATTR, idcdDetailAttrs.getValue(XMLConstants.IDCD_CRTIME_TIME_ATTR));
				record.put(XMLConstants.IDCD_CRTIME_DATE_ATTR,  idcdDetailAttrs.getValue(XMLConstants.IDCD_CRTIME_DATE_ATTR));
				details.add(record);
			}
		}
		this.attributeStack.clear();
		this.isIDCD = false;
	}
	
	public boolean isIDCDUnderAccumulation() {
		return this.attributeStack.containsKey(XMLConstants.USAGE_ELEMENT) &&
			   this.isIDCD;
	}

	/**
	 * TELEPHONY service generates the following entries, in the accumulation map:
	 *  
	 * key: {@value TEL_LOCATION_HOME_CALL} and {@value TEL_LOCATION_ROAM_CALL} 
	 * value: double[] of size {@value AccumulatorConstants.TELEPHONY_LOCATION_SIZE}
	 * description: summary for each possible location (HOME / ROAM)
	 * 
	 * key: current location + "|" + ({@value TEL_Z3TYPE_ACC_SUMMARY} or {@value TEL_CALLS_DIRECTION_INCOMING})
	 * value: double[] of size {@value AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE}
	 * description: summary for current location + direction (INCOMING / OUTGOING)
	 * 
	 * key: current location + "|" + direction + "|" + ({@value TEL_CALLS_DIRECTION_OUTGOING} or {@value TEL_NOZ3TYPE_ACC_SUMMARY})
	 * value: double[] of size {@value AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE}
	 * description: summary for current location + direction + Z3 call type
	 *  
	 * key: current location + "|" + ({@value TEL_CALLS_SUBSECTION_Z3} or {@value TEL_CALLS_SUBSECTION_RECEIVED} or
	 *                                {@value TEL_CALLS_SUBSECTION_DISCOUNT} or {@value TEL_CALLS_SUBSECTION_COLLECT} or
	 *                                {@value TEL_CALLS_SUBSECTION_LOCAL} or {@value TEL_CALLS_SUBSECTION_LONGDISTANCE} or
	 *                                {@value TEL_CALLS_SUBSECTION_INTERNATIONAL} )
	 * value: double[] of size {@value AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE}
	 * description: summary for current location + each possible subsection
	 * 
	 * key: current location + "|" + subsection + "|XCD" 
	 * value: List<Map>
	 * description: each Map contains the attributes needed to write the CALL details, for the specific location + subsection
	 */
	public void handleTelephony(Attributes _attributes, String _tag) {
		this.attributeStack.put(_tag, _attributes);
		this.isTelephony = true;
	}

	public void accumulateTelephony() {

		ParserHelper currencyParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_CURRENCY_FORMAT);
		ParserHelper numberParser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
		
		Attributes xcdAttrs = (Attributes) this.attributeStack.get(XMLConstants.USAGE_ELEMENT);
		String typeXCD = xcdAttrs.getValue(XMLConstants.TEL_TYPE_ATTR);
		String typeIndXCD = xcdAttrs.getValue(XMLConstants.TEL_TYPE_INDICATOR_ATTR);
		String numberXCD = null;
		PhoneNumber phonenumber = new PhoneNumber();
		String cgiPrefixXCD = null;
		// number and prefix
		if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeXCD)) {
			Attributes inbound = (Attributes) this.attributeStack.get(XMLConstants.TEL_INBOUND_ELEMENT);
			numberXCD = StringUtils.trimToEmpty(inbound.getValue(XMLConstants.TEL_INBOUND_CALLNUMBER_ATTR));
			cgiPrefixXCD = StringUtils.trimToEmpty(inbound.getValue(XMLConstants.TEL_INBOUND_PREFIX_ATTR));
		} else {
			Attributes outbound = (Attributes) this.attributeStack.get(XMLConstants.TEL_OUTBOUND_ELEMENT);
			numberXCD = StringUtils.trimToEmpty(outbound.getValue(XMLConstants.TEL_OUTBOUND_CALLNUMBER_ATTR));
			cgiPrefixXCD = StringUtils.trimToEmpty(outbound.getValue(XMLConstants.TEL_OUTBOUND_PREFIX_ATTR));
			
		}
		phonenumber.parse(numberXCD);
		String cgiPrefix = CGIPrefix.getPrefix(cgiPrefixXCD);
		// tariff
		String tariff = XMLConstants.TEL_CALL_TARIFF_INURB;
		String tariffXCD = StringUtils.trimToEmpty(xcdAttrs.getValue(XMLConstants.TEL_TARIFF_ATTR));
		String tariffZone = StringUtils.trimToEmpty(xcdAttrs.getValue(XMLConstants.TEL_TARIFF_ZONE_ATTR));		
		if (XMLConstants.TEL_CALL_TARIFF_LOCAL.equals(tariffXCD) || 
			XMLConstants.TEL_CALL_TARIFF_INURB.equals(tariffXCD) ||
			XMLConstants.TEL_CALL_TARIFF_INTERNACIONAL.equals(tariffXCD)) {
			tariff = tariffXCD;
		} else if (tariffZone.startsWith(XMLConstants.TEL_TARIFF_L_VALUE)) {
			tariff = XMLConstants.TEL_CALL_TARIFF_LOCAL;
		} else if (tariffZone.startsWith(XMLConstants.TEL_TARIFF_N_VALUE)) {
			tariff = XMLConstants.TEL_CALL_TARIFF_INURB;
		} else if (tariffZone.startsWith(XMLConstants.TEL_TARIFF_I_VALUE)) {
			tariff = XMLConstants.TEL_CALL_TARIFF_INTERNACIONAL;
		} else if (numberXCD.length() <= 8) {
			tariff = XMLConstants.TEL_CALL_TARIFF_LOCAL;
		} else if ((cgiPrefix.length() == 0) || 
				   (phonenumber.getAreaCode().length() == 0) || 
				   (cgiPrefix.equals(phonenumber.getAreaCode()))) {
			tariff = XMLConstants.TEL_CALL_TARIFF_LOCAL;
		}
		// defining type
		Number amtXCDNumber = currencyParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_AMOUNT_RATED_ATTR));
		 double amtXCD = 0;
		 if (amtXCDNumber != null) { amtXCD = amtXCDNumber.doubleValue(); }
		// indicates if this is a discount XCD record
		String type = determineXCDType(typeXCD, amtXCD, tariff, tariffZone, numberXCD);
		// locale
		 String locale = XMLConstants.TEL_LOCATION_HOME_CALL;
		 String contractPrefix = (String) this.context.getAttribute(ContractSummaryHandler.CONTEXT_CONTRACT_PHONENUMBER_PREFIX);
		 boolean isPLMNInd = XMLConstants.TEL_PLMN_INDICATOR_V_VALUE.equals(xcdAttrs.getValue(XMLConstants.TEL_PLMN_INDICATOR_ATTR));
		//System.out.println(cgiPrefix+" - "+cgiPrefixXCD+" - "+contractPrefix);
		 if ( ((cgiPrefix.length() > 0) && (!cgiPrefix.equals(contractPrefix))) || isPLMNInd ) {
			locale = XMLConstants.TEL_LOCATION_ROAM_CALL;
		 	if (isPLMNInd) {
				 Attributes chargeAttrs = (Attributes) this.attributeStack.get(XMLConstants.TEL_CHARGEINFO_ELEMENT);
				 amtXCDNumber = currencyParser.parseNumber(chargeAttrs.getValue(XMLConstants.TEL_CHARGEINFO_AMOUNT_ATTR));
				 if (amtXCDNumber != null) { amtXCD = amtXCDNumber.doubleValue(); }
				 tariff = XMLConstants.TEL_CALL_TARIFF_INURB;
		 	}
		 }
		 log.debug("call: [" + phonenumber.getOriginalPhoneNumber() + "]= DDD[" + contractPrefix + "], CGI[" + cgiPrefix + "], PLMN=[" + xcdAttrs.getValue(XMLConstants.TEL_PLMN_INDICATOR_ATTR) + "]");
		 
		 // checking values
		Number ratedBeforeNbr = numberParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_RATED_BEFORE_ATTR));
		double ratedBefore = 0;
		if (ratedBeforeNbr != null) { ratedBefore = ratedBeforeNbr.longValue(); }
		Number ratedAfterNbr = numberParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_RATED_AFTER_ATTR)); 
		double ratedAfter = 0;
		if (ratedAfterNbr != null) { ratedAfter = ratedAfterNbr.longValue(); }
		Number roundedBeforeNbr = numberParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_ROUNDED_BEFORE_ATTR)); 
		double roundedBefore = 0;
		if (roundedBeforeNbr != null) { roundedBefore = roundedBeforeNbr.longValue(); }
		Number roundedAfterNbr = numberParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_ROUNDED_AFTER_ATTR));
		double roundedAfter = 0;
		if (roundedAfterNbr != null) { roundedAfter = roundedAfterNbr.longValue(); }
		 // franquia
		 double franquia = 0;
		 double total = 0;
		 if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
		     XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD)) {
			 
			 total = roundedBefore / 60;
			 String fus = xcdAttrs.getValue(XMLConstants.TEL_FREEUNIT_SHORT_ATTR);
			 if ((fus != null) && (fus.length() > 0)) {
				 franquia =  ((ratedBefore-ratedAfter) + (roundedBefore-roundedAfter)) / 60;
			 }
		 }
		 // charged minutes
		 double apagar = 0;
//EHO:nxt86012:	 variável apagar será contabilizado no mesmo instante e condição que a variável totalNoFree
//			  apagar = Math.min(ratedAfter, roundedAfter) / 60;
			  
		 // totalNoFree
		 double totalNoFree = 0;
		 Number flatAmtNbr = currencyParser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_AMOUNT_FLAT_ATTR));
		 double flatAmt = 0;
		 if (flatAmtNbr != null) { flatAmt = flatAmtNbr.doubleValue(); }
		 if ((flatAmt > 0) || 
			 (XMLConstants.TEL_PLMN_INDICATOR_V_VALUE.equals(xcdAttrs.getValue(XMLConstants.TEL_PLMN_INDICATOR_ATTR)) && (amtXCD > 0)) ||
			 (XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR)))) {
			 totalNoFree = total;
//EHO:nxt86012 inclusão da contabilização de minutos a pagar
//EHO:incluir valor a minutos a pagar somente se <> de pré-pago

			 if (!XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR))) {
    			 apagar = Math.min(ratedAfter, roundedAfter) / 60;
			 }

		 }
		 // location totals
		 double[] totals = AccumulatorConstants.getOrBuildDoubleArray(locale, this.context, AccumulatorConstants.TELEPHONY_LOCATION_SIZE);
		 totals[AccumulatorConstants.TELEPHONY_TOT_ACCUM] += totalNoFree;
		 totals[AccumulatorConstants.TELEPHONY_FRA_ACCUM] += franquia;
		 if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
			 XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD)) {
			 totals[AccumulatorConstants.TELEPHONY_APA_ACCUM] += apagar;
		 }
		 totals[AccumulatorConstants.TELEPHONY_AMT_ACCUM] += amtXCD;
		 // subsection totals
		 // TODO cant i remove some of those???
		 String z3AccKey = (XMLConstants.TEL_CALLS_SUBSECTION_Z3.equals(type) ? XMLConstants.TEL_Z3TYPE_ACC_SUMMARY : XMLConstants.TEL_NOZ3TYPE_ACC_SUMMARY);
		 String dirAccKey = (XMLConstants.TEL_TYPE_O_VALUE.equals(typeXCD) ? XMLConstants.TEL_CALLS_DIRECTION_OUTGOING : XMLConstants.TEL_CALLS_DIRECTION_INCOMING);
		 double[] summaryCall = AccumulatorConstants.getOrBuildDoubleArray(locale + "|" + type, this.context, 
				 									  AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE);
		 double[] summaryDir = AccumulatorConstants.getOrBuildDoubleArray(locale + "|" + dirAccKey, 
				 		              			     this.context, AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE);
		 double[] summaryZ300 = AccumulatorConstants.getOrBuildDoubleArray(locale + "|" + dirAccKey + "|" + z3AccKey, this.context,  
				 				                      AccumulatorConstants.TELEPHONY_SUBSECTION_ACCUM_SIZE);
		 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_NOFREE_ACCUM] += totalNoFree;
		 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_NOFREE_ACCUM] += totalNoFree;
		 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_NOFREE_ACCUM] += totalNoFree;
		 // TOT or AIR accumulators
		 if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
			 XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD)) {
			 // totAir
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_TOTAIR_ACCUM] += totalNoFree;
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_TOTAIR_ACCUM] += totalNoFree;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_TOTAIR_ACCUM] += totalNoFree;
			 //fraAir
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_FRAAIR_ACCUM] += franquia;
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_FRAAIR_ACCUM] += franquia;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_FRAAIR_ACCUM] += franquia;
			 //apaAir
			 if (!XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR))) {
				 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_APAAIR_ACCUM] += apagar;
			 }
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_APAAIR_ACCUM] += apagar;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_APAAIR_ACCUM] += apagar;
			 // valAir
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_VALAIR_ACCUM] += amtXCD;
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_VALAIR_ACCUM] += amtXCD;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_VALAIR_ACCUM] += amtXCD;
		 } else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeIndXCD)) {
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_APATOT_ACCUM] += apagar;
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_APATOT_ACCUM] += apagar;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_APATOT_ACCUM] += apagar;
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_VALTOT_ACCUM] += amtXCD;
			 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_VALTOT_ACCUM] += amtXCD;
			 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_VALTOT_ACCUM] += amtXCD;
		 } 
		 if (!XMLConstants.SERVICE_NAME_PPTEL_VALUE.equals(xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR))) {
			 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_APA_ACCUM] += apagar;
		 }
		 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_TOT_ACCUM] += total;
		 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_TOT_ACCUM] += total;
		 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_TOT_ACCUM] += total;
		 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_FRA_ACCUM] += franquia;
		 summaryCall[AccumulatorConstants.TELEPHONY_SUMM_VAL_ACCUM] += amtXCD;
		 summaryDir[AccumulatorConstants.TELEPHONY_SUMM_VAL_ACCUM] += amtXCD;
		 summaryZ300[AccumulatorConstants.TELEPHONY_SUMM_VAL_ACCUM] += amtXCD;
		 
		 // handing details
		 this.accumulateTelephonyDetail(locale, type, phonenumber, amtXCD, tariff);
		 
		 this.context.setAttribute(XMLConstants.XML_CONTRACT_PP_ATTR, xcdAttrs.getValue(XMLConstants.SERVICE_SHORTNAME_ATTR));
		 
		 // empty stack
		 this.attributeStack.clear();
		 this.isTelephony = false;
	}
	
	private void accumulateTelephonyDetail(String _locale, String _type, PhoneNumber _phonenumber, 
                                         double _amount, String _tariff) {
	
		Attributes xcdAttrs = (Attributes) this.attributeStack.get(XMLConstants.USAGE_ELEMENT);
		String typeIndXCD = xcdAttrs.getValue(XMLConstants.TEL_TYPE_INDICATOR_ATTR);
		// timeCall = roundedBefore / 60
		ParserHelper parser = (ParserHelper)this.context.getAttribute(TIMMContentHandlerPipe.CONF_NUMBER_FORMAT);
		Number timeCallNbr = parser.parseNumber(xcdAttrs.getValue(XMLConstants.TEL_ROUNDED_BEFORE_ATTR));
		double timeCall = 0;
		if (timeCallNbr != null) { timeCall = timeCallNbr.longValue(); }
		timeCall /= 60;
		List details = AccumulatorConstants.getOrBuildList(_locale + "|" + _type + "|" + XMLConstants.USAGE_ELEMENT, this.context);
		Map record = new HashMap();
		details.add(record);
		// MAIN NUMBER
		record.put(XMLConstants.TEL_MAINNUMBER_ATTR, xcdAttrs.getValue(XMLConstants.TEL_MAINNUMBER_ATTR));
		// SN
		record.put(XMLConstants.TEL_TYPE_INDICATOR_ATTR, typeIndXCD);
		 if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
				 XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD)) {
			 record.put(XMLConstants.TEL_CALL_CHARGETYPE, XMLConstants.TEL_CALL_CHARGETYPE_AIR);
		 } else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeIndXCD)) {
			 record.put(XMLConstants.TEL_CALL_CHARGETYPE, XMLConstants.TEL_CALL_CHARGETYPE_TOLL);
		 } 
		 // classification
		if ("8".equals(_phonenumber.getFirstDigit()) || "9".equals(_phonenumber.getFirstDigit())|| "6".equals(_phonenumber.getFirstDigit())) {
			record.put(XMLConstants.TEL_CALL_NUMBERTYPE, XMLConstants.TEL_CALL_NUMBERTYPE_MOBILE);
		} else {
			record.put(XMLConstants.TEL_CALL_NUMBERTYPE, XMLConstants.TEL_CALL_NUMBERTYPE_OTHER);
		}
		
		if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(typeIndXCD) || 
			XMLConstants.CONTRACT_TYPE_INDICATOR_A_VALUE.equals(typeIndXCD) || 
			XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(typeIndXCD)) {
			
			Attributes detailAttrs = (Attributes)this.attributeStack.get(XMLConstants.TEL_CRTIME_ELEMENT);
			record.put(XMLConstants.TEL_CRTIME_DATE_ATTR, detailAttrs.getValue(XMLConstants.TEL_CRTIME_DATE_ATTR));
			record.put(XMLConstants.TEL_CRTIME_TIME_ATTR, detailAttrs.getValue(XMLConstants.TEL_CRTIME_TIME_ATTR));
		
			Attributes callInfoAttrs = (Attributes)this.attributeStack.get(XMLConstants.TEL_CALLORIGIN_ELEMENT);			
			Attributes callDestAttrs = (Attributes)this.attributeStack.get(XMLConstants.TEL_CALLDESTINATION_ELEMENT);
			if ( XMLConstants.TEL_PLMN_INDICATOR_V_VALUE.equals(xcdAttrs.getValue(XMLConstants.TEL_PLMN_INDICATOR_ATTR)) &&
				 ((StringUtils.trimToEmpty(callInfoAttrs.getValue(XMLConstants.TEL_CALLORIGIN_CITY_ATTR)).length() +
				   StringUtils.trimToEmpty(callDestAttrs.getValue(XMLConstants.TEL_CALLDESTINATION_COUNTRY_ATTR)).length()) == 0) ) {
				
				Attributes chargeAttrs = (Attributes) this.attributeStack.get(XMLConstants.TEL_CHARGEINFO_ELEMENT);
				record.put(XMLConstants.TEL_CALL_SOURCE, chargeAttrs.getValue(XMLConstants.TEL_CHARGEINFO_DESCRIPTION_ATTR));
//				SRV_TEL_DESTINATION is empty
			} else {
				record.put(XMLConstants.TEL_CALL_SOURCE, callInfoAttrs.getValue(XMLConstants.TEL_CALLORIGIN_CITY_ATTR));
				record.put(XMLConstants.TEL_CALL_DESTINATION, callDestAttrs.getValue(XMLConstants.TEL_CALLDESTINATION_COUNTRY_ATTR));
			}
			record.put(XMLConstants.TEL_CALL_FROMNUMBER, _phonenumber.getOriginalPhoneNumber());
			record.put(XMLConstants.TEL_CALL_DURATION, DurationFormat.formatFromMinutes(timeCall));
			record.put(XMLConstants.TEL_CALL_DURATION_M, this.getCurrencyFormatter().formatNumber(timeCall));			
//          SMS + MIT
			Attributes callOutboundAttrs = (Attributes)this.attributeStack.get(XMLConstants.TEL_OUTBOUND_ELEMENT_DEST);
			
			if (callOutboundAttrs != null)
			{
				if (callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR) != null) 
					{
					 if (callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR).trim().length() > 0) 
				        {			
					     record.put(XMLConstants.TEL_CALL_DESTINATION_ZONE, callOutboundAttrs.getValue(XMLConstants.TEL_OUTBOUND_DESTINATION_ATTR));
					    } 	
					}
			}				
			record.put(XMLConstants.TEL_SERVICE_SHORT, xcdAttrs.getValue(XMLConstants.TEL_SERVICE_SHORT));
			record.put(XMLConstants.TEL_TARIFF_ZONE_SHORT, xcdAttrs.getValue(XMLConstants.TEL_TARIFF_ZONE_SHORT));			
//          SMS + MIT			
		}
		record.put(XMLConstants.TEL_AMOUNT_RATED_ATTR, this.getCurrencyFormatter().formatNumber(_amount));
		record.put(XMLConstants.TEL_TARIFF_ATTR, _tariff);		
	
	}
	
	public boolean isTelephonyUnderAccumulation() {
		return this.attributeStack.containsKey(XMLConstants.USAGE_ELEMENT) &&
			   this.isTelephony;
	}

	private String determineXCDType(String _typeXCD, double _amtXCD, String _tariff, String _tariffZone, String _numberXCD) {
		String type = null;
		boolean discountFlag = 
			( XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(_typeXCD)             &&
			  ( XMLConstants.TEL_TARIFF_ZONE_RZ1_VALUE.equals(_tariffZone) ||
				XMLConstants.TEL_TARIFF_ZONE_RZ2_VALUE.equals(_tariffZone) ||
				XMLConstants.TEL_TARIFF_ZONE_RZ3_VALUE.equals(_tariffZone) ||
				XMLConstants.TEL_TARIFF_ZONE_RZ4_VALUE.equals(_tariffZone) ||
				XMLConstants.TEL_TARIFF_ZONE_RZ5_VALUE.equals(_tariffZone) ||
				XMLConstants.TEL_TARIFF_ZONE_RZ6_VALUE.equals(_tariffZone) )  &&
			  ( _amtXCD < 0 )
			);
		if (_numberXCD.startsWith(XMLConstants.TEL_SUBSECTION_Z3_PATTERN)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_Z3;
		} else if (XMLConstants.CONTRACT_TYPE_INDICATOR_I_VALUE.equals(_typeXCD)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_RECEIVED;
			if (discountFlag) {
				type = XMLConstants.TEL_CALLS_SUBSECTION_DISCOUNT;
			}
		} else if (XMLConstants.CONTRACT_TYPE_INDICATOR_C_VALUE.equals(_typeXCD)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_COLLECT;
		} else if (XMLConstants.TEL_CALL_TARIFF_LOCAL.equals(_tariff)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_LOCAL;
		} else if (XMLConstants.TEL_CALL_TARIFF_INURB.equals(_tariff)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_LONGDISTANCE;
		} else if (XMLConstants.TEL_CALL_TARIFF_INTERNACIONAL.equals(_tariff)) {
			type = XMLConstants.TEL_CALLS_SUBSECTION_INTERNATIONAL;
		}
		return type;
	}
}
