import java.io.*;
import java.text.DecimalFormat;

public class Utilities {
	public static double[][] readMatrix(String path) {
		double[][] matrix = new double[20][20];
		int nrow = 0, ncol = 0;
		try {
			String line;
			String[] mlines = new String[20];
			FileReader fr = new FileReader(path);
			BufferedReader br = new BufferedReader(fr);
			while ((line = br.readLine()) != null) {
				if (line.length() > 6 && line.substring(0, 6).equals("NUMROW")) {
					String[] l = line.split("\\s+");
					nrow = Integer.parseInt(l[1]);

				} else if (line.length() > 6
						&& line.substring(0, 6).equals("NUMCOL")) {
					String[] l = line.split("\\s+");
					ncol = Integer.parseInt(l[1]);
					mlines = new String[ncol];
					matrix = new double[nrow][ncol];
					break;
				}
			}

			int i = 0;
			while ((line = br.readLine()) != null) {
				if (line.length() > 6 && line.substring(0, 6).equals("MATRIX")) {
					String[] l = line.split("\\s+");
					for (int j = 1; j < l.length; j++) {
						matrix[i][j - 1] = Double.parseDouble(l[j] + "0");
						matrix[j - 1][i] = matrix[i][j - 1];
					}
					i++;
				}
			}
		} catch (FileNotFoundException fne) {
			System.out.println("File not found.");
		} catch (IOException ioe) {
			System.out.println("IOException occured.");
		}
		return matrix;
	}

	public static String[] getIndices(String path) {
		String[] indices = new String[2];
		try {
			String line;
			BufferedReader br = new BufferedReader(new FileReader(path));
			String[] mlines = new String[2];
			while ((line = br.readLine()) != null) {
				if (line.length() > 8
						&& line.substring(0, 8).equals("ROWINDEX")) {
					String[] l = line.split("\\s+");
					indices[0] = l[1];
				} else if (line.length() > 8
						&& line.substring(0, 8).equals("COLINDEX")) {
					String[] l = line.split("\\s");
					indices[1] = l[1];
				}

			}
		} catch (FileNotFoundException fne) {
			System.out.println("File not found.");
		} catch (IOException ioe) {
			System.out.println("IOException occured.");
		}

		return indices;
	}

	public static Sequence[] getSequences(String path) {
		int numlines = 0;
		try {
			LineNumberReader lnr;
			lnr = new LineNumberReader(new FileReader(new File(path)));
			lnr.skip(Long.MAX_VALUE);
			numlines = lnr.getLineNumber();
		} catch (FileNotFoundException e) {
			System.out.println("File not found.");
		} catch (IOException e) {
			System.out.println("IOException occured.");
		}
		Sequence[] seqs = new Sequence[numlines];
		try {
			String line;
			int i = 0;
			BufferedReader br = new BufferedReader(new FileReader(path));
			while ((line = br.readLine()) != null) {
				String[] l = line.split(":");
				seqs[i] = new Sequence(l[0], l[1]);
				i++;
			}
		} catch (FileNotFoundException fne) {
			System.out.println("File not found.");
		} catch (IOException ioe) {
			System.out.println("IOException occured.");
		}
		return seqs;
	}
	
	public static String[][] getPairs(String path) {
		int numlines = 0;
		try {
			LineNumberReader lnr;
			lnr = new LineNumberReader(new FileReader(new File(path)));
			lnr.skip(Long.MAX_VALUE);
			numlines = lnr.getLineNumber();
		} catch (FileNotFoundException e) {
			System.out.println("File not found.");
		} catch (IOException e) {
			System.out.println("IOException occured.");
		}
		String[][] pairs = new String[numlines][2];
		try {
			String line;
			int i = 0;
			BufferedReader br = new BufferedReader(new FileReader(path));
			while ((line = br.readLine()) != null) {
				String[] l = line.split("\\s");
				pairs[i][0] = l[0];
				pairs[i][1] = l[1];
				i++;
			}
		} catch (FileNotFoundException fne) {
			System.out.println("File not found.");
		} catch (IOException ioe) {
			System.out.println("IOException occured.");
		}
		return pairs;
	}

	
	public static void printMatrix(double[][] matrix, Sequence s1, Sequence s2) {
		System.out.print("\t");
		for (int j = 1; j < matrix[0].length; j++) {
			System.out.print("\t" + s2.at(j - 1));
		}
		System.out.println();
		for (int i1 = 0; i1 < matrix.length; i1++) {
			if (i1 > 0)
				System.out.print(s1.at(i1 - 1) + "\t");
			else
				System.out.print("\t");
			for (int j = 0; j < matrix[0].length; j++) {
				System.out.print(new DecimalFormat("0.00").format(matrix[i1][j]) + "\t");
			}
			System.out.println();
		}
	}
	
	public static void printSequences(Sequence[] seqs){
		for(int i = 0; i < seqs.length; i++){
			System.out.println(seqs[i].getSequence());
		}
	}
	
}