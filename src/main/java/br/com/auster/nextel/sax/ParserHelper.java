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
 * Created on 08/06/2006
 */
package br.com.auster.nextel.sax;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.util.Locale;

import org.apache.log4j.Logger;

/**
 * @author framos
 * @version $Id: ParserHelper.java 2 2006-07-24 22:57:04Z rbarone $
 */
public final class ParserHelper {

	
	
	private static final Logger log = Logger.getLogger(ParserHelper.class);
	
	
	private DecimalFormat formatterIn;
	private DecimalFormat formatterOut;
	
	
	
	ParserHelper(String _formatter) {
		
		this.formatterIn = new DecimalFormat(_formatter, new DecimalFormatSymbols(Locale.US));
		this.formatterOut = new DecimalFormat(_formatter, new DecimalFormatSymbols(new Locale("pt", "BR")));
	}
	
	
	public Number parseNumber(String _numberAsString) {
		try {
			return this.formatterIn.parse(_numberAsString);
		} catch (ParseException pe) {
			log.warn("Could not parse " + _numberAsString, pe);
		} catch (NullPointerException npe) {
			return null;
		}
		return null;
	}

	
	public String formatNumber(long _numberAsLong) {
		return this.formatterOut.format(_numberAsLong);
	}

	public String formatNumber(double _numberAsDouble) {
		return this.formatterOut.format(_numberAsDouble);
	}	
}
