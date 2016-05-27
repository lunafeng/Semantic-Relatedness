-- MySQL dump 10.13  Distrib 5.5.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: CikmTwitterDataSet
-- ------------------------------------------------------
-- Server version	5.5.41-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'CikmTwitterDataSet'
--
/*!50003 DROP PROCEDURE IF EXISTS `CooccurrencesAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`lunafeng`@`localhost` PROCEDURE `CooccurrencesAll`()
BEGIN
    DECLARE TweetCount INT;
    DECLARE CalculationSlot INT;
    DECLARE CalculationStep INT;
    DECLARE StopFlag INT;
    SELECT  COUNT(*) INTO TweetCount FROM TweetsWords;
    SELECT CurrentCalculationSlot, LatestCalculationStep, Stop INTO CalculationSlot,CalculationStep,StopFlag FROM Log WHERE Id = 1;
    SELECT CalculationSlot,CalculationStep,StopFlag;
    WHILE NOT StopFlag AND CalculationStep <= TweetCount Do  
       SELECT CurrentCalculationSlot, LatestCalculationStep, Stop INTO CalculationSlot,CalculationStep,StopFlag FROM Log WHERE Id = 1;     
       SELECT CalculationStep,CalculationSlot;        
       CALL InsertTypelessWordCooccurrence(CalculationStep,CalculationSlot); 
       SET CalculationStep = CalculationStep + CalculationSlot;
       UPDATE Log SET LatestCalculationStep = CalculationStep WHERE Id = 1;
    END WHILE;
    
END ;;
DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertTypelessWordCooccurrence` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;

CREATE DEFINER=`lunafeng`@`localhost` PROCEDURE `InsertTypelessWordCooccurrence`(`skip` BIGINT, `limit` BIGINT)
BEGIN
INSERT INTO CooccurrencesAll
(Word1,
Word2,
Frequency)
SELECT TW1.WordId WordId1, TW2.WordId WordId2, 1 FROM  
(  
	SELECT TweetId, WordId, Id, IsHashtag, IsUrl FROM TweetsWords LIMIT `skip`, `limit` 

) TW1 
LEFT JOIN  
(  
	SELECT TweetId, WordId, Id, IsHashtag, IsUrl FROM TweetsWords LIMIT `skip`, `limit` 

) TW2  ON TW1.TweetId = TW2.TweetId AND TW1.Id <> TW2.Id 
WHERE (TW2.Id IS NULL OR TW1.Id > TW2.Id) 
ORDER BY TW1.Id ASC
ON DUPLICATE KEY UPDATE Frequency = Frequency + 1;

END ;;
DELIMITER ;
