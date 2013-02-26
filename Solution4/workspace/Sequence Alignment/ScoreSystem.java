
public class ScoreSystem {
	double[][] weights;
	String rowindex, colindex;
		
	public ScoreSystem(double[][] s, String[] indices){
		weights = s;
		rowindex = indices[0];
		colindex = indices[1];
	}
	
	public double score(Sequence s1, int p1, Sequence s2, int p2){
		return weights[rowindex.indexOf(s1.at(p1))][rowindex.indexOf(s2.at(p2))];
	}
	
	
}
