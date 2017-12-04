-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: wsoapp
-- ------------------------------------------------------
-- Server version	5.7.19-log

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
-- Table structure for table `ensemble`
--

DROP TABLE IF EXISTS `ensemble`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ensemble` (
  `Ensemble_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  PRIMARY KEY (`Ensemble_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ensemble`
--

LOCK TABLES `ensemble` WRITE;
/*!40000 ALTER TABLE `ensemble` DISABLE KEYS */;
INSERT INTO `ensemble` VALUES (1,'Lewis Family'),(2,'Adult Choir'),(3,'7-9th Choir');
/*!40000 ALTER TABLE `ensemble` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ensembleperson`
--

DROP TABLE IF EXISTS `ensembleperson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ensembleperson` (
  `Ensemble_ID` int(11) NOT NULL,
  `Person_ID` int(11) NOT NULL,
  PRIMARY KEY (`Ensemble_ID`,`Person_ID`),
  KEY `FK_EnsemblePerson_Person` (`Person_ID`),
  CONSTRAINT `FK_EnsemblePerson_Ensemble` FOREIGN KEY (`Ensemble_ID`) REFERENCES `ensemble` (`Ensemble_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_EnsemblePerson_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ensembleperson`
--

LOCK TABLES `ensembleperson` WRITE;
/*!40000 ALTER TABLE `ensembleperson` DISABLE KEYS */;
INSERT INTO `ensembleperson` VALUES (2,7),(1,9),(2,10),(2,13),(3,16),(3,18);
/*!40000 ALTER TABLE `ensembleperson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventtype`
--

DROP TABLE IF EXISTS `eventtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventtype` (
  `EventType_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(50) NOT NULL,
  PRIMARY KEY (`EventType_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventtype`
--

LOCK TABLES `eventtype` WRITE;
/*!40000 ALTER TABLE `eventtype` DISABLE KEYS */;
INSERT INTO `eventtype` VALUES (1,'1'),(2,'Prelude'),(3,'Welcome'),(4,'Scripture Reading'),(5,'Congregational Song'),(6,'Prayer'),(7,'Offertory'),(8,'Choir'),(9,'Special Music'),(10,'Message'),(11,'Closing Song'),(12,'Postlude'),(13,'Lord\'s Supper'),(14,'Prayer/Announcements');
/*!40000 ALTER TABLE `eventtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `Person_ID` int(11) NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(15) NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'Rebekah','Hawkey','rhawkey@gmail.com'),(2,'April','Bixby','abixby@gmail.com'),(3,'Steve','Lee','slee@gmail.com'),(4,'Robert','Everett','reveret@gmail.com'),(5,'Sam','Martin','smartin@gmail.com'),(6,'Judy','Jackson','jjackson@gmail.com'),(7,'Jon','Avery','javery@gmail.com'),(8,'Sarah','Dobney','sdobney@gmail.com'),(9,'Tomothy','Lewis','tlewis@gmail.com'),(10,'Nathan','Martin','nmartin@gmail.com'),(11,'Stan','Bush','sbush@gmail.com'),(12,'Holly','Fordham','hfordham@gmail.com'),(13,'Cyndi','Wright','cwright@gmail.com'),(14,'Ed','Jackson','ejackson@gmail.com'),(15,'Jonathan','Boyle','jboyle@gmail.com'),(16,'Alan','Kennedy','akennedy@gmail.com'),(18,'Stephan','Griggs','sgriggs@gmail.com');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personunavailable`
--

DROP TABLE IF EXISTS `personunavailable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personunavailable` (
  `Person_ID` int(11) NOT NULL,
  `Service_ID` int(11) NOT NULL,
  PRIMARY KEY (`Person_ID`,`Service_ID`),
  KEY `FK_PersonUnavailable_Service` (`Service_ID`),
  CONSTRAINT `FK_PersonUnavailable_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PersonUnavailable_Service` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personunavailable`
--

LOCK TABLES `personunavailable` WRITE;
/*!40000 ALTER TABLE `personunavailable` DISABLE KEYS */;
INSERT INTO `personunavailable` VALUES (6,1),(10,1),(14,1),(10,2),(2,6),(16,6);
/*!40000 ALTER TABLE `personunavailable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `Service_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Svc_DateTime` datetime(6) NOT NULL,
  `Theme` varchar(40) DEFAULT NULL,
  `Title` varchar(40) DEFAULT NULL,
  `Notes` varchar(255) DEFAULT NULL,
  `Organist_Conf` char(1) NOT NULL,
  `Songleader_Conf` char(1) NOT NULL,
  `Pianist_Conf` char(1) NOT NULL,
  `Organist_ID` int(11) DEFAULT NULL,
  `Songleader_ID` int(11) DEFAULT NULL,
  `Pianist_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`Service_ID`),
  KEY `FK_Service_Organist` (`Organist_ID`),
  KEY `FK_Service_Pianist` (`Pianist_ID`),
  KEY `FK_Service_Songleader` (`Songleader_ID`),
  CONSTRAINT `FK_Service_Organist` FOREIGN KEY (`Organist_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Service_Pianist` FOREIGN KEY (`Pianist_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Service_Songleader` FOREIGN KEY (`Songleader_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'2010-10-03 10:30:00.000000','Peace of Christ Rule in Your Hearts','A.M Worship Service',NULL,'Y','N','Y',7,16,13),(2,'2010-10-03 16:00:00.000000','Lord\'s Supper','4 PM Worship Service',NULL,'Y','Y','Y',14,15,6),(3,'2010-10-03 18:00:00.000000',NULL,'6 PM Service',NULL,'Y','Y','Y',18,16,10),(6,'2010-10-10 10:30:00.000000','Drawing Nearer',NULL,NULL,'Y','N','Y',2,16,NULL);
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serviceevent`
--

DROP TABLE IF EXISTS `serviceevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serviceevent` (
  `Event_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Service_ID` int(11) NOT NULL,
  `Seq_Num` int(11) NOT NULL,
  `EventType_ID` int(11) DEFAULT NULL,
  `Notes` varchar(40) DEFAULT NULL,
  `Confirmed` char(1) NOT NULL,
  `Person_ID` int(11) DEFAULT NULL,
  `Ensemble_ID` int(11) DEFAULT NULL,
  `Song_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`Event_ID`),
  KEY `FK_ServiceEvent_Ensemble` (`Ensemble_ID`),
  KEY `FK_ServiceEvent_EventType` (`EventType_ID`),
  KEY `FK_ServiceEvent_Person` (`Person_ID`),
  KEY `FK_ServiceEvent_Service` (`Service_ID`),
  KEY `FK_ServiceEvent_Song` (`Song_ID`),
  CONSTRAINT `FK_ServiceEvent_Ensemble` FOREIGN KEY (`Ensemble_ID`) REFERENCES `ensemble` (`Ensemble_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ServiceEvent_EventType` FOREIGN KEY (`EventType_ID`) REFERENCES `eventtype` (`EventType_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ServiceEvent_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ServiceEvent_Service` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ServiceEvent_Song` FOREIGN KEY (`Song_ID`) REFERENCES `song` (`Song_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serviceevent`
--

LOCK TABLES `serviceevent` WRITE;
/*!40000 ALTER TABLE `serviceevent` DISABLE KEYS */;
INSERT INTO `serviceevent` VALUES (1,1,1,1,'flute','Y',1,NULL,2),(2,1,2,2,NULL,'Y',2,NULL,NULL),(3,1,3,3,NULL,'Y',3,NULL,NULL),(4,1,4,2,NULL,'Y',2,NULL,NULL),(5,1,5,4,NULL,'Y',3,NULL,NULL),(6,1,6,5,NULL,'Y',NULL,NULL,2),(7,1,7,6,NULL,'Y',4,NULL,NULL),(8,1,8,5,NULL,'Y',NULL,NULL,3),(9,1,9,7,'From organ well, need MIC','Y',NULL,1,4),(10,1,10,8,NULL,'Y',NULL,2,5),(11,1,11,5,NULL,'Y',NULL,NULL,6),(12,1,12,9,NULL,'Y',5,NULL,7),(13,1,13,10,NULL,'Y',4,NULL,NULL),(14,1,14,11,NULL,'Y',NULL,NULL,8),(15,1,15,12,NULL,'Y',2,NULL,NULL),(16,2,1,2,NULL,'Y',6,NULL,NULL),(17,2,2,6,NULL,'N',1,NULL,NULL),(18,2,3,5,NULL,'Y',NULL,NULL,9),(19,2,4,5,NULL,'Y',NULL,NULL,10),(21,2,5,5,NULL,'Y',NULL,NULL,13),(22,2,6,5,NULL,'Y',NULL,NULL,14),(23,2,7,14,NULL,'Y',7,NULL,NULL),(24,3,1,2,NULL,'Y',10,NULL,NULL),(25,3,2,6,NULL,'Y',3,NULL,NULL),(26,3,3,5,NULL,'Y',NULL,NULL,9),(27,3,4,5,NULL,'Y',NULL,NULL,10),(28,3,5,5,NULL,'Y',NULL,NULL,13),(29,3,6,5,NULL,'Y',NULL,NULL,14),(30,3,7,14,NULL,'Y',11,NULL,NULL),(33,6,1,1,NULL,'N',2,NULL,NULL),(34,6,2,5,NULL,'Y',NULL,NULL,6);
/*!40000 ALTER TABLE `serviceevent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `serviceeventview`
--

DROP TABLE IF EXISTS `serviceeventview`;
/*!50001 DROP VIEW IF EXISTS `serviceeventview`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `serviceeventview` AS SELECT 
 1 AS `Service_ID`,
 1 AS `Seq_Num`,
 1 AS `Description`,
 1 AS `Name`,
 1 AS `Title`,
 1 AS `Notes`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `song` (
  `Song_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Song_Type` char(1) NOT NULL,
  `Title` varchar(50) NOT NULL,
  `Hymnbook_Num` varchar(5) DEFAULT NULL,
  `Arranger` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Song_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'C','It is Well',NULL,NULL),(2,'H','Sing Praise to God Who Reigns Above','60',NULL),(3,'H','Like a River Glorious','352',NULL),(4,'C','May the Mind of Christ my Savior',NULL,NULL),(5,'C','If You Search with All Your Hearts',NULL,NULL),(6,'H','Hiding in Thee','608',NULL),(7,'C','Jesus, I am Resting',NULL,NULL),(8,'H','For All the Saints','643',NULL),(9,'H','At the Cross','140',NULL),(10,'H','He Died For ME','154',NULL),(13,'H','When I Survey','137',NULL),(14,'H','It is Finished','138',NULL),(15,'H','Jesus Paid It All','390',NULL);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `songusageview`
--

DROP TABLE IF EXISTS `songusageview`;
/*!50001 DROP VIEW IF EXISTS `songusageview`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `songusageview` AS SELECT 
 1 AS `Song_IDM`,
 1 AS `Song_Type`,
 1 AS `Title`,
 1 AS `Hymnbook_Num`,
 1 AS `Arranger`,
 1 AS `LastDateUsed`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'wsoapp'
--

--
-- Final view structure for view `serviceeventview`
--

/*!50001 DROP VIEW IF EXISTS `serviceeventview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `serviceeventview` AS select `service`.`Service_ID` AS `Service_ID`,`serviceevent`.`Seq_Num` AS `Seq_Num`,`eventtype`.`Description` AS `Description`,coalesce(`ensemble`.`Name`,concat(`person`.`First_Name`,' ',`person`.`Last_Name`)) AS `Name`,`song`.`Title` AS `Title`,`serviceevent`.`Notes` AS `Notes` from (((((`service` join `serviceevent` on((`service`.`Service_ID` = `serviceevent`.`Service_ID`))) left join `person` on((`serviceevent`.`Person_ID` = `person`.`Person_ID`))) left join `ensemble` on((`serviceevent`.`Ensemble_ID` = `ensemble`.`Ensemble_ID`))) left join `song` on((`serviceevent`.`Song_ID` = `song`.`Song_ID`))) join `eventtype` on((`serviceevent`.`EventType_ID` = `eventtype`.`EventType_ID`))) order by `service`.`Service_ID`,`serviceevent`.`Seq_Num` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `songusageview`
--

/*!50001 DROP VIEW IF EXISTS `songusageview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `songusageview` AS select distinct `song`.`Song_ID` AS `Song_IDM`,`song`.`Song_Type` AS `Song_Type`,`song`.`Title` AS `Title`,`song`.`Hymnbook_Num` AS `Hymnbook_Num`,`song`.`Arranger` AS `Arranger`,(select max(`service`.`Svc_DateTime`) from ((`song` join `serviceevent` on((`song`.`Song_ID` = `serviceevent`.`Song_ID`))) join `service` on((`serviceevent`.`Service_ID` = `service`.`Service_ID`))) where ((`Song_IDM` = `song`.`Song_ID`) and (`song`.`Song_ID` = `serviceevent`.`Song_ID`) and (`serviceevent`.`Service_ID` = `service`.`Service_ID`))) AS `LastDateUsed` from ((`song` left join `serviceevent` on((`song`.`Song_ID` = `serviceevent`.`Song_ID`))) left join `service` on((`serviceevent`.`Service_ID` = `service`.`Service_ID`))) where (`song`.`Song_Type` = 'H') order by `service`.`Svc_DateTime`,`song`.`Title` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-04  1:56:54
