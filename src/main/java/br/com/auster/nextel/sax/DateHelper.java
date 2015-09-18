/**
 * 
 */
package br.com.auster.nextel.sax;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * @author framos
 *
 */
public abstract class DateHelper {

	
	private static final Logger log = Logger.getLogger(DateHelper.class);
	
	
	
	private static final String decodeDate(String _date) {
		switch (_date.length()) {
			// format is yyMM
			case 2: return "20" + _date + "01";
			// format is yyMMdd
			case 4: return "20" + _date;
		}
		// case 6 or otherwise
		return _date;
	}
	
	
	public static final String minDate(String _date1, String _date2) {
		if (_date1 == null) { return _date2; } 
		if (_date2 == null) { return _date1; } 
		String d1 = decodeDate(_date1);
		String d2 = decodeDate(_date2);
		if (d1.compareTo(d2) <= 0) {
			return _date1;
		}
		return _date2;
	}
	
	public static final String maxDate(String _date1, String _date2) {
		if (_date1 == null) { return _date2; } 
		if (_date2 == null) { return _date1; } 
		String d1 = decodeDate(_date1);
		String d2 = decodeDate(_date2);
		if (d1.compareTo(d2) > 0) {
			return _date1;
		}
		return _date2;
	}
	
	public static final boolean sameDate(String _date1, String _date2) {
		// if both are NULL
		if ((_date1 == null) && (_date2 == null)) { return true; }
		// if only one is NULL
		if ((_date1 == null) || (_date2 == null)) { return false; }
		String d1 = decodeDate(_date1);
		String d2 = decodeDate(_date2);
		return d1.equals(d2);
	}
	
	public static final String rolloverMonths(String _date, int _months) {
		if (_date == null) { return null; }
		try {
			SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
			Date dt = f.parse(decodeDate(_date));
			Calendar c = Calendar.getInstance();
			c.setTime(dt);
			c.add(Calendar.MONTH, _months);
			c.add(Calendar.DATE, -1);
			return f.format(c.getTime());
		} catch (ParseException pe) {
			log.warn("could not parse date " + _date);
		}
		return null;
	}

	public static final String rolloverDays(String _date, int _days) {
		if (_date == null) { return null; }
		try {
			SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
			Date dt = f.parse(decodeDate(_date));
			Calendar c = Calendar.getInstance();
			c.setTime(dt);
			c.add(Calendar.DATE, _days);
			return f.format(c.getTime());
		} catch (ParseException pe) {
			log.warn("could not parse date " + _date);
		}
		return null;
	}
	
	public static final int getInterval(String _from, String _to) {
		if ((_from == null) || (_to == null)) { return 0; }
		try {
			SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
			Date dt1 = f.parse(decodeDate(_from));
			Date dt2 = f.parse(decodeDate(_to));
			return (int)((dt2.getTime() - dt1.getTime())/(24*3600*1000) + 1);
		} catch (ParseException pe) {
			log.warn("could not parse one of the following dates: '" + _from + "' or '" + _to + "'");
		}
		return 0;
	}
	
	public static final String toDateFormat(String _date) {
		if ((_date == null) || (_date.length() < 6)) {
			return _date;
		}
		return _date.substring(_date.length()-2) + "/" +
		       _date.substring(_date.length()-4, _date.length()-2) + "/" +
		       _date.substring(_date.length()-6, _date.length()-4);
	}

	public static final String toDateNoYearFormat(String _date) {
		if ((_date == null) || (_date.length() < 4)) {
			return _date;
		}
		return _date.substring(_date.length()-2) + "/" +
		       _date.substring(_date.length()-4, _date.length()-2);
	}
	
	public static final String toTimeFormat(String _date) {
		if ((_date == null) || (_date.length() < 6)) {
			return _date;
		}
		return _date.substring(0,2) + "H" +
	           _date.substring(2,4) + "M" +
	           _date.substring(4,6);
	}
		
}

