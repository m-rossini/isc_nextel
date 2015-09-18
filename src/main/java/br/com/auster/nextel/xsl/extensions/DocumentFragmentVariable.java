package br.com.auster.nextel.xsl.extensions;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.xalan.extensions.XSLProcessorContext;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class DocumentFragmentVariable {

	protected HashMap variables = new HashMap();

	// ##############################
	// ELEMENTS
	// ##############################
	public void reset(XSLProcessorContext context, Element elem) {
		this.variables.clear();
	}


	// ##############################
	// FUNCTIONS
	// ##############################
	public NodeListImpl getValue(String name) {
//		if (!this.variables.containsKey(name)) {
//			throw new IllegalArgumentException("[" + this.getClass().getName()
//					+ "/getValue] " + "Variable '" + name + "' does not exist.");
//		}
		return (NodeListImpl) this.variables.get(name);
	}

	public void addNode(String name, Node value) {
		if (name == null) {
			throw new IllegalArgumentException("[" + this.getClass().getName()
					+ "/store] '" + Variable.TAG_NAME + "' cannot be null.");
		}
		NodeListImpl nodes = (NodeListImpl) this.variables.get(name);
		if (nodes == null) {
			nodes = new NodeListImpl();
			nodes.add(value);
			this.variables.put(name, nodes);
		} else {
			nodes.add(value);
		}
	}
	
	public void add(String name, NodeList value) {
		if (name == null) {
			throw new IllegalArgumentException("[" + this.getClass().getName()
					+ "/store] '" + Variable.TAG_NAME + "' cannot be null.");
		}
		
		NodeListImpl nodes = (NodeListImpl) this.variables.get(name);
		if (nodes == null) {
			nodes = new NodeListImpl();
			this.variables.put(name, nodes);
		}
		
		for (int i = 0; i < value.getLength(); i++) {
			nodes.add(value.item(i));
		}
	}
	
	public class NodeListImpl implements NodeList {
		
		private ArrayList nodes = new ArrayList();

		public int getLength() {
			return this.nodes.size();
		}

		public Node item(int i) {
			return (Node) this.nodes.get(i);
		}
		
		public void add(Node node) {
			this.nodes.add(node);
		}
		
	}

}
