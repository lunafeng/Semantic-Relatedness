UPDATE CooccurrencesAll c1
JOIN CooccurrencesAll c2 ON (c1.Word1=c2.Word2 AND c1.Word2=c2.Word1) 
SET c1.FrequencyRefined = c1.Frequency + c2.Frequency;
