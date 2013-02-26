public class NWSW extends AlignmentAlgorithm {

	private double[][] A;
	private Sequence seq1;
	private Sequence seq2;
	private char type;
	private double gap;
	private ScoreSystem scoSys;

	public void init(Sequence s1, Sequence s2, char t, double[] g,
			ScoreSystem sc) {
		seq1 = s1;
		seq2 = s2;
		type = t;
		gap = g[0];
		scoSys = sc;

	}

	public void initMatrix() {
		A = new double[seq1.length() + 1][seq2.length() + 1];
		if (type == 'g') {
			A[0][0] = 0;
			for (int i = 1; i <= seq1.length(); i++) {
				A[i][0] = A[i - 1][0] + gap;
			}
			for (int j = 1; j <= seq2.length(); j++) {
				A[0][j] = A[0][j - 1] + gap;
			}
		} else if (type == 'l' || type == 'f') {
			for (int i = 0; i <= seq1.length(); i++) {
				A[i][0] = 0;
			}
			for (int j = 1; j <= seq2.length(); j++) {
				A[0][j] = 0;
			}
		}

	}

	public double calc() {
		if (type == 'g' || type == 'f') {
			for (int i = 1; i <= seq1.length(); i++) {
				for (int j = 1; j <= seq2.length(); j++) {
					double scoreD = A[i - 1][j - 1]
							+ scoSys.score(seq1, i - 1, seq2, j - 1);
					double scoreL = A[i][j - 1] + gap;
					double scoreU = A[i - 1][j] + gap;
					A[i][j] = Math.max(Math.max(scoreD, scoreU), scoreL);
				}
			}
		} else if (type == 'l') {
			for (int i = 1; i <= seq1.length(); i++) {
				for (int j = 1; j <= seq2.length(); j++) {
					double scoreD = A[i - 1][j - 1]
							+ scoSys.score(seq1, i - 1, seq2, j - 1);
					double scoreL = A[i][j - 1] + gap;
					double scoreU = A[i - 1][j] + gap;
					A[i][j] = Math.max(
							Math.max(Math.max(scoreD, scoreU), scoreL), 0);
				}
			}
		}
		return A[seq1.length()][seq2.length()];
	}

	public String[] traceback() {
		String[] align = new String[2];
		align[0] = "";
		align[1] = "";
		if (type == 'g') {
			int i = seq1.length();
			int j = seq2.length();
			while (i > 0 && j > 0) {
				if (A[i][j] == A[i - 1][j - 1]
						+ scoSys.score(seq1, i - 1, seq2, j - 1)) {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + seq2.at(--j);
				} else if (A[i][j] == A[i][j - 1] + gap) {
					align[0] = align[0] + "-";
					align[1] = align[1] + seq2.at(--j);
				} else {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + "-";
				}
			}

			while (i > 0) {
				align[0] = align[0] + seq1.at(--i);
				align[1] = align[1] + "-";
			}
			while (j > 0) {
				align[0] = align[0] + "-";
				align[1] = align[1] + seq2.at(--j);
			}

			align[0] = new StringBuffer(align[0]).reverse().toString();
			align[1] = new StringBuffer(align[1]).reverse().toString();
		}

		else if (type == 'l') {
			double max = 0;
			int imax = 0, jmax = 0;
			for (int i = 1; i <= seq1.length(); i++) {
				for (int j = 1; j <= seq2.length(); j++) {
					if (A[i][j] >= max) {
						max = A[i][j];
						imax = i;
						jmax = j;
					}
				}
			}
			int i = imax;
			int j = jmax;
			while (i > 0 && j > 0) {
				if (A[i][j] == A[i - 1][j - 1]
						+ scoSys.score(seq1, i - 1, seq2, j - 1)) {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + seq2.at(--j);
				} else if (A[i][j] == A[i][j - 1] + gap) {
					align[0] = align[0] + "-";
					align[1] = align[1] + seq2.at(--j);
				} else {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + "-";
				}
				if (A[i][j] == 0)
					break;
			}
			align[0] = new StringBuffer(align[0]).reverse().toString();
			align[1] = new StringBuffer(align[1]).reverse().toString();

		} else if (type == 'f') {
			double max = 0;
			int imax = 0, jmax = 0;
			for (int i = 1; i <= seq1.length(); i++) {
				if (A[i][seq2.length()] >= max) {
					max = A[i][seq2.length()];
					imax = i;
					jmax = seq2.length();
				}
			}
			for (int j = 1; j <= seq2.length(); j++) {
				if (A[seq1.length()][j] >= max) {
					max = A[seq1.length()][j];
					imax = seq1.length();
					jmax = j;
				}
			}
			int i = imax;
			int j = jmax;
			while (i > 0 && j > 0) {
				if (A[i][j] == A[i - 1][j - 1]
						+ scoSys.score(seq1, i - 1, seq2, j - 1)) {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + seq2.at(--j);
				} else if (A[i][j] == A[i][j - 1] + gap) {
					align[0] = align[0] + "-";
					align[1] = align[1] + seq2.at(--j);
				} else {
					align[0] = align[0] + seq1.at(--i);
					align[1] = align[1] + "-";
				}
			}
			align[0] = new StringBuffer(align[0]).reverse().toString();
			align[1] = new StringBuffer(align[1]).reverse().toString();
		}
		return align;
	}
	
	public double[][] getA() {
		return A;
	}

}
