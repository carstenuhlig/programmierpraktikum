SELECT seq1.pdbid,S1.structure_alignment,seq2.pdbid,S2.structure_alignment
 FROM
  structure_alignments S1, sequences seq1, structure_alignments S2, sequences seq2
 WHERE
  seq1.pdbid = '1bo4a' AND S1.fromseq = seq1.id AND seq2.pdbid = '1cm0a' AND S2.fromseq = seq2.id AND S1.align_id = S2.align_id;