import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

public class Main {

	public static void main(String[] args) {
		String pairs = "", seqlib = "", m = "", dpmatrices = "", mode = "", format = "";
		int go = -12, ge = -1;
		boolean nw = false, check = false;
		for (int i = 0; i < args.length; i++) {
			try {
				if (args[i].equals("--pairs"))
					pairs = args[++i];
				else if (args[i].equals("--seqlib"))
					seqlib = args[++i];
				else if (args[i].equals("-m"))
					m = args[++i];
				else if (args[i].equals("-dpmatrices"))
					dpmatrices = args[++i];
				else if (args[i].equals("-mode"))
					mode = args[++i];
				else if (args[i].equals("-format"))
					format = args[++i];
				else if (args[i].equals("--go")) {
					try {
						go = Integer.parseInt(args[++i]);
					} catch (NumberFormatException e) {
						System.out.println("wrong format after --go");
					}
				} else if (args[i].equals("--ge")) {
					try {
						ge = Integer.parseInt(args[++i]);
					} catch (NumberFormatException e) {
						System.out.println("wrong format after --ge");
					}
				} else if (args[i].equals("--nw"))
					nw = true;
				else if (args[i].equals("--check"))
					check = true;
			} catch (ArrayIndexOutOfBoundsException e) {
				System.out.println("missing argument after " + args[i - 1]);
			}
		}

		AlignmentAlgorithm alg;
		double[] g;
		if (nw) {
			alg = new NWSW();
			double[] temp = { -4 };
			g = temp;
		} else {
			alg = new Gotoh();
			double[] temp = { go, ge };
			g = temp;
		}
		String[][] pair = Utilities
				.getPairs("/home/sch/schmidtju/sanity.pairs");
		Sequence[] seqs = Utilities
				.getSequences("/home/sch/schmidtju/domains.seqlib");
		Sequence s1 = null;
		Sequence s2 = null;
		for (int i = 0; i < pair.length; i++) { // pair.length
			boolean f1 = false, f2 = false;
			for (int j = 0; j < seqs.length; j++) {
				if (pair[i][0].equals(seqs[j].getId())) {
					s1 = seqs[j];
					f1 = true;
				} else if (pair[i][1].equals(seqs[j].getId())) {
					s2 = seqs[j];
					f2 = true;
				}
				if (f1 && f2)
					break;
			}
			// s1 = new Sequence("id1", "GAAAG");
			// s2 = new Sequence("id2", "GG");
			alg.init(s1, s2, 'f', g, new ScoreSystem(Utilities.readMatrix(m),
					Utilities.getIndices(m)));
			alg.initMatrix();
			DecimalFormatSymbols dfs = DecimalFormatSymbols.getInstance();
			dfs.setDecimalSeparator('.');
			DecimalFormat df = new DecimalFormat("0.000", dfs);
			System.out.println(">" + s1.getId() + " " + s2.getId() + " "
					+ df.format(alg.calc()));
			String[] result = alg.traceback();
			System.out.println(s1.getId() + ": " + result[0]);
			System.out.println(s2.getId() + ": " + result[1]);
//			System.out.println(alg.checkScore(result));
			// Utilities.printMatrix(alg.getMatrix('A'), s1, s2);
			// Utilities.printMatrix(alg.getMatrix('A'), s1, s2);
			// Utilities.printMatrix(alg.getMatrix('A'), s1, s2);
		}

	}
}