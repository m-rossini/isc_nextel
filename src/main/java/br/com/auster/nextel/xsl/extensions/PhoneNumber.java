package br.com.auster.nextel.xsl.extensions;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.apache.log4j.Logger;

/**
 * This extension is used to fetch some usefull info from a phone number.
 * 
 * @author Ricardo Barone
 */
public class PhoneNumber {
	

	  protected static final int REGULAR_NUMBER = 1;
	  protected static final int SPECIAL_NUMBER = 2;
	  protected static final int UNKNOWN_NUMBER = 3;
	  protected static final int STRING_NUMBER = 4;  


	private static final Logger log = Logger.getLogger(PhoneNumber.class);
	
	
	protected static final HashMap patterns = new HashMap();

	
	protected int type = UNKNOWN_NUMBER;

	protected String[] number = new String[0];

	protected String originalNumber;

	
	public PhoneNumber() {}

	/**
	 * Parses a given number with several regular expressions for a match and
	 * overwrites all instance variables with the result.
	 * 
	 * @param number
	 *            the phone number to be processed
	 * @return phone-number type
	 *         (REGULAR_NUMBER=1,SPECIAL_NUMBER=2,UNKNOWN_NUMBER=3)
	 */
	public int parse(String number) {

		if (number == null) { number = ""; }
		log.debug("parsing phoneNumber='" + number + "'");
		
	    Matcher regularNumber = getPattern("^0?([1-9]{2})(\\d+?)(\\d{4})$").matcher(number);
	    Matcher specialNumber = getPattern("^(0\\d00)(\\d\\d)(\\d\\d)(\\d+)$").matcher(number);
	    Matcher stringNumber = getPattern("^0?([1-9]{2})(\\d{4})(\\w+)$").matcher(number);    
	    
	    if ( regularNumber.matches() ) {
	      this.type = REGULAR_NUMBER;
	      parseGroups(regularNumber);
	    } else if ( specialNumber.matches() ) {
	      this.type = SPECIAL_NUMBER;
	      parseGroups(specialNumber);
	    } else if ( stringNumber.matches() ) {
	        this.type = STRING_NUMBER;
	        parseGroups(stringNumber);      
	    } else {
	      this.type = UNKNOWN_NUMBER;
	      this.number = new String[1];
	      this.number[0] = number;
	    }

		this.originalNumber = number;
		return this.type;

	}

	public String getOriginalPhoneNumber() {
		return this.originalNumber;
	}

	public String getAreaCode() {
		switch (this.type) {
		case REGULAR_NUMBER:
			return this.number[0];
		case SPECIAL_NUMBER:
		case UNKNOWN_NUMBER:
		default:
			return "";
		}
	}

	public String getFirstDigit() {
		switch (this.type) {
		case REGULAR_NUMBER:
			return this.number[1].substring(0, 1);
		case SPECIAL_NUMBER:
		case UNKNOWN_NUMBER:
		default:
			return "";
		}
	}

	public String getHiphenized() {
		String result = "";
		for (int i = 0; i < this.number.length; i++) {
			result += (i == 0 ? "" : "-") + this.number[i];
		}
		return result;
	}

	/**
	 * Parses a given matcher for groups and fills the instance variable
	 * <code>number</code> with it.
	 * 
	 * @param matcher
	 *            the already executed matcher that holds all groups
	 */
	protected void parseGroups(Matcher matcher) {
		this.number = new String[matcher.groupCount()];
		for (int i = 0; i < this.number.length; i++) {
			this.number[i] = matcher.group(i + 1);
		}
	}

	/**
	 * Gets the pattern object for a given regex. It will try to return a
	 * existent instance of a pattern for this regex.
	 * 
	 * @param regex
	 *            the regular expression.
	 * @return the pattern object for the given regex.
	 */
	protected static Pattern getPattern(String regex)
			throws PatternSyntaxException {
		// Gets the pattern from a hash table mapped by the regex, if it already
		// exists.
		// Otherwise creates it.
		Pattern pattern = (Pattern) patterns.get(regex);
		if (pattern == null) {
			synchronized (patterns) {
				if (patterns.containsKey(regex)) {
					pattern = (Pattern) patterns.get(regex);
				} else {
					pattern = Pattern.compile(regex);
					patterns.put(regex, pattern);
				}
			}
		}

		return pattern;
	}
}
