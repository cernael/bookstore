-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Värd: 127.0.0.1
-- Skapad: 25 nov 2013 kl 14:16
-- Serverversion: 5.5.32
-- PHP-version: 5.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databas: `bookstore_db`
--
CREATE DATABASE IF NOT EXISTS `bookstore_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `bookstore_db`;

-- --------------------------------------------------------

--
-- Tabellstruktur `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `ISBN` varchar(13) NOT NULL,
  `title` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `publishing_year` varchar(20) NOT NULL,
  `shelf_id` int(11) NOT NULL,
  `inventory` int(11) NOT NULL,
  `language` varchar(30) NOT NULL,
  PRIMARY KEY (`article_id`),
  KEY `shelf_id` (`shelf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=125 ;

--
-- Dumpning av Data i tabell `articles`
--

INSERT INTO `articles` (`article_id`, `ISBN`, `title`, `publisher`, `publishing_year`, `shelf_id`, `inventory`, `language`) VALUES
(123, '0987654321', 'Misery', 'Stephen King', '1985', 31, 2, 'Eng'),
(124, '0984854321', 'Sagan om ringen', 'J.R:R Tolkien', '1989', 30, 4, 'SVE');

-- --------------------------------------------------------

--
-- Tabellstruktur `article_category`
--

CREATE TABLE IF NOT EXISTS `article_category` (
  `article_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  KEY `article_id` (`article_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `authors`
--

CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` int(11) NOT NULL AUTO_INCREMENT,
  `author_first_name` varchar(30) NOT NULL,
  `author_last_name` varchar(30) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `book_author`
--

CREATE TABLE IF NOT EXISTS `book_author` (
  `author_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  KEY `author_id` (`author_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(30) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `employees`
--

CREATE TABLE IF NOT EXISTS `employees` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_first_name` varchar(30) NOT NULL,
  `employee_last_namme` varchar(30) NOT NULL,
  PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `inventory_event`
--

CREATE TABLE IF NOT EXISTS `inventory_event` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('sale','add','change') NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `employee_id` int(11) NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `line_item`
--

CREATE TABLE IF NOT EXISTS `line_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `event_id` (`event_id`,`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `prices`
--

CREATE TABLE IF NOT EXISTS `prices` (
  `price_id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `F-pris` decimal(7,2) NOT NULL,
  `price` decimal(7,2) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`price_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `shelves`
--

CREATE TABLE IF NOT EXISTS `shelves` (
  `shelf_id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `shelf_name` varchar(20) NOT NULL,
  PRIMARY KEY (`shelf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Dumpning av Data i tabell `shelves`
--

INSERT INTO `shelves` (`shelf_id`, `x`, `y`, `shelf_name`) VALUES
(30, 140, 300, 'A'),
(31, 13, 20, 'B'),
(32, 54, 87, 'C');

--
-- Restriktioner för dumpade tabeller
--

--
-- Restriktioner för tabell `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `shelflink` FOREIGN KEY (`shelf_id`) REFERENCES `shelves` (`shelf_id`);

--
-- Restriktioner för tabell `article_category`
--
ALTER TABLE `article_category`
  ADD CONSTRAINT `categorylink` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `articlelink2` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`);

--
-- Restriktioner för tabell `book_author`
--
ALTER TABLE `book_author`
  ADD CONSTRAINT `articlelink` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `authorlink` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`);

--
-- Restriktioner för tabell `inventory_event`
--
ALTER TABLE `inventory_event`
  ADD CONSTRAINT `employeelink` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);

--
-- Restriktioner för tabell `prices`
--
ALTER TABLE `prices`
  ADD CONSTRAINT `pricelink` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
