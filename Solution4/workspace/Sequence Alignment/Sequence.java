
public class Sequence {
	String id;
	char[] sequence;
	
	public Sequence(String s){
		sequence = s.toCharArray();
	}
	
	public char at(int pos){
		return sequence[pos];
	}
	
	public int length(){
		return sequence.length;
	}
	
	
}
