package br.com.auster.nextel.isc.filter;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.w3c.dom.Element;

import br.com.auster.common.xml.DOMUtils;
import br.com.auster.dware.filter.PartialInputFromFileList;
import br.com.auster.dware.graph.FilterException;
import br.com.auster.dware.graph.Request;
import br.com.auster.dware.request.RequestFilter;
import br.com.auster.dware.request.file.FileRequestBuilder;
import br.com.auster.dware.request.file.PartialFileRequest;


public class InputFromGelFilter extends PartialInputFromFileList {
	
	public static final String GEL_FILENAME_ATTR = "filename";
	public static final String BUILDER_ELT = "builder";
	public static final String KEY_FIELD_ATTR = "request-key-field";
	
	private static Map gelRequests = new HashMap();
	
	private String filename = null, keyField = null;
	private Map requests = null;
	
	public InputFromGelFilter(String name) {
    super(name);
    
  }
	
	public synchronized void configure(Element config) throws FilterException {
		super.configure(config);
		this.filename = DOMUtils.getAttribute(config, GEL_FILENAME_ATTR, true);
		this.keyField = DOMUtils.getAttribute(config, KEY_FIELD_ATTR, false);
		if (! gelRequests.containsKey(this.filename)) {
			// initializes GEL file
			Element builderElt = DOMUtils.getElement(config, BUILDER_ELT, true);
			FileRequestBuilder builder = new FileRequestBuilder(filename, builderElt);
			Map builderArgs = new HashMap(2);
			builderArgs.put(FileRequestBuilder.FILENAMES_ARG, this.filename);
			
			RequestFilter filter = builder.createRequests(builderArgs);
			Iterator it = filter.getAcceptedRequests().iterator();
			Map reqs = new HashMap();
			while (it.hasNext()) {
				Request request = (Request) it.next();
				reqs.put(request.getUserKey(), request);
			}
			
			// add an empty request
			File file = new File(this.filename);
			PartialFileRequest req = new PartialFileRequest(0, 0, file);
			reqs.put(null, req);
			
			gelRequests.put(this.filename, reqs);
		}
		this.requests = (Map) gelRequests.get(this.filename);
	}
	
	public void prepare(Request request) throws FilterException {
		
		final String requestKey;
		if (this.keyField == null) {
			requestKey = request.getUserKey();
		} else {
			requestKey = (String) request.getAttributes().get(this.keyField);
		}
		
		Request gelRequest = (Request) this.requests.get(requestKey);
		if (gelRequest == null) {
			log.warn("{" + this.filename + "} GEL request not found for " + request);
			gelRequest = (Request) this.requests.get(null);
		}
		super.prepare(gelRequest);
  }

}
