SELECT seq1.pdbid,str1.structure_alignment,seq2.pdbid,str2.structure_alignment
 FROM
  sequences seq1,structure_alignments str1,structure_alignments str2,sequences seq2
 WHERE
  seq1.id = str1.fromseq AND seq2.id = str2.fromseq AND seq.pdbid = '1bo4a' AND str1.align_id = str2.align_id