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
 * Created on Jun 13, 2006
 */
package br.com.auster.nextel.xsl.extensions;

import java.util.Locale;

import junit.framework.TestCase;

import br.com.auster.nextel.xsl.extensions.LocalizedNumber;

/**
 * @author framos
 * @version $Id: LocalizedNumberTest_enUS.java 10 2006-08-07 23:07:31Z rbarone $
 */
public class LocalizedNumberTest_enUS extends TestCase {

	
	protected void setUp() throws Exception {
		Locale.setDefault(new Locale("en", "US"));
	}
	
	
	public void testLocalizer_DefaultLocale_ptBR_DefaultCall() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10.200,72");
		assertEquals(10.2d, nr.doubleValue(), 0.01d);
		assertEquals(10, nr.longValue());
	}

	public void testLocalizer_DefaultLocale_ptBR_CountryBR() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10.200,72", "pt");
		assertEquals(10200.72d, nr.doubleValue(), 0.01d);
		assertEquals(10200, nr.longValue());
	}

	public void testLocalizer_DefaultLocale_ptBR_FullParams() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10.200,72", "pt", "BR");
		assertEquals(10200.72d, nr.doubleValue(), 0.01d);
		assertEquals(10200, nr.longValue());
	}

	public void testLocalizer_DefaultLocale_ptBR_EnglishFormat() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10,200.72");
		assertEquals(10200.72d, nr.doubleValue(), 0.01d);
		assertEquals(10200, nr.longValue());
	}

	public void testLocalizer_DefaultLocale_ptBR_CountryEN() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10,200.72", "en");
		assertEquals(10200.72d, nr.doubleValue(), 0.01d);
		assertEquals(10200, nr.longValue());
	}

	public void testLocalizer_DefaultLocale_ptBR_FullEnglish() {
		LocalizedNumber localizer = new LocalizedNumber();
		Number nr = localizer.localizeNumber(null, "10,200.72", "en", "US");
		assertEquals(10200.72d, nr.doubleValue(), 0.01d);
		assertEquals(10200, nr.longValue());
	}	
}
