package br.com.auster.nextel.isc.request.sql;

import br.com.auster.dware.graph.Request;


public class SQLRequest extends Request {

	private long	weight;
	
	public long getWeight() {
		return weight;
	}

	
	/**
	 * @param weight the weight to set
	 */
	public void setWeight(long weight) {
		this.weight = weight;
	}

	public String toString() {
		return "ID=" + this.getId() + ".WEIGHT=" + this.getWeight();
	}
}
