-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: phone_shop
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1,3,3,'2025-05-08 01:42:54'),(2,1,4,3,'2025-05-08 01:58:17'),(3,1,5,1,'2025-05-08 03:30:47');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_status` enum('Pending','Shipped','Delivered') NOT NULL,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `stock_quantity` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Apple iPhone 13',999.99,'The latest Apple iPhone 13 with 128GB storage, featuring the A15 Bionic chip and amazing camera performance.','images/products/iphone13.jpg','Phones','Apple',50,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(2,'Samsung Galaxy S21',799.99,'Samsung Galaxy S21 with 5G, 128GB storage, and a stunning AMOLED display.','images/products/galaxys21.jpg','Phones','Samsung',35,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(3,'Google Pixel 6',599.99,'Google Pixel 6 with Google Tensor, 128GB storage, and excellent camera features.','images/products/pixel6.jpg','Phones','Google',40,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(4,'OnePlus 9 Pro',969.99,'OnePlus 9 Pro with 120Hz Fluid AMOLED display, 256GB storage, and Snapdragon 888.','images/products/oneplus9pro.jpg','Phones','OnePlus',25,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(5,'Xiaomi Mi 11',749.99,'Xiaomi Mi 11 featuring 108MP camera, Snapdragon 888 chipset, and fast charging support.','images/products/mi11.jpg','Phones','Xiaomi',30,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(6,'Sony WH-1000XM4',349.99,'Sony WH-1000XM4 wireless noise-canceling headphones with superior sound quality and long battery life.','images/products/sonyheadphones.jpg','Accessories','Sony',60,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(7,'Apple AirPods Pro',249.99,'Apple AirPods Pro with active noise cancellation, sweat and water resistance, and superior sound quality.','images/products/airpodspro.jpg','Accessories','Apple',80,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(8,'Samsung Galaxy Buds Pro',199.99,'Samsung Galaxy Buds Pro with superior sound quality, active noise cancellation, and long battery life.','images/products/galaxybudspro.jpg','Accessories','Samsung',70,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(9,'iPad Air 4th Gen',599.99,'iPad Air 4th Gen with 10.9-inch display, Apple A14 Bionic chip, and 64GB storage.','images/products/ipad_air.jpg','Tablets','Apple',40,'2025-05-08 01:31:21','2025-05-08 01:31:21'),(10,'Samsung Galaxy Tab S7',649.99,'Samsung Galaxy Tab S7 with 11-inch display, Snapdragon 865+ chipset, and 128GB storage.','images/products/galaxytabs7.jpg','Tablets','Samsung',50,'2025-05-08 01:31:21','2025-05-08 01:31:21');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_address` varchar(255) DEFAULT NULL,
  `user_status` int DEFAULT '1',
  `user_type` enum('customer','employee','supplier','admin') DEFAULT 'customer',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'aaav','aaa','aaaa@gmail.com','1111','12345678','aaaa',1,'customer','2025-05-07 17:33:33','2025-05-08 01:23:59'),(2,'abc','abc','abc@gmail.com','12345','1234567890','aaaa',1,'customer','2025-05-07 19:04:43','2025-05-07 19:04:43'),(3,'aaqa','aaa','aaaa','aaa','aaa','aaa',1,'customer','2025-05-07 19:59:55','2025-05-07 19:59:55'),(4,'as','as','as@gmail.comddd','1234','1234567890','aaa',1,'customer','2025-05-07 20:01:41','2025-05-07 20:01:41'),(5,'admin','admin','admin@gmail.com','1234','1234567890','aaa',1,'admin','2025-05-07 20:04:31','2025-05-07 23:41:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-08  9:46:09
