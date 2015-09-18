package br.com.auster.nextel.sax;

public abstract class XMLConstants {

	public static final String CONTRACT_ELEMENT = "LIN2";
	public static final String SERVICE_ELEMENT = "LIN4";
	public static final String SERVICE_STATUS_ELEMENT = "LIN5";
	public static final String USAGE_ELEMENT = "XCD";

	// EHO: custcode variable:
	//public static final String CUSTCODE_ATTR = "SHORT_VALUE";
	public static final String SUMMSHEET_REFERENCE_PATH = "/TIMM/UNB/RFF/REFERENCE/";
	public static final String SUMMSHEET_REFERENCE_CODE_ATTR = "CODE";
	public static final String SUMMSHEET_REFERENCE_CODE_IT_ATTR = "IT";
	public static final String SUMMSHEET_REFERENCE_VALUE_ATTR = "VALUE1";
	public static final String CONTEXT_CUSTCODE = "CUSTCODE";	
	// invoice paths
	public static final String INVOICE_DATES_PATH = "/TIMM/UNB/DTM/DATE_TIME/";
	public static final String INVOICE_DATES_TEXT_PATH = INVOICE_DATES_PATH + "DATE/";
	// summsheet paths
	public static final String SUMMSHEET_DATES_PATH = "/TIMM/UNB/DTM/DATE_TIME/";
	public static final String SUMMSHEET_DATES_TEXT_PATH = INVOICE_DATES_PATH + "DATE/";
	// contract and usage paths
	public static final String CONTRACT_ROOTPATH = "/TIMM/UNB/LIN1/LIN2/";
	public static final String CONTRACT_PATH = CONTRACT_ROOTPATH + "IMD/ITEM/";
	public static final String USAGE_PATH = CONTRACT_ROOTPATH + "LIN3/XCD/";
	public static final String CONTRACT_SUBTOTAL_PATH1 = CONTRACT_ROOTPATH + "MOA/AMOUNT/";
	public static final String CONTRACT_SUBTOTAL_PATH2 = CONTRACT_ROOTPATH + "LIN3/LIN4/LIN5/LIN6/MOA/AMOUNT/";
	// minute package 
	public static final String MINUTEPACKAGE_ROOTPATH = CONTRACT_ROOTPATH + "LIN3/";
	public static final String MINUTEPACKAGE_CTPATH = CONTRACT_ROOTPATH + "LIN3/IMD/ITEM/";
	public static final String MINUTEPACKAGE_PATH = MINUTEPACKAGE_ROOTPATH + "LIN4/IMD/ITEM/";
	// service paths
	public static final String SERVICE_PATH = CONTRACT_ROOTPATH + "LIN3/LIN4/";
	public static final String SERVICE_INFO_PATH = SERVICE_PATH + "IMD/ITEM/";
	public static final String SERVICE_INFO_DETAIL_PATH = SERVICE_PATH + "IDENTIFICATION/ARTICLE/";
	public static final String SERVICE_VALUE_PATH = SERVICE_PATH + "MOA/AMOUNT/";
	public static final String SERVICE_QUANTITY_PATH = SERVICE_PATH + "QTY/DETAIL/";
	// service status paths
	public static final String SERVICE_STATUS_ROOTPATH = CONTRACT_ROOTPATH + "LIN3/LIN4/LIN5/"; 
	public static final String SERVICE_STATUS_PATH = SERVICE_STATUS_ROOTPATH + "IMD/ITEM/";
	public static final String SERVICE_STATUS_DATETIME_PATH = SERVICE_STATUS_ROOTPATH + "DTM/DATE_TIME/";
	public static final String SERVICE_STATUS_DATETIME_TEXT_PATH = SERVICE_STATUS_DATETIME_PATH + "DATE/";
	
	public static final String SERVICE_DISCOUNTS_ROOTPATH = SERVICE_STATUS_ROOTPATH + "LIN6/";
	public static final String SERVICE_DISCOUNT_PATH = SERVICE_DISCOUNTS_ROOTPATH + "IMD/ITEM/";
	public static final String SERVICE_DISCOUNT_VALUE_PATH = SERVICE_DISCOUNTS_ROOTPATH + "MOA/AMOUNT/";
	
	// other credits
	public static final String CONTRACT_OCC_PATH = CONTRACT_ROOTPATH + "IDENTIFICATION/ARTICLE/";
	public static final String CONTRACT_OCC_DATETIME_PATH = CONTRACT_ROOTPATH + "DTM/DATE_TIME/";
	public static final String CONTRACT_OCC_DATETIME_TEXT_PATH = CONTRACT_OCC_DATETIME_PATH + "DATE/";

	

	// ********************************************************
	//  SOURCE XML ELEMENTS & ATTRIBUTES
	// ********************************************************
	

	// Invoice info
	public static final String INVOICE_DATETIME_TYPE_ATTR = "QUALIFIER";
	public static final String INVOICE_DATETIME_TYPE_STARTDATE_VALUE = "3";
	public static final String CONTRACT_OCC_DATETIME_VALUE = "15";

	// summsheet dates
	public static final String SUMMSHEET_DATETIME_TYPE_ATTR = "QUALIFIER";
	public static final String SUMMSHEET_DATETIME_TYPE_167_VALUE = "167";
	public static final String SUMMSHEET_DATETIME_TYPE_168_VALUE = "168";
	
	
	// Contract-level attribute and possible values
	
	// contract CODE
	public static final String CONTRACT_CD_ATTR = "CODE";
	public static final String CONTRACT_CD_CO_VALUE = "CO";
	public static final String CONTRACT_CD_CT_VALUE = "CT";
	public static final String CONTRACT_CD_TM_VALUE = "TM";
	public static final String CONTRACT_CD_SN_VALUE = "SN";
	public static final String CONTRACT_CD_FE_VALUE = "FE";
	public static final String CONTRACT_CD_SMNUM_VALUE = "SMNUM";
	public static final String CONTRACT_CD_MRKT_VALUE = "MRKT";
	public static final String CONTRACT_MRKT_AMP_TYPE = "AMP";
	public static final String CONTRACT_CD_STATE_VALUE = "STATE";
	public static final String CONTRACT_CD_DISC_VALUE = "DISC";
	public static final String CONTRACT_CD_DIRNUM_VALUE = "DNNUM";
	// markteting types
	public static final String CONTRACT_MRKT_TYPE_AMP_VALUE = "AMP";
	// minute package information
	public static final String CONTRACT_MINUTEPACKAGE_NAME_ATTR = "SHORT_VALUE";
	// contract full value
	public static final String CONTRACT_FULLVALUE_ATTR = "FULL_VALUE";
	public static final String CONTRACT_SHORTVALUE_ATTR = "SHORT_VALUE";
	// contract SN and DN information
	public static final String CONTRACT_CODE_NUMBER_ATTR = "FULL_VALUE";
	public static final String CONTRACT_SN_NAME_ATTR = "SHORT_VALUE";
	public static final String CONTRACT_SN_FULLVALUE_ATTR = "FULL_VALUE";
	public static final String CONTRACT_DN_NUMBER_ATTR = "FULL_VALUE";
	// contract type indicator
	public static final String CONTRACT_TYPE_INDICATOR_ATTR = "TYPE_INDICATOR";
	public static final String CONTRACT_TYPE_INDICATOR_A_VALUE = "A";
	public static final String CONTRACT_TYPE_INDICATOR_C_VALUE = "C";
	public static final String CONTRACT_TYPE_INDICATOR_I_VALUE = "I";
	// contract subtotals
	public static final String CONTRACT_AMOUNT_TYPE_ATTR = "TYPE";
	public static final String CONTRACT_AMOUNT_VALUE_ATTR = "VALUE";
	public static final String CONTRACT_AMOUNT_TYPE_931_VALUE = "931";	
	public static final String CONTRACT_AMOUNT_TYPE_919_VALUE = "919";
	public static final String CONTRACT_AMOUNT_TYPE_203_VALUE = "203";
	// contract other credits
	public static final String CONTRACT_OCC_TMDES_ATTR = "TMDES";
	public static final String CONTRACT_OCC_TMDES_O_VALUE = "O";
	// services	
	public static final String SERVICE_SHORTVALUE_ATTR = "SHORT_VALUE";
	public static final String SERVICE_SHORTNAME_ATTR = "SERVICE_SHORT";
	public static final String SERVICE_CHARGE_TYPE_ATTR = "CHARGE_TYPE";
	public static final String SERVICE_CHARGE_TYPE_A_VALUE = "A";
	public static final String SERVICE_CHARGE_TYPE_S_VALUE = "S";
	public static final String SERVICE_CHARGE_TYPE_U_VALUE = "U";
	public static final String SERVICE_STATUS_ATTR = "FULL_VALUE";
	public static final String SERVICE_STATUS_ACTIVE_VALUE = "a";
	public static final String SERVICE_STATUS_SUSPENDED_VALUE = "s";
	public static final String SERVICE_STATUS_DEACTIVE_VALUE = "d";
	public static final String SERVICE_STATUS_MODIFIED_VALUE = "m";
	public static final String SERVICE_DATETIME_TYPE_ATTR = "QUALIFIER";
	public static final String SERVICE_DATETIME_FORMAT_ATTR = "FORMAT";
	public static final String SERVICE_DATETIME_TYPE_STARTDATE_VALUE = "901";
	public static final String SERVICE_DATETIME_TYPE_ENDATE_VALUE = "902";	
	// service MOA
	public static final String SERVICE_MOA_TYPE_ATTR = "TYPE";
	public static final String SERVICE_MOA_TYPE_203_VALUE = "203";
	public static final String SERVICE_MOA_VALUE_ATTR = "VALUE";
	// service quantity
	public static final String SERVICE_QUANTITY_TYPE_ATTR = "TYPE";
	public static final String SERVICE_QUANTITY_TYPE_110_VALUE = "110";
	public static final String SERVICE_QUANTITY_TYPE_111_VALUE = "111";
	public static final String SERVICE_QUANTITY_VOLUME_ATTR = "VOLUME";
  
  // MPRP rateplan
  public static final String MINUTEPACKAGE_NAME_MPRP_VALUE = "MPRP";
  public static final String MINUTEPACKAGE_USER_NAME = "Pac. de Minutos";

	// CIRCUIT DATA service 
	public static final String SERVICE_NAME_CIRDT_VALUE = "CIRDT";
	//
	// DOWNLOAD service elements/attributes
	//
	public static final String SERVICE_NAME_DOWNLOAD_VALUE = "DOWN";
	public static final String DOWNLOAD_MAINNUMBER_ATTR = "MAIN_NUMBER";
	public static final String DOWNLOAD_AMOUNT_ATTR = "RE_RATED_AMOUNT";
	// VAS sub element
	public static final String DOWNLOAD_VAS_ELEMENT = "VAS";
	public static final String DOWNLOAD_VAS_REMARK_ATTR = "REMARK";
	// CRTIME sub element
	public static final String DOWNLOAD_CRTIME_ELEMENT = "CR_TIME";
	public static final String DOWNLOAD_CRTIME_TIME_ATTR = "TIME";
	public static final String DOWNLOAD_CRTIME_DATE_ATTR = "DATE";
	
	//
	// DISPATCH service elements/attributes
	//
	// service name 
	public static final String DISPATCH_NAME_ATTR = "SERVICE_SHORT";
	// possible dispatch service names
	public static final String SERVICE_NAME_DISPP_VALUE = "DISPP";
	public static final String SERVICE_NAME_DISPG_VALUE = "DISPG";
	// amount
	public static final String DISPATCH_AMOUNT_ATTR = "RE_RATED_AMOUNT";
	// volumes
	public static final String DISPATCH_RATED_BEFORE_ATTR = "RATED_CALL_VOLUME_BEFORE";
	public static final String DISPATCH_RATED_AFTER_ATTR = "RATED_CALL_VOLUME_AFTER";
	public static final String DISPATH_ROUNDED_BEFORE_ATTR = "ROUNDED_CALL_VOLUME_BEFORE";
	public static final String DISPATCH_ROUNDED_AFTER_ATTR = "ROUNDED_CALL_VOLUME_AFTER";
	// free unit
	public static final String DISPATCH_FREEUNIT_SHORT_ATTR = "FREE_UNIT_SHORT";

	//
	// TORPEDO service elements/attributes
	//
	// possible torpedo service names
	public static final String SERVICE_NAME_TP_VALUE = "TP";
	public static final String SERVICE_NAME_MMST_VALUE = "MMST";
    //EHO: Mudança mms outras operadoras
	public static final String SERVICE_NAME_DRin_VALUE = "DRin";
    //
	public static final String SERVICE_NAME_MMSI_VALUE = "MMSI";
  // to control new SMS with origin/region association
  public static final String SERVICE_TARIFFZONE_SMS0_VALUE = "SMS0";
  public static final String SERVICE_TARIFFZONE_SMSSI_VALUE = "SMSSI";
  public static final String SERVICE_SMSSI_DESCRIPTION = "Serviços Interativos";
	// torpedo amount
	public static final String SERVICE_DATA_AMOUNT_ATTR = "RE_RATED_AMOUNT";
  
  //
  // LOCALIZADOR service elements/attributes (CALLS/ONLINE)
  //
  public static final String SERVICE_NAME_LOLGT_VALUE = "LOLGT";
	
	//
	// IDCD service elements/attributes
	//
	public static final String SERVICE_NAME_IDCD_VALUE = "CDIC";
	// amount
	public static final String IDCD_AMOUNT_ATTR = "RE_RATED_AMOUNT";
	// discount sub element
	public static final String IDCD_DISCOUNT_ELEMENT = "DISCOUNTING_RATED_AMOUNT";
	public static final String IDCD_DISCOUNT_IND_ATTR = "DISCOUNTING_INDICATOR";
	public static final String IDCD_DISCOUNT_IND_N_VALUE = "N";
	// time sub element
	public static final String IDCD_CRTIME_ELEMENT = "CR_TIME";
	public static final String IDCD_CRTIME_TIME_ATTR = "TIME";
	public static final String IDCD_CRTIME_DATE_ATTR = "DATE";
	public static final String IDCD_MAIN_NUMBER_ATTR = "MAIN_NUMBER";
	public static final String IDCD_TARIFF_TIMESHORT_ATTR = "TARIFF_TIME_SHORT";
	public static final String IDCD_ROUNDED_BEFORE_ATTR = "ROUNDED_CALL_VOLUME_BEFORE";
	
	
	//
	// TELEPHONY service elements/attributes
	//
	// possible telephony service names
	public static final String SERVICE_NAME_PPTEL_VALUE = "PPTEL";
	public static final String SERVICE_NAME_TELAL_VALUE = "TELAL";
	// service name
	public static final String TEL_MAINNUMBER_ATTR = "MAIN_NUMBER";
	// type and type indicator
	public static final String TEL_TYPE_ATTR = "TYPE";
	public static final String TEL_TYPE_O_VALUE = "O";
	// type indicator
	public static final String TEL_TYPE_INDICATOR_ATTR = "TYPE_INDICATOR";
	// tariff
	public static final String TEL_TARIFF_ATTR = "TARIFF_TIME_SHORT";
	public static final String TEL_TARIFF_L_VALUE = "L";
	public static final String TEL_TARIFF_N_VALUE = "N";
	public static final String TEL_TARIFF_I_VALUE = "I";
	public static final String TEL_TARIFF_ZONE_ATTR = "TARIFF_ZONE_SHORT";
	public static final String TEL_TARIFF_ZONE_RZ1_VALUE = "RZ1";
	public static final String TEL_TARIFF_ZONE_RZ2_VALUE = "RZ2";
	public static final String TEL_TARIFF_ZONE_RZ3_VALUE = "RZ3";
	public static final String TEL_TARIFF_ZONE_RZ4_VALUE = "RZ4";
	public static final String TEL_TARIFF_ZONE_RZ5_VALUE = "RZ5";
	public static final String TEL_TARIFF_ZONE_RZ6_VALUE = "RZ6";
	// rates 
	public static final String TEL_AMOUNT_RATED_ATTR = "RE_RATED_AMOUNT";
	public static final String TEL_AMOUNT_FLAT_ATTR = "RATED_FLAT_AMOUNT";
	// plmn indicator
	public static final String TEL_PLMN_INDICATOR_ATTR = "PLMN_INDICATOR";
	public static final String TEL_PLMN_INDICATOR_V_VALUE = "V";
	// volumes
	public static final String TEL_RATED_BEFORE_ATTR = "RATED_CALL_VOLUME_BEFORE";
	public static final String TEL_RATED_AFTER_ATTR = "RATED_CALL_VOLUME_AFTER";
	public static final String TEL_ROUNDED_BEFORE_ATTR = "ROUNDED_CALL_VOLUME_BEFORE";
	public static final String TEL_ROUNDED_AFTER_ATTR = "ROUNDED_CALL_VOLUME_AFTER";
	// free unit
	public static final String TEL_FREEUNIT_SHORT_ATTR = "FREE_UNIT_SHORT";
	// inbound and outbound sub elements
	public static final String TEL_INBOUND_ELEMENT = "INBOUND_CALL_INFO";
	public static final String TEL_INBOUND_CALLNUMBER_ATTR = "CALLING_NUMBER";
	public static final String TEL_INBOUND_PREFIX_ATTR = "CGI_CELL";
	public static final String TEL_OUTBOUND_ELEMENT = "OUTBOUND_CALL_INFO";
	public static final String TEL_OUTBOUND_CALLNUMBER_ATTR = "DIALED_DIGITS";
	public static final String TEL_OUTBOUND_PREFIX_ATTR = "CGI_CELL";
	// charge sub element
	public static final String TEL_CHARGEINFO_ELEMENT = "VPLMN_TAP_CHARGE_INFO";
	public static final String TEL_CHARGEINFO_AMOUNT_ATTR = "TAP_NET_RATE";
	public static final String TEL_CHARGEINFO_DESCRIPTION_ATTR = "SO_DESCRIPTION";
	// time sub element
	public static final String TEL_CRTIME_ELEMENT = "CR_TIME";
	public static final String TEL_CRTIME_DATE_ATTR = "DATE";
	public static final String TEL_CRTIME_TIME_ATTR = "TIME";
	// call origin & destination sub element
	public static final String TEL_CALLORIGIN_ELEMENT = "CALL_ORIGIN_INFO";
	public static final String TEL_CALLORIGIN_CITY_ATTR = "CITY";
	public static final String TEL_CALLDESTINATION_ELEMENT= "CALL_DESTINATION_INFO";
	public static final String TEL_CALLDESTINATION_COUNTRY_ATTR = "CITY_COUNTRY";
	//SMS Description + MIT
	public static final String TEL_OUTBOUND_ELEMENT_DEST = "OUTBOUND_CALL_INFO";
	public static final String TEL_OUTBOUND_DESTINATION_ATTR = "DESTINATION_ZONE";		
	public static final String TEL_SERVICE_SHORT = "SERVICE_SHORT";
	public static final String TEL_TARIFF_ZONE_SHORT = "TARIFF_ZONE_SHORT";
	public static final String TEL_CALL_DESTINATION_ZONE = "DESTINATION_ZONE";
	//SMS Description + MIT	
	
	
	
	
	
	// ********************************************************
	//  ACCUMULATOR NAMES & TOKENS
	// ********************************************************
	
	// download details list
	public static final String DOWNLOAD_DETAIL_LIST = "DOWNLOAD|DETAILS";
	
	// dispatch accumulator
	public static final String DISPATCH_ACC_SUMMARY = "DISPATCH_SUMMARY";
	
	// idcd details and time call
	public static final String IDCD_DETAIL_LIST = "IDCD_DETAILS";
	public static final String IDCD_TIMECALL_ACC_VALUE = "TIME_CALL";
	public static final String IDCD_TIMECALL_M_ACC_VALUE = "TIME_CALL_M";

	// telephony call details
	public static final String TEL_CALL_SOURCE = "SOURCE";
	public static final String TEL_CALL_DESTINATION = "DESTINATION";
	public static final String TEL_CALL_FROMNUMBER = "NUMBER";
	public static final String TEL_CALL_DURATION = "DURATION";
	public static final String TEL_CALL_DURATION_M = "DURATION_M";
	// telephony number types
	public static final String TEL_CALL_NUMBERTYPE = "NBRTYPE";
	public static final String TEL_CALL_NUMBERTYPE_MOBILE = "M";
	public static final String TEL_CALL_NUMBERTYPE_OTHER = "O";
	// telephony location 
	public static final String TEL_LOCATION_HOME_CALL = "H";
	public static final String TEL_LOCATION_ROAM_CALL = "R";
	// telephony charge types
	public static final String TEL_CALL_CHARGETYPE = "SN";
	public static final String TEL_CALL_CHARGETYPE_AIR = "0";
	public static final String TEL_CALL_CHARGETYPE_TOLL = "1";
	// telephony tariff names
	public static final String TEL_CALL_TARIFF_LOCAL = "LOCAL";
	public static final String TEL_CALL_TARIFF_INURB = "INURB";
	public static final String TEL_CALL_TARIFF_INTERNACIONAL = "INTNC";
	// telephony direction
	public static final String TEL_CALLS_DIRECTION_INCOMING = "IN";
	public static final String TEL_CALLS_DIRECTION_OUTGOING = "OUT";
	// telephony subsection
	public static final String TEL_SUBSECTION_Z3_PATTERN = "0300";
	public static final String TEL_CALLS_SUBSECTION_Z3 = "Z3";
	public static final String TEL_CALLS_SUBSECTION_RECEIVED = "RC";
	public static final String TEL_CALLS_SUBSECTION_DISCOUNT = "RD";
	public static final String TEL_CALLS_SUBSECTION_COLLECT = "CL";
	public static final String TEL_CALLS_SUBSECTION_LOCAL = "LO";
	public static final String TEL_CALLS_SUBSECTION_LONGDISTANCE = "LD";
	public static final String TEL_CALLS_SUBSECTION_INTERNATIONAL = "IT";
	// Z3 and NOZ3 accumulators
	public static final String TEL_Z3TYPE_ACC_SUMMARY = "Z3";
	public static final String TEL_NOZ3TYPE_ACC_SUMMARY = "NOZ3";

	
	// ********************************************************
	//  DESTINATION XML ELEMENTS & ATTRIBUTES
	// ********************************************************
	
	public static final String XML_CONTRACT_ELEMENT = "CONTRACT";
	public static final String XML_CONTRACT_ID_ATTR = "ID";
	public static final String XML_CONTRACT_IMEI_ATTR = "IMEI";
	public static final String XML_CONTRACT_FID_ATTR = "FID";
	public static final String XML_CONTRACT_MID_ATTR = "MID";
	public static final String XML_CONTRACT_U_ATTR = "U";
	public static final String XML_CONTRACT_TP_ATTR = "TP";
	public static final String XML_CONTRACT_PP_ATTR = "PP";
	public static final String XML_CONTRACT_N_ATTR = "N";
	public static final String XML_CONTRACT_T_ATTR = "T";
	public static final String XML_CONTRACT_M_ATTR = "M";
	public static final String XML_CONTRACT_A_ATTR = "A";
	public static final String XML_CONTRACT_O_ATTR = "O";
	public static final String XML_CONTRACT_CALLS_ELEMENT = "CALLS";
	public static final String XML_CONTRACT_SERVICES_ELEMENT = "SERVICES";
	// download schema
	public static final String XML_DOWNLOAD_ELEMENT = "DOWNLOADS";
	public static final String XML_DOWNLOAD_DETAIL_ELEMENT = "DL";
	public static final String XML_DOWNLOAD_DETAIL_MN_ATTR = "MN";
	public static final String XML_DOWNLOAD_DETAIL_VU_ATTR = "VU";
	public static final String XML_DOWNLOAD_DETAIL_DS_ATTR = "DS";
	public static final String XML_DOWNLOAD_DETAIL_T_ATTR = "T";
	public static final String XML_DOWNLOAD_DETAIL_DT_ATTR = "DT";
	public static final String XML_DOWNLOAD_DETAIL_TM_ATTR = "TM";
	// services schema
	public static final String XML_SERVICE_DETAIL_ELEMENT = "SVC";
	public static final String XML_SERVICE_TP_ATTR = "TP";
	public static final String XML_SERVICE_ID_ATTR = "ID";
	public static final String XML_SERVICE_V_ATTR = "V";	
	// online schema
	public static final String XML_ONLINE_ELEMENT = "ONLINE";
	public static final String XML_ONLINE_TP_ATTR = "TP";
	public static final String XML_ONLINE_ID_ATTR = "ID";
	public static final String XML_ONLINE_DS_ATTR = "DS";
	public static final String XML_ONLINE_TR_ATTR = "TR";
	public static final String XML_ONLINE_Q_ATTR = "Q";
	public static final String XML_ONLINE_ST_ATTR = "ST";
	public static final String XML_ONLINE_S_ATTR = "S";
	public static final String XML_ONLINE_E_ATTR = "E";
	public static final String XML_ONLINE_ND_ATTR = "ND";
	public static final String XML_ONLINE_V_ATTR = "V";	
	// torpedo schema
	public static final String XML_TORPEDO_ELEMENT = "TORPEDO";
	// torpedo, online and download attributes
	public static final String XML_SERVICE_DATA_TP_ATTR = "TP";
	public static final String XML_SERVICE_DATA_ID_ATTR = "ID";
    public static final String XML_SERVICE_DATA_TZ_ATTR = "TZ"; // added for SMSnn
	public static final String XML_SERVICE_DATA_DS_ATTR = "DS";
	public static final String XML_SERVICE_DATA_Q_ATTR = "Q";
	public static final String XML_SERVICE_DATA_ST_ATTR = "ST";
	public static final String XML_SERVICE_DATA_U_ATTR = "U";
	public static final String XML_SERVICE_DATA_V_ATTR = "V";
	// data services total schema
	public static final String XML_DATA_TOTAL_ELEMENT = "TOTAL";
	public static final String XML_DATA_AMOUNT_ATTR = "CDATA";
	// charges
	public static final String XML_SERVICE_CHARGE_ELEMENT = "CHARGES";
	public static final String XML_SERVICE_CHARGE_DETAIL_ELEMENT = "CHG";
	// charge discounts
	public static final String XML_SERVICE_CHARGE_DISCOUNT_ELEMENT = "DCT";
	public static final String XML_CHARGE_DISCOUNT_DS_ATTR = "DS";
	public static final String XML_CHARGE_DISCOUNT_V_ATTR = "V";
	// dispatch schema
	public static final String XML_DISPATCH_ELEMENT = "DISPATCH";
	public static final String XML_DISPATCH_DR_ATTR = "DR";
	public static final String XML_DISPATCH_DR_M_ATTR = "DR_M";
	public static final String XML_DISPATCH_F_ATTR = "F";
	public static final String XML_DISPATCH_F_M_ATTR = "F_M";
	public static final String XML_DISPATCH_CH_ATTR = "CH";
	public static final String XML_DISPATCH_CH_M_ATTR = "CH_M";
	public static final String XML_DISPATCH_V_ATTR = "V";

	public static final String XML_DISPATCH_DETAIL_ELEMENT = "DISPP";	
	public static final String XML_DISPATCH_DETAIL_DS_ATTR = "DS";
	public static final String XML_DISPATCH_DETAIL_DR_ATTR = "DR";
	public static final String XML_DISPATCH_DETAIL_DR_M_ATTR = "DR_M";
	public static final String XML_DISPATCH_DETAIL_F_ATTR = "F";
	public static final String XML_DISPATCH_DETAIL_F_M_ATTR = "F_M";
	public static final String XML_DISPATCH_DETAIL_CH_ATTR = "CH";
	public static final String XML_DISPATCH_DETAIL_CH_M_ATTR = "CH_M";
	public static final String XML_DISPATCH_DETAIL_V_ATTR = "V";
	// CDIC schema
	public static final String XML_IDCD_ELEMENT = "IDCD";
	public static final String XML_IDCD_V_ATTR = "V";
	public static final String XML_IDCD_DR_ATTR = "DR";
	public static final String XML_IDCD_DR_M_ATTR = "DR_M";
	// telephony schema
	public static final String XML_TEL_HOME_ELEMENT = "HOME";
	public static final String XML_TEL_ROAM_ELEMENT = "ROAMING";
	public static final String XML_TEL_OUTGOING_ELEMENT = "OUTGOING";
	public static final String XML_TEL_INCOMING_ELEMENT = "INCOMING";
	public static final String XML_TEL_LD_ELEMENT = "LONG_DISTANCE";
	public static final String XML_TEL_LO_ELEMENT = "LOCAL";
	public static final String XML_TEL_INT_ELEMENT = "INTERNATIONAL";
	public static final String XML_TEL_Z300_ELEMENT = "Z300";
	public static final String XML_TEL_NOZ300_ELEMENT = "NO_Z300_SUMMARY";
	public static final String XML_TEL_RECEIVED_ELEMENT = "RECEIVED";
	public static final String XML_TEL_COLLECT_ELEMENT = "COLLECT";
	public static final String XML_TEL_DISC_ELEMENT = "DISCOUNTS";
	
	public static final String XML_TEL_DNF_ATTR = "DNF";
	public static final String XML_TEL_DNF_M_ATTR = "DNF_M";
	public static final String XML_TEL_F_ATTR = "F";
	public static final String XML_TEL_F_M_ATTR = "F_M";
	public static final String XML_TEL_CH_ATTR = "CH";
	public static final String XML_TEL_CH_M_ATTR = "CH_M";
	public static final String XML_TEL_V_ATTR = "V";
	
	public static final String XML_TEL_DA_ATTR = "DA";
	public static final String XML_TEL_DA_M_ATTR = "DA_M";
	public static final String XML_TEL_FA_ATTR = "FA";
	public static final String XML_TEL_FA_M_ATTR = "FA_M";
	public static final String XML_TEL_CHA_ATTR = "CHA";
	public static final String XML_TEL_CHA_M_ATTR = "CHA_M";
	public static final String XML_TEL_VA_ATTR = "VA";
	public static final String XML_TEL_CHT_ATTR = "CHT";
	public static final String XML_TEL_CHT_M_ATTR = "CHT_M";
	public static final String XML_TEL_VT_ATTR = "VT";
	public static final String XML_TEL_DR_ATTR = "DR";
	public static final String XML_TEL_DR_M_ATTR = "DR_M";

	public static final String XML_TEL_DETAIL = "CALL";
	public static final String XML_TEL_DETAIL_MN_ATTR = "MN";
	public static final String XML_TEL_DETAIL_SN_ATTR = "SN";
	public static final String XML_TEL_DETAIL_CL_ATTR = "CL";
	public static final String XML_TEL_DETAIL_DT_ATTR = "DT";
	public static final String XML_TEL_DETAIL_TM_ATTR = "TM";
	public static final String XML_TEL_DETAIL_SC_ATTR = "SC";
	public static final String XML_TEL_DETAIL_DN_ATTR = "DN";
	public static final String XML_TEL_DETAIL_N_ATTR  = "N";
	public static final String XML_TEL_DETAIL_DR_ATTR = "DR";
	public static final String XML_TEL_DETAIL_DR_M_ATTR = "DR_M";
	public static final String XML_TEL_DETAIL_V_ATTR  = "V";
	public static final String XML_TEL_DETAIL_TP_ATTR = "TP";	
    //SMS Description + MIT
	public static final String XML_TEL_DETAIL_SV_ATTR = "SV";
	public static final String XML_TEL_DETAIL_TZ_ATTR = "TZ";	
	public static final String XML_TEL_DETAIL_ZD_ATTR = "ZD";
	public static final String XML_TEL_DETAIL_DS_ATTR = "DS";	
    //SMS Description + MIT	
	public static final String XML_OCC_DETAIL = "OCC";
	public static final String XML_OCC_DETAIL_DS_ATTR = "DS";
	public static final String XML_OCC_DETAIL_DT_ATTR = "DT";
	public static final String XML_OCC_DETAIL_V_ATTR = "V";
	
	
}
