-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2013 at 02:29 PM
-- Server version: 5.5.32
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bookstore_db`
--
CREATE DATABASE IF NOT EXISTS `bookstore_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `bookstore_db`;

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `isbn` varchar(13) NOT NULL,
  `title` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `publishing_year` varchar(20) NOT NULL,
  `shelf_id` int(11) NOT NULL,
  `inventory` int(11) NOT NULL,
  `language` varchar(30) NOT NULL,
  PRIMARY KEY (`article_id`),
  KEY `shelf_id` (`shelf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=129 ;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`article_id`, `isbn`, `title`, `publisher`, `publishing_year`, `shelf_id`, `inventory`, `language`) VALUES
(125, '9780596804374', 'PHP: The Good Parts', 'O''Reilly Media Inc.', '2010', 30, 1, 'English'),
(126, '9781430249320', 'Beginning JQuery', 'Apress', '2013', 30, 1, 'English'),
(127, '9781847194145', 'Object-Oriented JavaScript', 'Packt Publishing Ltd.', '2008', 30, 1, 'English'),
(128, '9789188316165', 'In i musiken', 'Bo Ejeby Förlag', '1987', 31, 1, 'Svenska');

-- --------------------------------------------------------

--
-- Table structure for table `article_category`
--

CREATE TABLE IF NOT EXISTS `article_category` (
  `article_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  KEY `article_id` (`article_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `article_category`
--

INSERT INTO `article_category` (`article_id`, `category_id`) VALUES
(125, 2),
(126, 2),
(127, 2),
(128, 1);

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` int(11) NOT NULL AUTO_INCREMENT,
  `author_first_name` varchar(30) NOT NULL,
  `author_last_name` varchar(30) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`author_id`, `author_first_name`, `author_last_name`) VALUES
(1, 'Peter B.', 'MacIntyre'),
(2, 'Jack', 'Franklin'),
(3, 'Stoyan', 'Stefanov'),
(4, 'Peter', 'Bastian');

-- --------------------------------------------------------

--
-- Table structure for table `book_author`
--

CREATE TABLE IF NOT EXISTS `book_author` (
  `author_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  KEY `author_id` (`author_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `book_author`
--

INSERT INTO `book_author` (`author_id`, `article_id`) VALUES
(1, 125),
(2, 126),
(3, 127),
(4, 128);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(30) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'music'),
(2, 'programming');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE IF NOT EXISTS `employees` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_first_name` varchar(30) NOT NULL,
  `employee_last_namme` varchar(30) NOT NULL,
  PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `employee_first_name`, `employee_last_namme`) VALUES
(1, 'Karl Kristian', 'Kalashnikov');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_event`
--

CREATE TABLE IF NOT EXISTS `inventory_event` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('sale','add','change') NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `employee_id` int(11) NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `inventory_event`
--

INSERT INTO `inventory_event` (`event_id`, `type`, `date`, `employee_id`) VALUES
(1, 'add', '2013-12-03 13:16:43', 1),
(2, 'sale', '2013-12-03 13:17:58', 1);

-- --------------------------------------------------------

--
-- Table structure for table `line_item`
--

CREATE TABLE IF NOT EXISTS `line_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `event_id` (`event_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `line_item`
--

INSERT INTO `line_item` (`item_id`, `event_id`, `article_id`, `amount`) VALUES
(1, 1, 125, 1),
(2, 1, 126, 1),
(3, 1, 127, 1),
(4, 1, 128, 2),
(5, 2, 128, 1);

-- --------------------------------------------------------

--
-- Table structure for table `prices`
--

CREATE TABLE IF NOT EXISTS `prices` (
  `price_id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `f_pris` decimal(7,2) NOT NULL,
  `price` decimal(7,2) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`price_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `prices`
--

INSERT INTO `prices` (`price_id`, `article_id`, `f_pris`, `price`, `date`) VALUES
(1, 125, '170.00', '249.00', '2013-12-02'),
(2, 126, '150.00', '219.00', '2013-12-03'),
(3, 127, '200.00', '299.00', '2013-12-03'),
(4, 128, '50.00', '69.00', '2013-12-03'),
(5, 125, '150.00', '159.00', '2013-12-03');

-- --------------------------------------------------------

--
-- Table structure for table `shelves`
--

CREATE TABLE IF NOT EXISTS `shelves` (
  `shelf_id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `shelf_name` varchar(20) NOT NULL,
  PRIMARY KEY (`shelf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `shelves`
--

INSERT INTO `shelves` (`shelf_id`, `x`, `y`, `shelf_name`) VALUES
(30, 140, 300, 'A'),
(31, 13, 20, 'B'),
(32, 54, 87, 'C');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `shelflink` FOREIGN KEY (`shelf_id`) REFERENCES `shelves` (`shelf_id`);

--
-- Constraints for table `article_category`
--
ALTER TABLE `article_category`
  ADD CONSTRAINT `articlelink2` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `categorylink` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `book_author`
--
ALTER TABLE `book_author`
  ADD CONSTRAINT `articlelink` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `authorlink` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`);

--
-- Constraints for table `inventory_event`
--
ALTER TABLE `inventory_event`
  ADD CONSTRAINT `employeelink` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);

--
-- Constraints for table `line_item`
--
ALTER TABLE `line_item`
  ADD CONSTRAINT `line_item` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `eventlink` FOREIGN KEY (`event_id`) REFERENCES `inventory_event` (`event_id`);

--
-- Constraints for table `prices`
--
ALTER TABLE `prices`
  ADD CONSTRAINT `pricelink` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
