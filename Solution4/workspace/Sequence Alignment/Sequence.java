
public class Sequence {
	String id;
	char[] sequence;
//	String sequence;
	
	public Sequence(String i, String s){
		id = i;
//		sequence = s;
		sequence = s.toCharArray();
	}
	
	public char at(int pos){
		return sequence[pos];
//		return sequence.charAt(pos);
	}
	
	public int length(){
		return sequence.length;
	}
	
	public String getSequence(){
		return sequence.toString();
	}
	
	public String getId(){
		return id;
	}
	
	
}
