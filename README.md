# SemanticRelatedness
Semantic Relatedness methods designed especially for Twitter Content

To find the semantic relatedness between two words obtained from tweets, the proposed method is as follows:

1. create a graph where nodes are words from tweets, edges are the conditional probability from one node to another based on the cooccurrence frequency and occurrence frequency.
2. apply Random Walk from a target node(word) to create static distribution for it which represent the features of the target word.
3. apply cosine similarity method on two static distributions for two words respectively to get the final semantic relatedness score.


The implementations includes following:
1. Folder Prep includes all the scripts to generate the graph, stored in json file
2. Load graph.json file and create statistic distribution for each target word

Usage
python staticDistribution.py



