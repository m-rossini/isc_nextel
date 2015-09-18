package br.com.auster.nextel.xsl.extensions;

import junit.framework.TestCase;
import br.com.auster.nextel.xsl.extensions.PhoneNumber;

/**
 * @author framos
 */
public class PhoneNumberTest extends TestCase {

	protected PhoneNumber pn = new PhoneNumber();

	public void testRegularNumber() {
		assertEquals(pn.parse("1178149483"), PhoneNumber.REGULAR_NUMBER);
		assertEquals(pn.getAreaCode(), "11");
		assertEquals(pn.getFirstDigit(), "7");
	}
}
