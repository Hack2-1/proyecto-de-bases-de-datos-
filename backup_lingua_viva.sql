este es el backup que se pedia en el proyecto


MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: lingua_viva_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `ID_Administrador` int NOT NULL AUTO_INCREMENT,
  `Nivel_Permisos` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ID_Usuario` int NOT NULL,
  PRIMARY KEY (`ID_Administrador`),
  KEY `ID_Usuario` (`ID_Usuario`),
  CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `usuario` (`ID_Usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,'Total',1);
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumno`
--

DROP TABLE IF EXISTS `alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno` (
  `ID_Alumno` int NOT NULL AUTO_INCREMENT,
  `Nivel_Idioma` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Estado_Activo` tinyint(1) DEFAULT '1',
  `ID_Usuario` int NOT NULL,
  `ID_Grupo` int NOT NULL,
  PRIMARY KEY (`ID_Alumno`),
  KEY `ID_Usuario` (`ID_Usuario`),
  KEY `ID_Grupo` (`ID_Grupo`),
  CONSTRAINT `alumno_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `usuario` (`ID_Usuario`) ON DELETE CASCADE,
  CONSTRAINT `alumno_ibfk_2` FOREIGN KEY (`ID_Grupo`) REFERENCES `grupo` (`ID_Grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno`
--

LOCK TABLES `alumno` WRITE;
/*!40000 ALTER TABLE `alumno` DISABLE KEYS */;
INSERT INTO `alumno` VALUES (1,'B2',1,3,1);
/*!40000 ALTER TABLE `alumno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso`
--

DROP TABLE IF EXISTS `curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso` (
  `ID_Curso` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descripcion` text COLLATE utf8mb4_unicode_ci,
  `Idioma` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Nivel` enum('Básico','Intermedio','Avanzado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `Estado_Activo` tinyint(1) DEFAULT '1',
  `Id_Horario` int DEFAULT NULL,
  PRIMARY KEY (`ID_Curso`),
  KEY `fk_curso_horario` (`Id_Horario`),
  CONSTRAINT `fk_curso_horario` FOREIGN KEY (`Id_Horario`) REFERENCES `horario` (`ID_Horario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso`
--

LOCK TABLES `curso` WRITE;
/*!40000 ALTER TABLE `curso` DISABLE KEYS */;
INSERT INTO `curso` VALUES (1,'Inglés Intensivo','Curso de preparación TOEFL','Inglés','Avanzado',1,1);
/*!40000 ALTER TABLE `curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grupo`
--

DROP TABLE IF EXISTS `grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupo` (
  `ID_Grupo` int NOT NULL AUTO_INCREMENT,
  `Cupo_Maximo` int NOT NULL,
  `Fecha_Inicio` date NOT NULL,
  `Fecha_Fin` date NOT NULL,
  `Estado_Activo` tinyint(1) DEFAULT '1',
  `ID_Curso` int NOT NULL,
  PRIMARY KEY (`ID_Grupo`),
  KEY `ID_Curso` (`ID_Curso`),
  CONSTRAINT `grupo_ibfk_1` FOREIGN KEY (`ID_Curso`) REFERENCES `curso` (`ID_Curso`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupo`
--

LOCK TABLES `grupo` WRITE;
/*!40000 ALTER TABLE `grupo` DISABLE KEYS */;
INSERT INTO `grupo` VALUES (1,20,'2026-06-01','2026-12-01',1,1);
/*!40000 ALTER TABLE `grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario`
--

DROP TABLE IF EXISTS `horario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario` (
  `ID_Horario` int NOT NULL AUTO_INCREMENT,
  `Hora_Inicio` time NOT NULL,
  `Hora_Fin` time NOT NULL,
  `ID_Grupo` int NOT NULL,
  PRIMARY KEY (`ID_Horario`),
  KEY `ID_Grupo` (`ID_Grupo`),
  CONSTRAINT `horario_ibfk_1` FOREIGN KEY (`ID_Grupo`) REFERENCES `grupo` (`ID_Grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario`
--

LOCK TABLES `horario` WRITE;
/*!40000 ALTER TABLE `horario` DISABLE KEYS */;
INSERT INTO `horario` VALUES (1,'08:00:00','10:00:00',1);
/*!40000 ALTER TABLE `horario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario_dia`
--

DROP TABLE IF EXISTS `horario_dia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario_dia` (
  `ID_Horario` int NOT NULL,
  `Dia_Semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Horario`,`Dia_Semana`),
  CONSTRAINT `horario_dia_ibfk_1` FOREIGN KEY (`ID_Horario`) REFERENCES `horario` (`ID_Horario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario_dia`
--

LOCK TABLES `horario_dia` WRITE;
/*!40000 ALTER TABLE `horario_dia` DISABLE KEYS */;
INSERT INTO `horario_dia` VALUES (1,'Lunes'),(1,'Miércoles'),(1,'Viernes');
/*!40000 ALTER TABLE `horario_dia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripcion`
--

DROP TABLE IF EXISTS `inscripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripcion` (
  `ID_Inscripcion` int NOT NULL AUTO_INCREMENT,
  `Fecha_Registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `Estado_Academico` enum('Cursando','Aprobado','Baja') COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_Alumno` int NOT NULL,
  PRIMARY KEY (`ID_Inscripcion`),
  KEY `Id_Alumno` (`Id_Alumno`),
  CONSTRAINT `inscripcion_ibfk_1` FOREIGN KEY (`Id_Alumno`) REFERENCES `alumno` (`ID_Alumno`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripcion`
--

LOCK TABLES `inscripcion` WRITE;
/*!40000 ALTER TABLE `inscripcion` DISABLE KEYS */;
INSERT INTO `inscripcion` VALUES (1,'2026-05-11 10:10:29','Cursando',1);
/*!40000 ALTER TABLE `inscripcion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `ID_Pago` int NOT NULL AUTO_INCREMENT,
  `Monto` decimal(10,2) NOT NULL,
  `Fecha_Pago` date NOT NULL,
  `Metodo_Pago` enum('Efectivo','Transferencia','Tarjeta') COLLATE utf8mb4_unicode_ci NOT NULL,
  `Folio_Recibo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ID_Inscripcion` int NOT NULL,
  PRIMARY KEY (`ID_Pago`),
  UNIQUE KEY `Folio_Recibo` (`Folio_Recibo`),
  KEY `ID_Inscripcion` (`ID_Inscripcion`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`ID_Inscripcion`) REFERENCES `inscripcion` (`ID_Inscripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (1,1500.00,'2026-05-10','Transferencia','TRX-998877',1);
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesor`
--

DROP TABLE IF EXISTS `profesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesor` (
  `ID_Profesor` int NOT NULL AUTO_INCREMENT,
  `ID_Usuario` int NOT NULL,
  `Id_Curso` int NOT NULL,
  PRIMARY KEY (`ID_Profesor`),
  KEY `ID_Usuario` (`ID_Usuario`),
  KEY `Id_Curso` (`Id_Curso`),
  CONSTRAINT `profesor_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `usuario` (`ID_Usuario`) ON DELETE CASCADE,
  CONSTRAINT `profesor_ibfk_2` FOREIGN KEY (`Id_Curso`) REFERENCES `curso` (`ID_Curso`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesor`
--

LOCK TABLES `profesor` WRITE;
/*!40000 ALTER TABLE `profesor` DISABLE KEYS */;
INSERT INTO `profesor` VALUES (1,2,1);
/*!40000 ALTER TABLE `profesor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesor_idioma`
--

DROP TABLE IF EXISTS `profesor_idioma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesor_idioma` (
  `ID_Profesor` int NOT NULL,
  `Idioma` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Profesor`,`Idioma`),
  CONSTRAINT `profesor_idioma_ibfk_1` FOREIGN KEY (`ID_Profesor`) REFERENCES `profesor` (`ID_Profesor`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesor_idioma`
--

LOCK TABLES `profesor_idioma` WRITE;
/*!40000 ALTER TABLE `profesor_idioma` DISABLE KEYS */;
INSERT INTO `profesor_idioma` VALUES (1,'Francés'),(1,'Inglés');
/*!40000 ALTER TABLE `profesor_idioma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `ID_Usuario` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Apellidos` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Direccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Rol` enum('Administrador','Profesor','Alumno') COLLATE utf8mb4_unicode_ci NOT NULL,
  `Nombre_Usuario` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Contraseña` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Estado_Activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ID_Usuario`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Nombre_Usuario` (`Nombre_Usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Jesús Ángel','Valero Izaguirre','2281000001','admin@linguaviva.edu','Centro, Xalapa','Administrador','admin','12345',1),(2,'Jorge Gael','Hernández Marcial','2281000002','profesor@linguaviva.edu','Banderilla','Profesor','profe_gael','12345',1),(3,'Eddi Michael','Rodríguez Hernández','2281000003','eddi@estudiante.edu','Zacatal','Alumno','alumno_eddi','12345',1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 10:46:34
