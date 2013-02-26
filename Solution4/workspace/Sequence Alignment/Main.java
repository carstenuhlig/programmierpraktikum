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
			String[] i = { "ARNDCQEGHILKMFPSTWYV", "ARNDCQEGHILKMFPSTWYV" };
			Sequence s1 = new Sequence("SRMPSPPMPVPPAALFNR"), s2 = new Sequence("ARNDCQEGHILKMFPSTWYV");
			alg.init(s1, s2, 'f', g,
					new ScoreSystem(Utilities.readMatrix(m), Utilities.getIndices(m)));
			alg.initMatrix();
			alg.calc();
			String[] result = alg.traceback();
			for (int i1 = 0; i1 < result.length; i1++)
				System.out.println(result[i1]);
			double[][] matrix = alg.getA();
			System.out.print("\t");
			for (int j = 1; j < matrix[0].length; j++){
				System.out.print("\t"+s2.at(j - 1));
			}
			System.out.println();
			for (int i1 = 0; i1 < matrix.length; i1++){
				if(i1 > 0)
					System.out.print(s1.at(i1-1)+"\t");
				else
					System.out.print("\t");
				for (int j = 0; j < matrix[0].length; j++){
					System.out.print(matrix[i1][j]+"\t");
				}
				System.out.println();
			}
			

		}
	}
}