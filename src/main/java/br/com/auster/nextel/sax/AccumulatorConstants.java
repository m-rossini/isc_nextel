package br.com.auster.nextel.sax;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import br.com.auster.dware.sax.MultiHandlerContext;

public abstract class AccumulatorConstants {

	// index for service summary
	public static final int CONTRACT_ACCUM_SIZE = 4;
	public static final int CONTRACT_SUBT_ACCUM = 0;
	public static final int CONTRACT_ADD_ACCUM = 1;
	public static final int CONTRACT_ONLINE_ACCUM = 2;
	public static final int CONTRACT_MONTLHYFEE_ACCUM = 3;
	// index for service summary
	public static final int SERVICE_ACCUM_SIZE = 1;
	public static final int SERVICE_AMNT_ACCUM = 0;
	// index for service data (download, online and torpedos)
	public static final int SERVICE_DATA_ACCUM_SIZE = 2;
	public static final int SERVICE_DATA_QTTY_ACCUM = 0;
	public static final int SERVICE_DATA_AMNT_ACCUM = 1;
	// index for dispatch
	public static final int DISPATCH_ACCUM_SIZE = 5;
	public static final int DISPATH_SUBFRANQUIA_ACCUM = 0;
	public static final int DISPATH_SUBTOTAL_ACCUM = 1;
	public static final int DISPATH_SUBAPAGAR_ACCUM = 2;
	public static final int DISPATH_SUBVALOR_ACCUM = 3;
	public static final int DISPATH_SUBDIRETA_ACCUM = 4;
	
	public static final int DISPATCH_DETAIL_ACCUM_SIZE = 4;
	public static final int DISPATH_TOTAL_ACCUM = 0;
	public static final int DISPATH_FRANQUIA_ACCUM = 1;
	public static final int DISPATH_APAGAR_ACCUM = 2;
	public static final int DISPATH_AMNT_ACCUM = 3;
	// index for CDIC
	public static final int IDCD_ACCUM_SIZE = 2;
	public static final int IDCD_AMNT_ACCUM = 0;
	public static final int IDCD_TIME_ACCUM = 1;
	// index for telephony 
	public static final int TELEPHONY_LOCATION_SIZE = 4;
	public static final int TELEPHONY_TOT_ACCUM = 0;
	public static final int TELEPHONY_FRA_ACCUM = 1;
	public static final int TELEPHONY_APA_ACCUM = 2;
	public static final int TELEPHONY_AMT_ACCUM = 3;
	
	public static final int TELEPHONY_SUBSECTION_ACCUM_SIZE = 11;
	public static final int TELEPHONY_SUMM_NOFREE_ACCUM = 0;
	public static final int TELEPHONY_SUMM_TOTAIR_ACCUM = 1;
	public static final int TELEPHONY_SUMM_FRAAIR_ACCUM = 2;
	public static final int TELEPHONY_SUMM_APAAIR_ACCUM = 3;
	public static final int TELEPHONY_SUMM_VALAIR_ACCUM = 4;
	public static final int TELEPHONY_SUMM_APATOT_ACCUM = 5;
	public static final int TELEPHONY_SUMM_VALTOT_ACCUM = 6;
	public static final int TELEPHONY_SUMM_TOT_ACCUM    = 7;
	public static final int TELEPHONY_SUMM_FRA_ACCUM    = 8;
	public static final int TELEPHONY_SUMM_APA_ACCUM    = 9;
	public static final int TELEPHONY_SUMM_VAL_ACCUM    = 10;
	
	

	
	/**
   * Searches in the <code>_source</code> map for a List instance stored under
   * the <code>_key</code> key. If no such instance is found, a new one is
   * created and automatically added to the source Map under the key specified.
   */
	public static final List getOrBuildList(String _key, MultiHandlerContext _source) {
		List list = (List)_source.getAttribute(_key);
		if (list == null) { 
			list = new LinkedList();
			_source.setAttribute(_key, list);
		}
		return list;
	}
  
  /**
   * Searches in the <code>_source</code> map for a List instance stored under
   * the <code>_key</code> key. If no such instance is found, a new one is
   * created and automatically added to the source Map under the key specified.
   */
  public static final List getOrBuildList(String _key, Map _source) {
    List list = (List)_source.get(_key);
    if (list == null) { 
      list = new LinkedList();
      _source.put(_key, list);
    }
    return list;
  }
  
  /**
   * Searches in the <code>_source</code> map for a Map instance stored under
   * the <code>_key</code> key. If no such instance is found, a new one is
   * created and automatically added to the source Map under the key specified.
   */
  public static final Map getOrBuildMap(String _key, MultiHandlerContext _source) {
    Map map = (Map)_source.getAttribute(_key);
    if (map == null) { 
      map = new HashMap();
      _source.setAttribute(_key, map);
    }
    return map;
  }
  
  /**
   * Searches in the <code>_source</code> map for a Map instance stored under
   * the <code>_key</code> key. If no such instance is found, a new one is
   * created and automatically added to the source Map under the key specified.
   */
  public static final Map getOrBuildMap(String _key, Map _source) {
    Map map = (Map)_source.get(_key);
    if (map == null) { 
      map = new HashMap();
      _source.put(_key, map);
    }
    return map;
  }

	/**
   * Searches in the <code>_source</code> map for a array of doubles stored
   * under the <code>_key</code> key. If no such array is found, a new one is
   * created and automatically added to the source Map under the key specified.
   */
	public static final double[] getOrBuildDoubleArray(String _key, 
                                                     MultiHandlerContext _source, 
                                                     int _len) {
		double[] dblArray = (double[])_source.getAttribute(_key);
		if (dblArray == null) { 
			dblArray = new double[_len];
			_source.setAttribute(_key, dblArray);
		}
		return dblArray;
	}	
}
