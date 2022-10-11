-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 11, 2022 at 03:27 AM
-- Server version: 8.0.30
-- PHP Version: 7.4.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `koperasi`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_additemtemp` (`prmNoOrder` VARCHAR(50), `prmKodeProduk` VARCHAR(225))   BEGIN
	DECLARE xItemNo INT(3);
	DECLARE xSatuan INT(11);
	DECLARE xidProduk INT(11);
	SET xItemNo = (SELECT MAX(ItemNo) FROM trorderdt_temp WHERE NoOrder = prmNoOrder);
	select Satuan, Id into xSatuan, xidProduk from msproduk WHERE KodeProduk = prmKodeProduk;
	INSERT INTO trorderdt_temp(NoOrder, ItemNo, IdProduk, Satuan, Harga, TanggalExp, Qty, TotalHarga, Catatan)
	VALUES(prmNoOrder, coalesce(xItemNo, 0) + 1, xidProduk, xSatuan, '0', '1999-01-01', '1','0', '-' );
	select "1" as xStatus, "Success" as xMsg;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_order_add` (`prmDate` DATE, `prmVendor` INT(11), `prmPlace` INT(11), `prmRemark` VARCHAR(500), `prmGuideNo` VARCHAR(100), `prmUserId` VARCHAR(225))   BEGIN
	declare xTransNmbr varchar(100);
	set xTransNmbr = (select NoOrder from trorderhd order by NoOrder desc limit 1);
	set xTransNmbr = (SELECT CONCAT("ODR", RIGHT(YEAR(NOW()), 2), MONTH(NOW()), '-', LPAD((RIGHT(coalesce(xTransNmbr, "000"), 5) + 1), 5, '0')));
	INSERT INTO trorderhd(NoOrder, TanggalOrder, Vendor, Place, `Status`, TotalItem, TotalHarga, Catatan, FgActive, CreatedBy, CreatedDate)
	values(xTransNmbr, prmDate, prmVendor, prmPlace, "NEW", "0", "0", prmRemark, "Y", prmUserId, now());
	
	INSERT INTO trorderdt(NoOrder, ItemNo, IdProduk, Satuan, Harga, TanggalExp, Qty, 
	FgRO, FgPO, FgActive, TotalHarga, Catatan, CreatedBy, CreatedDate)
	SELECT xTransNmbr, ItemNo, IdProduk, Satuan, Harga, TanggalExp, Qty, "N", "N", "Y", TotalHarga, Catatan, prmUserId, now()
	FROM trorderdt_temp WHERE NoOrder = prmGuideNo;
	delete from trorderdt_temp where NoOrder = prmGuideNo;
	select "1" as xStatus, "Success" as xMsg;
	
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_order_submit_do` (`prmNoOrder` VARCHAR(225), `prmUserId` VARCHAR(225), `prmRemark` VARCHAR(500))   BEGIN
	insert into trorderlog(NoOrder, TypeLog, Catatan, CreatedBy, CreatedDate)
	values(prmNoOrder, "DO", prmRemark, prmUserId, now());
	##UPDATE trorderdt SET FgPO = 'Y' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	UPDATE trorderhd SET `Status` = 'DONE' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	select "1" as xStatus, "Success" as xMsg;
	
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_order_submit_po` (`prmNoOrder` VARCHAR(225), `prmUserId` VARCHAR(225), `prmRemark` VARCHAR(500))   BEGIN
	insert into trorderlog(NoOrder, TypeLog, Catatan, CreatedBy, CreatedDate)
	values(prmNoOrder, "PO", prmRemark, prmUserId, now());
	UPDATE trorderdt SET FgPO = 'Y' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	UPDATE trorderhd SET `Status` = 'PO' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	select "1" as xStatus, "Success" as xMsg;
	
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_order_submit_ro` (`prmNoOrder` VARCHAR(225), `prmUserId` VARCHAR(225), `prmRemark` VARCHAR(500))   BEGIN
	insert into trorderlog(NoOrder, TypeLog, Catatan, CreatedBy, CreatedDate)
	values(prmNoOrder, "RO", prmRemark, prmUserId, now());
	UPDATE trorderdt SET FgRO = 'Y' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	UPDATE trorderhd SET `Status` = 'RO' WHERE NoOrder = prmNoOrder AND FgActive = 'Y';
	select "1" as xStatus, "Success" as xMsg;
	
	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mshargaproduk`
--

CREATE TABLE `mshargaproduk` (
  `Id` int NOT NULL,
  `IdPlace` int DEFAULT NULL,
  `IdProduk` int DEFAULT NULL,
  `MulaiEfektif` datetime DEFAULT NULL,
  `SelesaiEfektif` datetime DEFAULT NULL,
  `HargaBeli` double(18,2) DEFAULT NULL,
  `MarkUp` double(18,2) DEFAULT NULL,
  `HargaJual` double(18,2) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mshargaproduk`
--

INSERT INTO `mshargaproduk` (`Id`, `IdPlace`, `IdProduk`, `MulaiEfektif`, `SelesaiEfektif`, `HargaBeli`, `MarkUp`, `HargaJual`, `Catatan`, `CreatedBy`, `CreatedDate`) VALUES
(1, 1, 1, '2022-01-15 00:00:00', '2022-01-25 00:00:00', 2500.00, 100.00, 2600.00, NULL, '1', '2022-09-29 17:21:18'),
(2, 1, 1, '2022-01-25 00:00:00', '2022-02-15 00:00:00', 120000.00, 20000.00, 140000.00, NULL, '1', '2022-09-29 17:21:46'),
(3, 1, 1, '2022-02-15 00:00:00', '2022-03-20 00:00:00', 2500.00, 250.00, 2750.00, NULL, '1', '2022-09-29 17:22:39'),
(4, 1, 1, '2022-03-20 00:00:00', '2022-08-02 00:00:00', 120000.00, 30000.00, 150000.00, NULL, '1', '2022-09-29 17:23:21'),
(5, 1, 1, '2022-08-02 00:00:00', NULL, 2500.00, 600.00, 3100.00, NULL, '1', '2022-09-29 17:23:50');

-- --------------------------------------------------------

--
-- Table structure for table `msjenisproduk`
--

CREATE TABLE `msjenisproduk` (
  `id` int NOT NULL,
  `JenisProduk` varchar(225) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msjenisproduk`
--

INSERT INTO `msjenisproduk` (`id`, `JenisProduk`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`) VALUES
(1, 'Susu Bubuk', NULL, 'Y', '1', '2022-09-29 16:58:29'),
(2, 'Susu Cair', NULL, 'Y', '1', '2022-09-29 16:58:53'),
(3, 'Mie Instant', NULL, 'Y', '1', '2022-09-29 16:59:03'),
(4, 'Rokok', NULL, 'Y', '1', '2022-09-29 16:59:17');

-- --------------------------------------------------------

--
-- Table structure for table `mskeanggotaan`
--

CREATE TABLE `mskeanggotaan` (
  `Id` int NOT NULL,
  `Keanggotaan` varchar(225) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mskeanggotaan`
--

INSERT INTO `mskeanggotaan` (`Id`, `Keanggotaan`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`) VALUES
(1, 'Pusat', '-', 'Y', NULL, NULL),
(2, 'Cabang', '-', 'Y', NULL, NULL),
(3, 'Anggota', '-', 'Y', NULL, NULL),
(4, 'Normal', '-', 'Y', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `msplace`
--

CREATE TABLE `msplace` (
  `Id` int NOT NULL,
  `PlaceType` varchar(25) DEFAULT NULL,
  `Nama` varchar(225) DEFAULT NULL,
  `Alamat` varchar(500) DEFAULT NULL,
  `FilePhoto` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `Catatan` text,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(225) DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msplace`
--

INSERT INTO `msplace` (`Id`, `PlaceType`, `Nama`, `Alamat`, `FilePhoto`, `FgActive`, `Catatan`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`) VALUES
(1, 'Pusat', 'Pusat Bali Jimbaran', 'Badung Kuta', NULL, 'Y', NULL, '1', '2022-09-29 17:01:14', '1', '2022-09-29 17:02:16');

-- --------------------------------------------------------

--
-- Table structure for table `msproduk`
--

CREATE TABLE `msproduk` (
  `Id` int NOT NULL,
  `KodeProduk` varchar(225) DEFAULT NULL,
  `Nama` varchar(225) DEFAULT NULL,
  `JenisProduk` int DEFAULT NULL,
  `SKU` varchar(225) DEFAULT NULL,
  `ProdukDesc` varchar(500) DEFAULT NULL,
  `HaveExpired` varchar(1) DEFAULT NULL,
  `Satuan` int DEFAULT NULL,
  `QtyBalance` int DEFAULT NULL,
  `HaveChild` int DEFAULT NULL,
  `QtyChild` int DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(225) DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msproduk`
--

INSERT INTO `msproduk` (`Id`, `KodeProduk`, `Nama`, `JenisProduk`, `SKU`, `ProdukDesc`, `HaveExpired`, `Satuan`, `QtyBalance`, `HaveChild`, `QtyChild`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`) VALUES
(1, 'INDSOTO', 'Indomie Soto', 3, '435234243', NULL, '0', 3, 0, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:05:47', '1', '2022-09-29 17:06:04'),
(2, 'INDMLKSO', 'Indomilk Coklat', 2, '12367123', NULL, '0', 1, 0, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:06:11', '1', '2022-09-29 17:06:52'),
(3, 'RKOKSJT', 'Rokok Sejati', 4, '45345234', NULL, '0', 4, 0, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:06:56', '1', '2022-09-29 17:07:35'),
(4, 'FTARED', 'Fanta strawberry', 2, '45345234', 'minuman soda rasa strawberry', NULL, 1, 0, NULL, NULL, NULL, 'Y', '-1', '2022-10-04 09:45:22', '-1', '2022-10-04 09:47:09');

-- --------------------------------------------------------

--
-- Table structure for table `mssatuan`
--

CREATE TABLE `mssatuan` (
  `Id` int NOT NULL,
  `Satuan` varchar(225) DEFAULT NULL,
  `SatuanDesc` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mssatuan`
--

INSERT INTO `mssatuan` (`Id`, `Satuan`, `SatuanDesc`, `FgActive`, `CreatedBy`, `CreatedDate`) VALUES
(1, 'Pak', 'bungkus besar ', 'Y', '1', '2022-09-29 17:02:24'),
(2, 'Pcs', 'bungkus kecil', 'Y', '1', '2022-09-29 17:02:47'),
(3, 'Dus', 'kardus', 'Y', '1', '2022-09-29 17:02:57'),
(4, 'slop', 'rokok 12 bungkus', 'Y', '1', '2022-09-29 17:25:21'),
(5, 'bungkus', 'rokok 12 batang', 'Y', '1', '2022-09-29 17:25:42'),
(6, 'batang', 'rokok ecer', 'Y', '1', '2022-09-29 17:25:57');

-- --------------------------------------------------------

--
-- Table structure for table `mssatuanproduk`
--

CREATE TABLE `mssatuanproduk` (
  `Id` int NOT NULL,
  `IdProduk` int DEFAULT NULL,
  `Satuan` int DEFAULT NULL,
  `QtyBalance` int DEFAULT NULL,
  `HaveChild` varchar(11) DEFAULT NULL,
  `QtyChild` int DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mssatuanproduk`
--

INSERT INTO `mssatuanproduk` (`Id`, `IdProduk`, `Satuan`, `QtyBalance`, `HaveChild`, `QtyChild`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`) VALUES
(1, 1, 2, NULL, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:07:51'),
(2, 1, 3, NULL, '1', 48, NULL, 'Y', '1', '2022-09-29 17:12:35'),
(3, 2, 2, NULL, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:24:44'),
(4, 3, 6, NULL, NULL, NULL, NULL, 'Y', '1', '2022-09-29 17:26:16'),
(5, 3, 5, NULL, '4', 12, NULL, 'Y', '1', '2022-09-29 17:26:32'),
(6, 3, 4, NULL, '5', 12, NULL, 'Y', '1', '2022-09-29 17:26:59');

-- --------------------------------------------------------

--
-- Table structure for table `msuser`
--

CREATE TABLE `msuser` (
  `id` int NOT NULL,
  `Username` varchar(225) DEFAULT NULL,
  `password` varchar(225) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Nama` varchar(225) DEFAULT NULL,
  `Alamat` varchar(225) DEFAULT NULL,
  `Usia` int DEFAULT NULL,
  `JenisKelamin` varchar(1) DEFAULT NULL,
  `NoHp` varchar(25) DEFAULT NULL,
  `email` varchar(225) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Place` int DEFAULT NULL,
  `FilePhoto` varchar(500) DEFAULT NULL,
  `Catatan` text,
  `Keanggotaan` int DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(225) DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `userlevel` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msuser`
--

INSERT INTO `msuser` (`id`, `Username`, `password`, `Nama`, `Alamat`, `Usia`, `JenisKelamin`, `NoHp`, `email`, `Place`, `FilePhoto`, `Catatan`, `Keanggotaan`, `FgActive`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `userlevel`, `created_at`, `updated_at`) VALUES
(1, 'abc', 'md5(\'12345678\')', 'test', 'jauh', 23, 'L', '083872595824', 'coba@email.com', 1, NULL, NULL, 1, 'Y', NULL, NULL, '-1', '2022-09-29 16:55:32', 1, '2022-10-11 01:45:34', '2022-10-11 01:45:34'),
(2, 'coba', '$2y$10$odR4DcNPmV0rUPGg391LjOXVRkMMWOyczIMJURXXMXgqxAHxy9VaO', 'ilham', 'deket', 17, 'L', '085893712441', 'ilham@email.com', 1, NULL, NULL, 1, 'Y', NULL, NULL, '-1', NULL, 1, '2022-10-10 18:45:54', '2022-10-10 18:45:54');

-- --------------------------------------------------------

--
-- Table structure for table `msvendor`
--

CREATE TABLE `msvendor` (
  `Id` int NOT NULL,
  `Nama` varchar(225) DEFAULT NULL,
  `Alamat` varchar(500) DEFAULT NULL,
  `NoHp` varchar(25) DEFAULT NULL,
  `Email` varchar(225) DEFAULT NULL,
  `VendorDesc` varchar(500) DEFAULT NULL,
  `FilePhoto` varchar(500) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(225) DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msvendor`
--

INSERT INTO `msvendor` (`Id`, `Nama`, `Alamat`, `NoHp`, `Email`, `VendorDesc`, `FilePhoto`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`) VALUES
(1, 'Sinar MAS', 'Jakarta Tenggara', '0828732342', 'sinarmas@sm.id', 'toko kue', NULL, NULL, 'Y', '1', '2022-09-29 16:59:45', '1', '2022-09-29 17:00:34');

-- --------------------------------------------------------

--
-- Table structure for table `msvendorproduk`
--

CREATE TABLE `msvendorproduk` (
  `Id` int NOT NULL,
  `IdVendor` int DEFAULT NULL,
  `IdProduct` int DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `msvendorproduk`
--

INSERT INTO `msvendorproduk` (`Id`, `IdVendor`, `IdProduct`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`) VALUES
(1, 1, 1, NULL, 'Y', '1', '2022-09-29 17:28:28'),
(2, 1, 2, NULL, 'Y', '1', '2022-09-29 17:28:37');

-- --------------------------------------------------------

--
-- Table structure for table `trorderdt`
--

CREATE TABLE `trorderdt` (
  `NoOrder` varchar(225) NOT NULL,
  `ItemNo` int NOT NULL,
  `IdProduk` int DEFAULT NULL,
  `Satuan` int DEFAULT NULL,
  `Harga` double(18,2) DEFAULT NULL,
  `TanggalExp` datetime DEFAULT NULL,
  `Qty` int DEFAULT NULL,
  `FgRO` varchar(1) DEFAULT NULL,
  `FgPO` varchar(1) DEFAULT NULL,
  `FgActive` varchar(1) NOT NULL,
  `TotalHarga` double(18,2) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trorderdt`
--

INSERT INTO `trorderdt` (`NoOrder`, `ItemNo`, `IdProduk`, `Satuan`, `Harga`, `TanggalExp`, `Qty`, `FgRO`, `FgPO`, `FgActive`, `TotalHarga`, `Catatan`, `CreatedBy`, `CreatedDate`) VALUES
('ODR2210-00008', 1, 1, 3, 0.00, '1999-01-01 00:00:00', 1, 'Y', 'Y', 'Y', 0.00, '-', 'jamal', '2022-10-01 14:56:17'),
('ODR2210-00009', 1, 2, 1, 0.00, '1999-01-01 00:00:00', 1, 'N', 'N', 'Y', 0.00, '-', 'jamal', '2022-10-01 14:56:39');

-- --------------------------------------------------------

--
-- Table structure for table `trorderdt_temp`
--

CREATE TABLE `trorderdt_temp` (
  `NoOrder` varchar(225) NOT NULL,
  `ItemNo` int NOT NULL,
  `IdProduk` int DEFAULT NULL,
  `Satuan` int DEFAULT NULL,
  `Harga` double(18,2) DEFAULT NULL,
  `TanggalExp` datetime DEFAULT NULL,
  `Qty` int DEFAULT NULL,
  `TotalHarga` double(18,2) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trorderdt_temp`
--

INSERT INTO `trorderdt_temp` (`NoOrder`, `ItemNo`, `IdProduk`, `Satuan`, `Harga`, `TanggalExp`, `Qty`, `TotalHarga`, `Catatan`) VALUES
('4UB3EWG6UG', 1, 2, 1, 0.00, '1999-01-01 00:00:00', 1, 0.00, '-'),
('FLL8B53UAV', 1, 1, 3, 0.00, '1999-01-01 00:00:00', 1, 0.00, '-'),
('FP8D8ZZXTR', 1, 1, 3, 0.00, '1999-01-01 00:00:00', 1, 0.00, '-');

-- --------------------------------------------------------

--
-- Table structure for table `trorderhd`
--

CREATE TABLE `trorderhd` (
  `NoOrder` varchar(225) NOT NULL,
  `TanggalOrder` datetime DEFAULT NULL,
  `Vendor` int DEFAULT NULL,
  `Place` int DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'NEW' COMMENT 'NEW, RO, PO, PENDING DO, DONE',
  `TotalItem` int DEFAULT NULL,
  `TotalHarga` double(18,2) DEFAULT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `FgActive` varchar(1) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(225) DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trorderhd`
--

INSERT INTO `trorderhd` (`NoOrder`, `TanggalOrder`, `Vendor`, `Place`, `Status`, `TotalItem`, `TotalHarga`, `Catatan`, `FgActive`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`) VALUES
('ODR2210-00008', '2022-10-01 00:00:00', 1, 1, 'NEW', 0, 0.00, 'tes', 'Y', 'jamal', '2022-10-01 14:56:17', NULL, NULL),
('ODR2210-00009', '2022-10-01 00:00:00', 1, 1, 'NEW', 0, 0.00, '2', 'Y', 'jamal', '2022-10-01 14:56:39', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trorderlog`
--

CREATE TABLE `trorderlog` (
  `NoOrder` varchar(225) NOT NULL,
  `TypeLog` varchar(50) NOT NULL,
  `Catatan` varchar(500) DEFAULT NULL,
  `CreatedBy` varchar(225) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trorderlog`
--

INSERT INTO `trorderlog` (`NoOrder`, `TypeLog`, `Catatan`, `CreatedBy`, `CreatedDate`) VALUES
('ODR2210-00008', 'DO', 'test', 'jamal', '2022-10-04 01:32:43'),
('ODR2210-00008', 'PO', 'test', 'jamal', '2022-10-04 01:26:30'),
('ODR2210-00008', 'RO', 'test', 'jamal', '2022-10-04 01:17:51');

-- --------------------------------------------------------

--
-- Table structure for table `userlevelpermissions`
--

CREATE TABLE `userlevelpermissions` (
  `userlevelid` int NOT NULL,
  `tablename` varchar(255) NOT NULL,
  `permission` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userlevelpermissions`
--

INSERT INTO `userlevelpermissions` (`userlevelid`, `tablename`, `permission`) VALUES
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}mshargaproduk', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msjenisproduk', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}mskeanggotaan', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msplace', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msproduk', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}mssatuan', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}mssatuanproduk', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msuser', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msvendor', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}msvendorproduk', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderdt', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderhd', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderlog', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}userlevelpermissions', 0),
(-2, '{45957137-4921-4EB5-A8D2-78F5ED502571}userlevels', 0),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}mshargaproduk', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msjenisproduk', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}mskeanggotaan', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msplace', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msproduk', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}mssatuan', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}mssatuanproduk', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msuser', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msvendor', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}msvendorproduk', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderdt', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderhd', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}trorderlog', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}userlevelpermissions', 109),
(1, '{45957137-4921-4EB5-A8D2-78F5ED502571}userlevels', 109);

-- --------------------------------------------------------

--
-- Table structure for table `userlevels`
--

CREATE TABLE `userlevels` (
  `userlevelid` int NOT NULL,
  `userlevelname` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userlevels`
--

INSERT INTO `userlevels` (`userlevelid`, `userlevelname`) VALUES
(-2, 'Anonymous'),
(-1, 'Administrator'),
(0, 'Default'),
(1, 'admin pusat'),
(2, 'admin cabang'),
(3, 'admin anggota');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mshargaproduk`
--
ALTER TABLE `mshargaproduk`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `msjenisproduk`
--
ALTER TABLE `msjenisproduk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mskeanggotaan`
--
ALTER TABLE `mskeanggotaan`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `msplace`
--
ALTER TABLE `msplace`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `msproduk`
--
ALTER TABLE `msproduk`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `mssatuan`
--
ALTER TABLE `mssatuan`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `mssatuanproduk`
--
ALTER TABLE `mssatuanproduk`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `msuser`
--
ALTER TABLE `msuser`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userlevelid` (`userlevel`);

--
-- Indexes for table `msvendor`
--
ALTER TABLE `msvendor`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `msvendorproduk`
--
ALTER TABLE `msvendorproduk`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `trorderdt`
--
ALTER TABLE `trorderdt`
  ADD PRIMARY KEY (`NoOrder`,`ItemNo`,`FgActive`);

--
-- Indexes for table `trorderdt_temp`
--
ALTER TABLE `trorderdt_temp`
  ADD PRIMARY KEY (`NoOrder`,`ItemNo`);

--
-- Indexes for table `trorderhd`
--
ALTER TABLE `trorderhd`
  ADD PRIMARY KEY (`NoOrder`);

--
-- Indexes for table `trorderlog`
--
ALTER TABLE `trorderlog`
  ADD PRIMARY KEY (`NoOrder`,`TypeLog`);

--
-- Indexes for table `userlevelpermissions`
--
ALTER TABLE `userlevelpermissions`
  ADD PRIMARY KEY (`userlevelid`,`tablename`);

--
-- Indexes for table `userlevels`
--
ALTER TABLE `userlevels`
  ADD PRIMARY KEY (`userlevelid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mshargaproduk`
--
ALTER TABLE `mshargaproduk`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `msjenisproduk`
--
ALTER TABLE `msjenisproduk`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mskeanggotaan`
--
ALTER TABLE `mskeanggotaan`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `msplace`
--
ALTER TABLE `msplace`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `msproduk`
--
ALTER TABLE `msproduk`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mssatuan`
--
ALTER TABLE `mssatuan`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `mssatuanproduk`
--
ALTER TABLE `mssatuanproduk`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `msuser`
--
ALTER TABLE `msuser`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `msvendor`
--
ALTER TABLE `msvendor`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `msvendorproduk`
--
ALTER TABLE `msvendorproduk`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
