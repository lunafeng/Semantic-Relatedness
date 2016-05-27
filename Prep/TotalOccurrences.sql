INSERT INTO TotalOccurrencesAll(Word,TotalOccurrences)

SELECT C1.Word,
       C1.TotalOccurrences + C2.TotalOccurrences AS TotalOccurrences
FROM
( SELECT Word1 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged GROUP BY Word1 
) AS C1

JOIN

( SELECT Word2 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged WHERE Word2 IS NOT NULL GROUP BY Word2 
) AS C2 ON C1.Word = C2.Word

UNION

SELECT C1.Word,
       C1.TotalOccurrences
FROM
( SELECT Word1 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged GROUP BY Word1 
) AS C1

LEFT JOIN

( SELECT Word2 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged WHERE Word2 IS NOT NULL GROUP BY Word2 
) AS C2 ON C1.Word = C2.Word WHERE C2.Word IS NULL

UNION

SELECT C2.Word,
       C2.TotalOccurrences
FROM
( SELECT Word1 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged GROUP BY Word1 
) AS C1

RIGHT JOIN

( SELECT Word2 AS Word,
       SUM(Frequency) AS TotalOccurrences
  FROM CooccurrencesMerged WHERE Word2 IS NOT NULL GROUP BY Word2
) AS C2 ON C1.Word = C2.Word WHERE C1.Word IS NULL;
