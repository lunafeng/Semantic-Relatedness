#!/usr/bin/python
import sys
import MySQLdb

reload(sys)
sys.setdefaultencoding("utf-8")

db_mysql = MySQLdb.connect('141.117.3.92','lunafeng','luna222','WordsDisambiguation_b4')

def checkExist(spot):
	db_mysql.ping()
	cursor = db_mysql.cursor()
	sql = "SELECT * FROM Tweets WHERE Spot = \'" + spot + "\'"
	try:
		cursor.execute(sql)
		result = cursor.fetchone()
	except:
		result = None
	return result

fd = open("../Spots_tagme_nofilter", "r")
contents = fd.readlines()

count = 0
for c in contents:
	c = c.strip("\n")
	cList = c.split("\t")
	spot = cList[0].title()
	if checkExist(spot) is None and cList[1] == "1":
#	if cList[1] == "1":
			fdTweets = open("TweetsRefined/" + cList[0], "r")
			tweets = fdTweets.readlines()
			for t in tweets:
				insert = ""
				t = t.strip("\n")
				tList = t.split("\t")
				id = tList[0]
				tweet = tList[1]
				tweet = tweet.replace("\'", "")
				tweet = tweet.replace("\"", "")
				tweet = tweet.replace("\\", "")
				spot = spot.replace("\'", "")
				spot = spot.replace("\"", "")
				spot = spot.replace("\\", "")
				insert +=  "(" + str(id) + ",\'" + cList[0] + "\',\'" + tweet + "\')"
				db_mysql.ping()
				cursor = db_mysql.cursor()
				importsql = "INSERT IGNORE INTO Tweets(TweetId, Spot, Text) VALUES " + insert
				print importsql
				try:
						cursor.execute(importsql)
						db_mysql.commit()
				except:
						db_mysql.rollback()
