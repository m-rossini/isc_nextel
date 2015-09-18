package br.com.auster.nextel.xsl.extensions;

import java.util.Date;
import java.util.HashMap;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;

/**
 * @author  cddantas
 */
public class FebrabanVariable extends Variable {

	protected HashMap variables = new HashMap();
	protected long counter = 1;
	
	// ##############################
	// ELEMENTS
	// ##############################
	public void reset(XSLProcessorContext context, Element elem) {
		this.variables.clear();
	}

	// ##############################
	// FUNCTIONS
	// ##############################
	public String getValue(String name) {
		if (!this.variables.containsKey(name)) {
			throw new IllegalArgumentException(
				"["
					+ this.getClass().getName()
					+ "/getValue] "
					+ "Variable '"
					+ name
					+ "' does not exist.");
		}
		return (String) this.variables.get(name);
	}
 
	/**
	 * Completa com espaÁos ‡ direita.
	 * @param str - String a ser avaliada
	 * @param len - int com o tamanho do espaÁo a ser preenchido pela (str + espaÁos)
	 * @return String com o formato pedido com preenchimentos em espaÁos.
	 */
	public  String rightPad(String str, int len) {
		if (str.length() > len)
			return str.substring(0, len);

		String s = StringUtils.rightPad(str, len);

		return s;
	}

	/**
	 * Completa com espaÁos ‡ esquerda.
	 * @param str - String a ser avaliada
	 * @param len - int com o tamanho do espaÁo a ser preenchido pela (espaÁos + str)
	 * @param param - caractere de preenchimento
	 * @return String com o formato pedido com preenchimentos em espaÁos.
	 */
	public  String leftPad(String str, int len, String param) {
		return StringUtils.leftPad(str, len, param);
	}

	/**
	 * Troca os caracteres.
	 * @param str - String a ser avaliada
	 * @param param - caracteres para troca 
	 * @param troca - caracteres de troca.
	 * @return String com o formato pedido com trocas.
	 */
	public String replaceChars(String str, String param, String troca) {
		// geralmente param = "-,."
		// troca = null;
		return StringUtils.replaceChars(str, param, troca);
	}

	/**
	 * Preenche com o caractere pedido.
	 * @param str - String a ser usada para preenchimento
	 * @param len - quantidade
	 * @return String com o formato pedido com preenchimentos.
	 */
	public String repeatChars(String str, int len) {
		// geralmente str = "0"
		return StringUtils.repeat(str, len);
	}
	/**
	 * Converte a data em String para formato AAAAMMDD
	 * @param data data no formato dd/mm/aaaa ou dd/mm/aa 
	 * @return String - data em formato AAAAMMDD
	 */
	public String convertDateToAAAAMMDD(String data) {
		if ( data.length() == 10 )
			return data.substring(6,10)+data.substring(3,5)+data.substring(0,2);
		else // data com ano de 2 digitos
			return "20"+data.substring(6,8)+data.substring(3,5)+data.substring(0,2);
	}

	/**
	 * Retira os acentos da String passada.
	 * @param data String a ser convertida
	 * @return String - mesma String de entrada, sÛ que sem os acentos.
	 */
	public String convertAccents(String data) {
		String in  = "«√¬¡¿» …ÃÕ“”’‘÷‹⁄Ÿ€";
		String out = "CAAAAEEEIIOOOOOUUUU";
		data = data.toUpperCase();
		for (int i = 0; i < in.length(); i++)
			data = data.replace(in.charAt(i),out.charAt(i));

		return data;
	}
	/**
	 * Retorna a data de hoje em formato yyyymmdd
	 * @return String - da data de hoje como yyyymmdd 
	 */
	public String americanDate(){
		return DateFormatUtils.format(new Date(),"yyyyMMdd");
	}

	// ##############################
	// PROTECTED METHODS
	// ##############################
	protected void store(String name, String value) {
		if (name == null) {
			throw new IllegalArgumentException(
				"["
					+ this.getClass().getName()
					+ "/store] '"
					+ TAG_NAME
					+ "' cannot be null.");
		}
		if (value == null) {
			value = "";
		}
		this.variables.put(name, value);
	}

	/**
	 * @return  counter - valor do contador
	 * @uml.property  name="counter"
	 */
	public long getCounter() {
		return counter++;
	}

	/**
	 * @param l  - valor inical do contador
	 * @uml.property  name="counter"
	 */
	public void setCounter(long l) {
		counter = l;
	}

}
