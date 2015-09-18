package br.com.auster.nextel.isc.request.file;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;

import br.com.auster.common.log.LogFactory;
import br.com.auster.common.util.I18n;
import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.request.HashRequestFilter;
import br.com.auster.dware.request.RequestFilter;
import br.com.auster.dware.request.file.FileRequest;
import br.com.auster.dware.request.file.FileRequestBuilder;

public class BGHFileRequestBuilder extends FileRequestBuilder {
	
	/**
	 * {@value}
	 */
	public static final String REQUEST_ID_PATTERN = "request-id-pattern";
	
	private static final Logger log = LogFactory.getLogger(BGHFileRequestBuilder.class);
	
	private final I18n i18n = I18n.getInstance(FileRequestBuilder.class);

	private Pattern requestIdPattern = null;
	
	public BGHFileRequestBuilder(String name, Element config) {
		super(config, name);
		String requestIdPatternAtt  = DOMUtils.getAttribute(config, REQUEST_ID_PATTERN, true);
		this.requestIdPattern  = Pattern.compile(requestIdPatternAtt);
	}

	public RequestFilter createRequests(RequestFilter filter, Map args) {
		final RequestFilter requestFilter;
		if (filter == null) {
			requestFilter = new HashRequestFilter();
		} else {
			requestFilter = filter;
		}
		
		final FileBuilderArgs params = parseFileArgs(args);

		// request attributes
		Map atts = new HashMap();

		Iterator it = params.getFiles().iterator();
		while (it.hasNext() && requestFilter.canAccept()) {
			final File file = (File) it.next();

			final String requestId = getRequestId(file.getName());
			FileRequest request = new FileRequest(requestId, file);
			this.staticAttributes.insertStatics(atts);

			if (params.getTransactionId() != null) {
				request.setTransactionId(params.getTransactionId());
			}
			if (params.getRequestParams() != null) {
				atts.putAll(params.getRequestParams());
			}
			request.setAttributes(atts);
			if (requestFilter.accept(request)) {
				log.debug(i18n.getString("foundRequest", request));
			} else {
				log.debug(i18n.getString("discardedRequest", request));
			}
			// prepare the atts map for the next request
			atts.clear();
		}
		return requestFilter;
	}

	private String getRequestId(String filename) {
		Matcher matcher = this.requestIdPattern.matcher(filename);
		if (!matcher.matches()) {
			return "";
		}
		StringBuilder builder = new StringBuilder();
		for (int i = 1; i <= matcher.groupCount(); i++) {
			builder.append(matcher.group(i));
		}
		return builder.toString();
	}

	
}
