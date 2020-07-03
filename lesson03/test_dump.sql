-- MySQL dump 10.13  Distrib 8.0.20, for Linux (x86_64)
--
-- Host: localhost    Database: social_network
-- ------------------------------------------------------
-- Server version	8.0.20-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `avatars`
--

DROP TABLE IF EXISTS `avatars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avatars` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avatars`
--

LOCK TABLES `avatars` WRITE;
/*!40000 ALTER TABLE `avatars` DISABLE KEYS */;
/*!40000 ALTER TABLE `avatars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` bigint unsigned NOT NULL,
  `post_id` bigint unsigned NOT NULL,
  `body` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `profile_id` (`profile_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend_requests` (
  `initiator_profile_id` bigint unsigned NOT NULL,
  `target_profile_id` bigint unsigned NOT NULL,
  `status` enum('requested','approved','unfriended','declined') DEFAULT NULL,
  `requested_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`initiator_profile_id`,`target_profile_id`),
  KEY `initiator_profile_id` (`initiator_profile_id`),
  KEY `target_profile_id` (`target_profile_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`initiator_profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`target_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_files`
--

DROP TABLE IF EXISTS `media_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_files` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` bigint unsigned NOT NULL,
  `path` varchar(255) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `type` enum('picture','audio','video') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `title` (`title`),
  KEY `profile_id` (`profile_id`),
  CONSTRAINT `media_files_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_files`
--

LOCK TABLES `media_files` WRITE;
/*!40000 ALTER TABLE `media_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_files_likes`
--

DROP TABLE IF EXISTS `media_files_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_files_likes` (
  `profile_id` bigint unsigned NOT NULL,
  `media_file_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`,`media_file_id`),
  KEY `media_file_id` (`media_file_id`),
  CONSTRAINT `media_files_likes_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `media_files_likes_ibfk_2` FOREIGN KEY (`media_file_id`) REFERENCES `media_files` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_files_likes`
--

LOCK TABLES `media_files_likes` WRITE;
/*!40000 ALTER TABLE `media_files_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_files_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `from_profile_id` bigint unsigned NOT NULL,
  `to_profile_id` bigint unsigned NOT NULL,
  `body` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `from_profile_id` (`from_profile_id`),
  KEY `to_profile_id` (`to_profile_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` bigint unsigned NOT NULL,
  `body` text,
  `attachments` json DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `parent_post_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `profile_id` (`profile_id`),
  KEY `parent_post_id` (`parent_post_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`parent_post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_likes`
--

DROP TABLE IF EXISTS `posts_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_likes` (
  `profile_id` bigint unsigned NOT NULL,
  `post_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`,`post_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `posts_likes_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `posts_likes_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_likes`
--

LOCK TABLES `posts_likes` WRITE;
/*!40000 ALTER TABLE `posts_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `avatar_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `hometown` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  KEY `avatar_id` (`avatar_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `profiles_ibfk_2` FOREIGN KEY (`avatar_id`) REFERENCES `avatars` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles_likes`
--

DROP TABLE IF EXISTS `profiles_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles_likes` (
  `profile_id` bigint unsigned NOT NULL,
  `target_profile_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`,`target_profile_id`),
  KEY `target_profile_id` (`target_profile_id`),
  CONSTRAINT `profiles_likes_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profiles_likes_ibfk_2` FOREIGN KEY (`target_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles_likes`
--

LOCK TABLES `profiles_likes` WRITE;
/*!40000 ALTER TABLE `profiles_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `profiles_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(50) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `users_phone_idx` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'teterinparfen','teterinparfen@mail.ru',79521567355),(2,'eremeponomarev','eremeponomarev@yahoo.com',79716912886),(3,'subbotinaverki','subbotinaverki@gmail.com',79585230145),(4,'noskovadrian','noskovadrian@mail.ru',79712093563),(5,'olimpimoiseev','olimpimoiseev@yahoo.com',79868461881),(6,'apollonevdokimov','apollonevdokimov@hotmail.com',79534445481),(7,'pfokina','pfokina@rambler.ru',79635929543),(8,'matve_36','matve_36@mail.ru',79607953644),(9,'panfilovamos','panfilovamos@rambler.ru',79699946856),(10,'nifontkrasilnikov','nifontkrasilnikov@hotmail.com',79991796293),(11,'zatsevaljudmila','zatsevaljudmila@hotmail.com',79516708464),(12,'firs95','firs95@hotmail.com',79954048495),(13,'bojanevdokimov','bojanevdokimov@yahoo.com',79961920519),(14,'osilina','osilina@mail.ru',79521636618),(15,'afinogen_1995','afinogen_1995@yandex.ru',79437827993),(16,'petr63','petr63@gmail.com',79650455791),(17,'rozhkovazinaida','rozhkovazinaida@hotmail.com',79253251739),(18,'evgenija_24','evgenija_24@yahoo.com',79245146305),(19,'kuzminuljan','kuzminuljan@yahoo.com',79277403702),(20,'julija_79','julija_79@yandex.ru',79376133439),(21,'zinovevarseni','zinovevarseni@gmail.com',79244009527),(22,'hpanfilova','hpanfilova@yahoo.com',79740100293),(23,'andronik1974','andronik1974@yandex.ru',79292708175),(24,'panfil_1970','panfil_1970@yahoo.com',79253680127),(25,'shirjaevljubosmisl','shirjaevljubosmisl@rambler.ru',79875630149),(26,'borisovaleksandr','borisovaleksandr@gmail.com',79719536782),(27,'longin2019','longin2019@gmail.com',79221226201),(28,'savinlev','savinlev@yandex.ru',79851816656),(29,'agafon_2002','agafon_2002@mail.ru',79696573557),(30,'angelina_60','angelina_60@yahoo.com',79908846556),(31,'polina_97','polina_97@gmail.com',79108546591),(32,'artemi_1979','artemi_1979@rambler.ru',79128163177),(33,'eleonora_43','eleonora_43@yandex.ru',79436947786),(34,'denisovnatan','denisovnatan@rambler.ru',79349565100),(35,'lavrentichernov','lavrentichernov@mail.ru',79868463227),(36,'bespalovdavid','bespalovdavid@yahoo.com',79703900804),(37,'isidorabramov','isidorabramov@yandex.ru',79706947463),(38,'qivanova','qivanova@yahoo.com',79379799812),(39,'konovalovguri','konovalovguri@mail.ru',79730933526),(40,'gostomisl2002','gostomisl2002@hotmail.com',79875841626),(41,'sila09','sila09@hotmail.com',79930261094),(42,'shubinavde','shubinavde@mail.ru',79167658431),(43,'evlampi43','evlampi43@hotmail.com',79471428279),(44,'gavrilovandron','gavrilovandron@gmail.com',79670468385),(45,'velimirnazarov','velimirnazarov@gmail.com',79317115071),(46,'poljakovvladislav','poljakovvladislav@yandex.ru',79580168842),(47,'vishnjakovemmanuil','vishnjakovemmanuil@yahoo.com',79234020911),(48,'iraklimarkov','iraklimarkov@yahoo.com',79161822762),(49,'praskovja2014','praskovja2014@gmail.com',79179626952),(50,'shubinnikita','shubinnikita@yandex.ru',79348772149),(51,'anisimovaraisa','anisimovaraisa@hotmail.com',79532344330),(52,'onufri_1986','onufri_1986@yandex.ru',79402321321),(53,'epifan_23','epifan_23@mail.ru',79759812422),(54,'wrodionov','wrodionov@rambler.ru',79167984025),(55,'wzhuravlev','wzhuravlev@hotmail.com',79281902189),(56,'belovaninel','belovaninel@yahoo.com',79448456092),(57,'feofan_48','feofan_48@rambler.ru',79912452004),(58,'savinonufri','savinonufri@yandex.ru',79977297594),(59,'vorobevvarfolome','vorobevvarfolome@gmail.com',79875172681),(60,'ipat_89','ipat_89@mail.ru',79786092839),(61,'ivanna_03','ivanna_03@rambler.ru',79488614725),(62,'rpestov','rpestov@yandex.ru',79687533484),(63,'mefodidanilov','mefodidanilov@gmail.com',79763043668),(64,'savvavladimirov','savvavladimirov@yahoo.com',79425366740),(65,'qvorobeva','qvorobeva@yahoo.com',79819226269),(66,'maksimiljan_1975','maksimiljan_1975@yahoo.com',79788348297),(67,'juvenali84','juvenali84@yandex.ru',79286005188),(68,'natalja09','natalja09@rambler.ru',79366556149),(69,'vitali2000','vitali2000@hotmail.com',79687392388),(70,'milovan_2007','milovan_2007@rambler.ru',79799852980),(71,'eduardgrigorev','eduardgrigorev@rambler.ru',79503160415),(72,'iraklilitkin','iraklilitkin@rambler.ru',79337403364),(73,'larisa_2014','larisa_2014@gmail.com',79827095497),(74,'jfokin','jfokin@yandex.ru',79455358722),(75,'sidor1981','sidor1981@yandex.ru',79407392455),(76,'tit_74','tit_74@hotmail.com',79139028679),(77,'arefi_91','arefi_91@yandex.ru',79339774329),(78,'lidija86','lidija86@mail.ru',79616890437),(79,'shirjaevsidor','shirjaevsidor@rambler.ru',79393977234),(80,'egor53','egor53@mail.ru',79623312945),(81,'rozhkovpankrati','rozhkovpankrati@rambler.ru',79383359300),(82,'tarasovanadezhda','tarasovanadezhda@gmail.com',79635949343),(83,'jakovlevtaras','jakovlevtaras@yandex.ru',79166102948),(84,'vasili1992','vasili1992@hotmail.com',79440826847),(85,'zhuravlevazoja','zhuravlevazoja@yahoo.com',79269737444),(86,'fadeevauljana','fadeevauljana@mail.ru',79573909421),(87,'svjatopolk_85','svjatopolk_85@yandex.ru',79439534864),(88,'kornil2007','kornil2007@rambler.ru',79443764191),(89,'noskovostromir','noskovostromir@hotmail.com',79764873414),(90,'seliverst_39','seliverst_39@rambler.ru',79656658634),(91,'paramonlitkin','paramonlitkin@gmail.com',79384760526),(92,'porfiri90','porfiri90@yandex.ru',79949124099),(93,'radim58','radim58@gmail.com',79981043147),(94,'taisija_25','taisija_25@yahoo.com',79495492870),(95,'zhanna16','zhanna16@rambler.ru',79820087197),(96,'muravevjaroslav','muravevjaroslav@yahoo.com',79499863048),(97,'silinanatalja','silinanatalja@rambler.ru',79555832778),(98,'gerasimovporfiri','gerasimovporfiri@yandex.ru',79587942163),(99,'kondrativoronov','kondrativoronov@yandex.ru',79718359024),(100,'sokolovsokrat','sokolovsokrat@mail.ru',79110653960),(101,'kborisov','kborisov@yahoo.com',79257398188),(102,'evseevpimen','evseevpimen@gmail.com',79845821779),(103,'mamontovemmanuil','mamontovemmanuil@mail.ru',79707812704),(104,'ziminprokofi','ziminprokofi@yandex.ru',79417920597),(105,'denisovakira','denisovakira@mail.ru',79769587663),(106,'kapiton_2007','kapiton_2007@gmail.com',79877103570),(107,'emeljan1975','emeljan1975@mail.ru',79157622128),(108,'emeljan_1991','emeljan_1991@rambler.ru',79617105613),(109,'lebedevarseni','lebedevarseni@yahoo.com',79373151087),(110,'bikovasvetlana','bikovasvetlana@gmail.com',79199200612),(111,'isidor_44','isidor_44@gmail.com',79576623249),(112,'qpoljakov','qpoljakov@rambler.ru',79707967287),(113,'iraida33','iraida33@mail.ru',79661869123),(114,'romanovaalina','romanovaalina@yahoo.com',79545949861),(115,'rtarasova','rtarasova@mail.ru',79938827733),(116,'izjaslav14','izjaslav14@rambler.ru',79605845360),(117,'kondratevmoke','kondratevmoke@yahoo.com',79761737517),(118,'tbirjukova','tbirjukova@hotmail.com',79789364219),(119,'timofeevapraskovja','timofeevapraskovja@rambler.ru',79430518742),(120,'korolevasvetlana','korolevasvetlana@gmail.com',79673118449),(121,'uljan_1987','uljan_1987@hotmail.com',79994061538),(122,'avtonommaslov','avtonommaslov@gmail.com',79252728532),(123,'vjacheslav65','vjacheslav65@gmail.com',79880326620),(124,'sofija2018','sofija2018@gmail.com',79322503573),(125,'potapovfoka','potapovfoka@rambler.ru',79145812434),(126,'paramon_34','paramon_34@hotmail.com',79240785536),(127,'oksana_2017','oksana_2017@rambler.ru',79640010401),(128,'moke_74','moke_74@yandex.ru',79762484635),(129,'evfrosinija70','evfrosinija70@hotmail.com',79537898098),(130,'jan2001','jan2001@hotmail.com',79807989648),(131,'nfomin','nfomin@yandex.ru',79449357792),(132,'milan_1981','milan_1981@yandex.ru',79635227976),(133,'maksim1995','maksim1995@gmail.com',79721152643),(134,'krjukovavarvara','krjukovavarvara@gmail.com',79829123637),(135,'askold_76','askold_76@yandex.ru',79757054457),(136,'apollinari_1997','apollinari_1997@yahoo.com',79161241075),(137,'potapovdobroslav','potapovdobroslav@yandex.ru',79942459519),(138,'shubinnikola','shubinnikola@gmail.com',79888146949),(139,'gremislav_1985','gremislav_1985@hotmail.com',79357315646),(140,'gostomisl66','gostomisl66@rambler.ru',79637540882),(141,'yefimova','yefimova@yahoo.com',79862378569),(142,'samsonovaekaterina','samsonovaekaterina@yandex.ru',79237562267),(143,'hristofor_2005','hristofor_2005@mail.ru',79656135444),(144,'parfen_2011','parfen_2011@rambler.ru',79210466740),(145,'denis_73','denis_73@mail.ru',79170958457),(146,'boleslav1983','boleslav1983@yandex.ru',79555291391),(147,'dobroslav87','dobroslav87@rambler.ru',79163276246),(148,'lukaignatov','lukaignatov@yahoo.com',79650874752),(149,'zhukovignati','zhukovignati@yahoo.com',79544334208),(150,'ofrolova','ofrolova@rambler.ru',79341150442),(151,'osipovmaksim','osipovmaksim@gmail.com',79667107135),(152,'blohinadrian','blohinadrian@rambler.ru',79805845114),(153,'stepanovsvetozar','stepanovsvetozar@hotmail.com',79383466803),(154,'fominagap','fominagap@gmail.com',79323167480),(155,'uljana1970','uljana1970@yahoo.com',79597349199),(156,'jurikuznetsov','jurikuznetsov@mail.ru',79998135891),(157,'konstantinovaviktorija','konstantinovaviktorija@yandex.ru',79813008589),(158,'isakovelise','isakovelise@yahoo.com',79356205567),(159,'maksim_1983','maksim_1983@yahoo.com',79444069982),(160,'evgenija2000','evgenija2000@rambler.ru',79241237609),(161,'samson07','samson07@gmail.com',79709674114),(162,'tihonovfirs','tihonovfirs@yandex.ru',79828115760),(163,'anzhelika_53','anzhelika_53@hotmail.com',79343730065),(164,'evfrosinija_1971','evfrosinija_1971@gmail.com',79225040853),(165,'dorofeevamarfa','dorofeevamarfa@yahoo.com',79899297122),(166,'anike_49','anike_49@hotmail.com',79668183938),(167,'nmartinov','nmartinov@yahoo.com',79614102289),(168,'evdokim_1976','evdokim_1976@yandex.ru',79466871711),(169,'muhinaelizaveta','muhinaelizaveta@yandex.ru',79884212237),(170,'kapiton2015','kapiton2015@hotmail.com',79669251955),(171,'ignatevpavel','ignatevpavel@rambler.ru',79680711805),(172,'adam_2004','adam_2004@gmail.com',79298516955),(173,'ovchinnikovsilanti','ovchinnikovsilanti@gmail.com',79818228544),(174,'visheslav_1993','visheslav_1993@rambler.ru',79756065365),(175,'bmiheeva','bmiheeva@gmail.com',79351427822),(176,'morozovfilimon','morozovfilimon@gmail.com',79227909212),(177,'dobroslav2008','dobroslav2008@gmail.com',79536963222),(178,'koshelevsvjatoslav','koshelevsvjatoslav@rambler.ru',79122350681),(179,'glafira_26','glafira_26@gmail.com',79255569318),(180,'jan_72','jan_72@mail.ru',79895957615),(181,'anikita_1999','anikita_1999@gmail.com',79590961354),(182,'ponomarevafaina','ponomarevafaina@mail.ru',79614579291),(183,'matve_2009','matve_2009@hotmail.com',79930425228),(184,'cdrozdov','cdrozdov@rambler.ru',79212381047),(185,'nifont_1984','nifont_1984@rambler.ru',79694634083),(186,'kapustinonufri','kapustinonufri@hotmail.com',79690937066),(187,'umelnikov','umelnikov@yandex.ru',79296425824),(188,'fedotovanaina','fedotovanaina@gmail.com',79178657181),(189,'rozhkovnaum','rozhkovnaum@yahoo.com',79159005456),(190,'afinogen54','afinogen54@hotmail.com',79395212575),(191,'rubensafonov','rubensafonov@yahoo.com',79238456349),(192,'savinaanzhelika','savinaanzhelika@yandex.ru',79734264178),(193,'natalja_2000','natalja_2000@yahoo.com',79339366463),(194,'svjatopolk_1978','svjatopolk_1978@rambler.ru',79652125106),(195,'marija_90','marija_90@hotmail.com',79103388613),(196,'sisoevrodion','sisoevrodion@yandex.ru',79840877473),(197,'innokenti60','innokenti60@yandex.ru',79973743541),(198,'averjan_52','averjan_52@mail.ru',79468759868),(199,'tarasovkir','tarasovkir@mail.ru',79204335447),(200,'jgerasimov','jgerasimov@gmail.com',79169880973);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_communities`
--

DROP TABLE IF EXISTS `users_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_communities` (
  `profile_id` bigint unsigned NOT NULL,
  `community_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`profile_id`,`community_id`),
  KEY `community_id` (`community_id`),
  CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `users_communities_ibfk_2` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_communities`
--

LOCK TABLES `users_communities` WRITE;
/*!40000 ALTER TABLE `users_communities` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_communities` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-03 15:20:24
