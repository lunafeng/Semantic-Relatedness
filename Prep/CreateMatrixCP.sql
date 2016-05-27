INSERT INTO MatrixCPNoOneNoCommon(
	FromWord,
	ToWord,
	Probability
)

SELECT C.Word1,
	C.Word2,
	(C.Frequency/T.TotalOccurrences) AS Probability
FROM TotalOccurrencesAll T
JOIN CooccurrencesMerged C 
ON (C.Word1 = T.Word);

