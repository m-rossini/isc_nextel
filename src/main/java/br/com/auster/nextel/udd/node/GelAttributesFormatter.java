package br.com.auster.nextel.udd.node;

import org.apache.log4j.Logger;

import br.com.auster.udd.node.UDDSimpleAttributeFormatter;

public class GelAttributesFormatter extends UDDSimpleAttributeFormatter {
	
	private static final Logger log = Logger.getLogger(GelAttributesFormatter.class);

	public CharSequence format(CharSequence data) {
    CharSequence result = null;
		if (this.type.equals(DATE_TYPE)) {
			if (data.length() < 6) {
				if (data.length() > 0) {
					log.error("Formatter is of type DATE, but input data is not in ddmmyy format: "
							  + data);
				}
				return data;
			}
      StringBuilder sb = new StringBuilder();
			sb.append(data.subSequence(0, 2));
			sb.append('/');
			sb.append(data.subSequence(2, 4));
			sb.append('/').append('2').append('0');
			sb.append(data.subSequence(4, 6));
      result = sb.toString();
		} else {
			result = super.format(data);
		}

		return result;
	}

	public String toString() {
		return "Formatter for [" + this.name + "]";
	}
	
}
