public class NW {

	char[] seq1;
	char[] seq2;
	int[][] matrix;
	int score;
	String align1 = "", align2 = "";
	int g, m, mm;

	public static void main(String[] args) {
		char[] Seq1 = "TAAATCG".toCharArray();
		char[] Seq2 = "ATTACG".toCharArray();

		NW nw = new NW();
		nw.g = -4;
		nw.m = 3;
		nw.mm = -2;
		nw.init(Seq1, Seq2);
		nw.calc();
		nw.bt();
		nw.printM();
		nw.print();

	}

	public void init(char[] seq1, char[] seq2) {
		this.seq1 = seq1;
		this.seq2 = seq2;
		matrix = new int[seq1.length + 1][seq2.length + 1];
		if (seq1 == seq2) {
			System.out.println("Die Sequenzen sind gleich.");
		} else {
			for (int i = 0; i <= seq1.length; i++) {
				for (int j = 0; j <= seq2.length; j++) {
					if (i == 0) {
						matrix[i][j] = j * g;
					} else if (j == 0) {
						matrix[i][j] = i * g;
					} else {
						matrix[i][j] = 0;
					}
				}
			}
		}
	}

	public int w(int i, int j) {
		if (seq1[i - 1] == seq2[j - 1]) {
			return m;
		} else {
			return mm;
		}
	}

	public void calc() {
		for (int i = 1; i <= seq1.length; i++) {
			for (int j = 1; j <= seq2.length; j++) {
				int scoreD = matrix[i - 1][j - 1] + w(i, j);
				int scoreL = matrix[i][j - 1] - 4;
				int scoreO = matrix[i - 1][j] - 4;
				matrix[i][j] = Math.max(Math.max(scoreD, scoreO), scoreL);
			}
		}
	}

	public void bt() {
		int i = seq1.length;
		int j = seq2.length;
		score = matrix[i][j];
		while (i > 0 && j > 0) {
			if (matrix[i][j] == matrix[i - 1][j - 1] + w(i, j)) {
				align1 = align1 + seq1[--i];
				align2 = align2 + seq2[--j];
			} else if (matrix[i][j] == matrix[i][j - 1] + g) {
				align1 = align1 + "-";
				align2 = align2 + seq2[--j];
			} else {
				align1 = align1 + seq1[--i];
				align2 = align2 + "-";
			}
		}
		
		while (i > 0) {
			align1 = align1 + seq1[--i];
			align2 = align2 + "-";
		}
		while (j > 0) {
			align1 = align1 + "-";
			align2 = align2 + seq2[--j];
		}
		
		align1 = new StringBuffer(align1).reverse().toString();
		align2 = new StringBuffer(align2).reverse().toString();
	}

	public void printM() {
		System.out.println("Matrix = ");
		for (int i = 0; i < seq1.length + 1; i++) {
			for (int j = 0; j < seq2.length + 1; j++) {
				System.out.print(matrix[i][j] + "\t");
			}
			System.out.println();
		}
	}

	public void print() {
		System.out.println("Score: " + score);
		System.out.println("Sequenz 1: " + align1);
		System.out.println("Sequenz 2: " + align2);
		System.out.println();
	}
}

