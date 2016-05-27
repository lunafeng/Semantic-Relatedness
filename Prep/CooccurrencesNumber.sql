insert ignore into CooccurrencesMerged(word2,word1,frequency)
select word1,
	word2,
	case when frequencyrefined is not null then frequencyrefined else frequency end as frequency 
from CooccurrencesAll;
