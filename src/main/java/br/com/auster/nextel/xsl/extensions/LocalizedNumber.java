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

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.util.Locale;

import org.apache.xalan.extensions.XSLProcessorContext;

/**
 * @author framos
 * @version $Id: LocalizedNumber.java 10 2006-08-07 23:07:31Z rbarone $
 */
public class LocalizedNumber {


	private ThreadLocal formatter;
	
	
	public LocalizedNumber() {
		formatter = new ThreadLocal();
		formatter.set(new DecimalFormat());
	}
	
	
	public Number localizeNumber(XSLProcessorContext _context, String _value) {
		((DecimalFormat)formatter.get()).setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.getDefault()));
		return this.localizeNumber(_value);
	}
	
	public Number localizeNumber(XSLProcessorContext _context, String _value, String _language) {
		Locale locale = new Locale(_language);
		((DecimalFormat)formatter.get()).setDecimalFormatSymbols(new DecimalFormatSymbols(locale));
		return this.localizeNumber(_value);
	}
	
	public Number localizeNumber(XSLProcessorContext _context, String _value, String _language, String _country) {
		Locale locale = new Locale(_language, _country);
		((DecimalFormat)formatter.get()).setDecimalFormatSymbols(new DecimalFormatSymbols(locale));
		return this.localizeNumber(_value);
	}
	
	public Number localizeNumber(String _value) {
		try {
			return ((DecimalFormat)formatter.get()).parse(_value);
		} catch (ParseException pe) {
			throw new IllegalArgumentException("could not parse value " + _value + " as long ", pe);
		}
	}
	
}
