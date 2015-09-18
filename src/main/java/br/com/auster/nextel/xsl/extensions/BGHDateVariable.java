package br.com.auster.nextel.xsl.extensions;

import java.util.Calendar;
import java.util.GregorianCalendar;


/**
 * 
 * @author Ricardo Barone
 */
public class BGHDateVariable extends DateVariable {

  // ##############################
  // FUNCTIONS
  // ##############################
  public String getInvoiceEndDate (String date) throws java.text.ParseException {
    GregorianCalendar beginDate = new GregorianCalendar();
    GregorianCalendar endDate = new GregorianCalendar();
    if (date == null || date.length() == 0) {
      throw new IllegalArgumentException("[" + this.getClass().getName() + "/getInvoiceEndDate] " +
                                         "'date' argument cannot be empty.");
    } else if ( !date.equals("now") ) {
      beginDate.setTime( this.defaultFormatter.parse(date) );
    }
    endDate.setTime( beginDate.getTime() );
    endDate.add(GregorianCalendar.MONTH, 1);
    if (Calendar.DAY_OF_MONTH == GregorianCalendar.DAY_OF_MONTH) {
      endDate.add(GregorianCalendar.DATE, -1);
    }
    return this.defaultFormatter.format( endDate.getTime() );
  }
 
}
