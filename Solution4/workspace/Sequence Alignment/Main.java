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

		if (nw) {
			AlignmentAlgorithm alg = new NWSW();
			double[] g = { -4 };
			Sequence[] seqs = Utilities.getSequences("/home/sch/schmidtju/domains.seqlib");
			alg.init(seqs[0], seqs[1], 'l', g,
					new ScoreSystem(Utilities.readMatrix(m), Utilities.getIndices(m)));
			alg.initMatrix();
			alg.calc();
			String[] result = alg.traceback();		
			System.out.println(result[0]);
			System.out.println(result[1]);
			}
		
		String[][] pair = Utilities.getPairs("/home/sch/schmidtju/sanity.pairs");
		for(int i = 0; i < pair.length; i++){
			System.out.println(pair[i][0] + "\t" + pair[i][1]);
		}
//		Utilities.printSequences(Utilities.getSequences("/home/sch/schmidtju/domains.seqlib"));
	}
}