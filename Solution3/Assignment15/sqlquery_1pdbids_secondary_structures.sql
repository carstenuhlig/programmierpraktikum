SELECT seq.pdbid,sec.type,sec.secondary_structure
 FROM
  sequences seq,secondary_structures sec
 WHERE
  seq.pdbid = '1bo4a' AND seq.id = sec.fromseq