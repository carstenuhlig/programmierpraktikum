
public abstract class AlignmentAlgorithm {
	
	public abstract void init(Sequence s1, Sequence s2, char t, double[] g, ScoreSystem sc);
	public abstract void initMatrix();
	public abstract double calc();
	public abstract String[] traceback();
	public abstract double[][] getMatrix(char name);
	public abstract double checkScore(String[] align);
	
}