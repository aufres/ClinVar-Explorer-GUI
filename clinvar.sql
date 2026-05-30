-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 26, 2026 at 11:06 PM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `clinvar`
--

-- --------------------------------------------------------

--
-- Table structure for table `clinical_association`
--

CREATE TABLE `clinical_association` (
  `AssociationID` int(11) NOT NULL,
  `VariantID` int(11) DEFAULT NULL,
  `DiseaseID` int(11) DEFAULT NULL,
  `ClinicalSignificance` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `clinical_association`
--

INSERT INTO `clinical_association` (`AssociationID`, `VariantID`, `DiseaseID`, `ClinicalSignificance`) VALUES
(1, 1, 1, 'Pathogenic'),
(2, 2, 1, 'Pathogenic'),
(3, 3, 2, 'Uncertain significance'),
(4, 4, 3, 'Pathogenic'),
(5, 5, 3, 'Pathogenic'),
(6, 7, 4, 'Uncertain significance'),
(7, 7, 6, 'Uncertain significance'),
(8, 8, 4, 'Uncertain significance'),
(9, 10, 4, 'Uncertain significance'),
(10, 10, 5, 'Uncertain significance'),
(11, 11, 4, 'Uncertain significance'),
(12, 11, 5, 'Uncertain significance'),
(13, 12, 4, 'Uncertain significance'),
(14, 13, 4, 'Pathogenic'),
(15, 14, 4, 'Pathogenic'),
(16, 14, 6, 'Pathogenic'),
(17, 15, 7, 'Pathogenic'),
(18, 16, 7, 'Pathogenic'),
(19, 17, 7, 'Pathogenic'),
(20, 17, 8, 'Pathogenic'),
(21, 18, 7, 'Pathogenic'),
(22, 19, 9, 'Pathogenic'),
(23, 20, 9, 'Pathogenic'),
(24, 21, 9, 'Pathogenic'),
(25, 22, 10, 'Pathogenic'),
(26, 22, 11, 'Pathogenic'),
(27, 23, 11, 'Pathogenic'),
(28, 24, 10, 'Pathogenic'),
(29, 24, 11, 'Pathogenic'),
(30, 25, 11, 'Pathogenic'),
(31, 26, 11, 'Pathogenic'),
(32, 27, 11, 'Pathogenic'),
(33, 28, 12, 'Pathogenic'),
(34, 28, 15, 'Pathogenic'),
(35, 29, 13, 'Pathogenic'),
(36, 29, 12, 'Pathogenic'),
(37, 29, 14, 'Pathogenic'),
(38, 29, 15, 'Pathogenic'),
(39, 30, 12, 'Pathogenic'),
(40, 30, 15, 'Pathogenic'),
(41, 31, 12, 'Pathogenic'),
(42, 31, 14, 'Pathogenic'),
(43, 31, 15, 'Pathogenic'),
(44, 32, 15, 'Pathogenic'),
(45, 33, 16, 'Pathogenic'),
(46, 34, 16, 'Uncertain significance'),
(47, 35, 16, 'Pathogenic'),
(48, 36, 16, 'Pathogenic'),
(49, 37, 16, 'Pathogenic'),
(50, 38, 17, 'Pathogenic'),
(51, 38, 17, 'Pathogenic'),
(52, 41, 20, 'Pathogenic'),
(53, 41, 21, 'Pathogenic'),
(54, 42, 21, 'Pathogenic'),
(55, 43, 22, 'Pathogenic'),
(56, 44, 22, 'Pathogenic'),
(57, 9, 41, 'Benign');

-- --------------------------------------------------------

--
-- Table structure for table `disease`
--

CREATE TABLE `disease` (
  `DiseaseID` int(11) NOT NULL,
  `DiseaseName` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `disease`
--

INSERT INTO `disease` (`DiseaseID`, `DiseaseName`) VALUES
(1, 'Hereditary spastic paraplegia 48'),
(2, 'Galloway-Mowat syndrome 1'),
(3, 'Mitochondrial complex I deficiency (nuclear type 19)'),
(4, 'Hemochromatosis type 1'),
(5, 'HFE POLYMORPHISM'),
(6, 'Hereditary hemochromatosis'),
(7, 'Cranioectodermal dysplasia 2'),
(8, 'Short-rib thoracic dysplasia 7'),
(9, 'PHARC syndrome'),
(10, 'HOGA1-related disorder'),
(11, 'Primary hyperoxaluria type 3'),
(12, 'Retinal dystrophy'),
(13, 'Cone-rod dystrophy'),
(14, 'Retinitis pigmentosa'),
(15, 'Retinitis pigmentosa 28'),
(16, 'Microcephaly 2'),
(17, 'Bardet-Biedl syndrome 15'),
(18, 'Bardet-Biedl syndrome 12'),
(19, 'Meckel syndrome type 6'),
(20, 'Autosomal dominant nonsyndromic hearing loss 65'),
(21, 'Familial infantile myoclonic epilepsy'),
(22, 'Nephronophthisis-like nephropathy 1'),
(23, 'Combined oxidative phosphorylation defect type 7'),
(24, 'Spastic paraplegia'),
(25, 'Abnormal brain morphology'),
(26, 'Epileptic encephalopathy'),
(27, 'Microcephaly 9'),
(28, 'Bardet-Biedl syndrome 16'),
(29, 'Senior-Loken syndrome 7'),
(30, 'SDCCAG8-related disorder'),
(31, 'Blue color blindness'),
(32, 'Familial porphyria cutanea tarda'),
(33, 'Hepatoerythropoietic porphyria'),
(34, 'Porphyria cutanea tarda'),
(35, 'Thyroid cancer nonmedullary 1'),
(36, 'UROD-related disorder'),
(37, 'Wolman disease'),
(38, 'Lysosomal acid lipase deficiency'),
(39, 'Cardiovascular phenotype'),
(40, 'Cholesteryl ester storage disease'),
(41, 'HFE INTRONIC POLYMORPHISM');

-- --------------------------------------------------------

--
-- Table structure for table `gene`
--

CREATE TABLE `gene` (
  `GeneID` int(11) NOT NULL,
  `GeneSymbol` varchar(512) DEFAULT NULL,
  `NCBI_ID` int(11) DEFAULT NULL,
  `Chromosome` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `gene`
--

INSERT INTO `gene` (`GeneID`, `GeneSymbol`, `NCBI_ID`, `Chromosome`) VALUES
(1, 'AP5Z1', 9907, 7),
(2, 'ZNF592', 9640, 15),
(3, 'FOXRED1', 55572, 11),
(4, 'HFE', 3077, 6),
(5, 'WDR35', 57539, 2),
(6, 'ABHD12', 26090, 20),
(7, 'HOGA1', 112817, 10),
(8, 'FAM161A', 84140, 2),
(9, 'WDR62', 284403, 19),
(10, 'WDPCP', 51057, 2),
(11, 'TBC1D24', 57465, 16),
(12, 'XPNPEP3', 63929, 22),
(13, 'MTRFR', 91574, 12),
(14, 'CEP152', 22995, 15),
(15, 'SDCCAG8', 10806, 1),
(16, 'OPN1SW', 611, 7),
(17, 'UROD', 7389, 1),
(18, 'LIPA', 3988, 10);

-- --------------------------------------------------------

--
-- Table structure for table `variant`
--

CREATE TABLE `variant` (
  `VariantID` int(11) NOT NULL,
  `VariantType` varchar(512) DEFAULT NULL,
  `HGVS_Name` varchar(512) DEFAULT NULL,
  `GeneID` int(11) DEFAULT NULL,
  `AlleleID` int(11) DEFAULT NULL,
  `snpID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `variant`
--

INSERT INTO `variant` (`VariantID`, `VariantType`, `HGVS_Name`, `GeneID`, `AlleleID`, `snpID`) VALUES
(1, 'Indel', 'NM_014855.3(AP5Z1):c.80_83delinsTGCTGTAAACTGTAACTGTAAA (p.Arg27_Ile28delinsLeuLeuTer)', 1, 15041, 397704705),
(2, 'Deletion', 'NM_014855.3(AP5Z1):c.1413_1426del (p.Leu473fs)', 1, 15042, 397704709),
(3, 'single nucleotide variant', 'NM_014630.3(ZNF592):c.3136G>A (p.Gly1046Arg)', 2, 15043, 150829393),
(4, 'single nucleotide variant', 'NM_017547.4(FOXRED1):c.694C>T (p.Gln232Ter)', 3, 15044, 267606829),
(5, 'single nucleotide variant', 'NM_017547.4(FOXRED1):c.1289A>G (p.Asn430Ser)', 3, 15045, 267606830),
(6, 'single nucleotide variant', 'NM_000410.4(HFE):c.193A>T (p.Ser65Cys)', 4, 15050, 1800730),
(7, 'single nucleotide variant', 'NM_000410.4(HFE):c.314T>C (p.Ile105Thr)', 4, 15051, 28934596),
(8, 'single nucleotide variant', 'NM_000410.4(HFE):c.277G>C (p.Gly93Arg)', 4, 15052, 28934597),
(9, 'single nucleotide variant', 'NM_000410.4(HFE):c.892+48G>A', 4, 15053, 1800758),
(10, 'single nucleotide variant', 'NM_000410.4(HFE):c.157G>A (p.Val53Met)', 4, 15054, 28934889),
(11, 'single nucleotide variant', 'NM_000410.4(HFE):c.175G>A (p.Val59Met)', 4, 15055, 111033557),
(12, 'single nucleotide variant', 'NM_000410.4(HFE):c.381A>C (p.Gln127His)', 4, 15056, 28934595),
(13, 'single nucleotide variant', 'NM_000410.4(HFE):c.989G>T (p.Arg330Met)', 4, 15057, 111033558),
(14, 'single nucleotide variant', 'NM_000410.4(HFE):c.848A>C (p.Gln283Pro)', 4, 15058, 111033563),
(15, 'single nucleotide variant', 'NM_020779.4(WDR35):c.25-2A>G', 5, 15059, 397515534),
(16, 'single nucleotide variant', 'NM_020779.4(WDR35):c.1844A>G (p.Glu615Gly)', 5, 15060, 267607174),
(17, 'Deletion', 'NM_020779.4(WDR35):c.2858del (p.Pro953fs)', 5, 15061, 397515334),
(18, 'single nucleotide variant', 'NM_020779.4(WDR35):c.2590G>A (p.Ala864Thr)', 5, 15062, 267607175),
(19, 'Indel', 'NM_001042472.3(ABHD12):c.337_338delinsTTT (p.Asp113fs)', 6, 15063, 1555813914),
(20, 'Duplication', 'NM_001042472.3(ABHD12):c.846_852dup (p.His285Ter)', 6, 15065, 397704714),
(21, 'single nucleotide variant', 'NM_001042472.3(ABHD12):c.1054C>T (p.Arg352Ter)', 6, 15066, 267606624),
(22, 'single nucleotide variant', 'NM_144631.6(ZNF513):c.1015T>C (p.Cys339Arg)', 12, 15067, 267607182),
(23, 'Microsatellite', 'NM_138413.4(HOGA1):c.938AGG[2] (p.Glu315del)', 7, 15068, 397509360),
(24, 'single nucleotide variant', 'NM_138413.4(HOGA1):c.860G>T (p.Gly287Val)', 7, 15069, 138207257),
(25, 'single nucleotide variant', 'NM_138413.4(HOGA1):c.289C>T (p.Arg97Cys)', 7, 15070, 267606762),
(26, 'single nucleotide variant', 'NM_138413.4(HOGA1):c.700+4G>T', 7, 15071, 2041105506),
(27, 'single nucleotide variant', 'NM_138413.4(HOGA1):c.209G>C (p.Arg70Pro)', 7, 15072, 267606763),
(28, 'single nucleotide variant', 'NM_138413.4(HOGA1):c.769T>G (p.Cys257Gly)', 7, 15073, 267606764),
(29, 'single nucleotide variant', 'NM_001201543.2(FAM161A):c.685C>T (p.Arg229Ter)', 8, 15074, 267606794),
(30, 'single nucleotide variant', 'NM_001201543.2(FAM161A):c.1309A>T (p.Arg437Ter)', 8, 15075, 200691042),
(31, 'Deletion', 'NM_001201543.2(FAM161A):c.1355_1356del (p.Thr452fs)', 8, 15076, 397704718),
(32, 'single nucleotide variant', 'NM_001201543.2(FAM161A):c.1567C>T (p.Arg523Ter)', 8, 15077, 202193201),
(33, 'single nucleotide variant', 'NM_001201543.2(FAM161A):c.1786C>T (p.Arg596Ter)', 8, 15078, 267606793),
(34, 'Deletion', 'NM_001083961.2(WDR62):c.4205_4208del (p.Val1402fs)', 9, 15079, 397704721),
(35, 'single nucleotide variant', 'NM_001083961.2(WDR62):c.1576G>A (p.Glu526Lys)', 9, 15080, 147875659),
(36, 'single nucleotide variant', 'NM_001083961.2(WDR62):c.671G>C (p.Trp224Ser)', 9, 15081, 267607176),
(37, 'single nucleotide variant', 'NM_001083961.2(WDR62):c.1408C>T (p.Gln470Ter)', 9, 15082, 267607177),
(38, 'Deletion', 'NM_001083961.2(WDR62):c.3839_3855del (p.Gly1280fs)', 9, 15083, 397704725),
(39, 'single nucleotide variant', 'NM_015910.7(WDPCP):c.76-1G>T', 10, 15084, 397704728),
(40, 'single nucleotide variant', 'NM_015910.7(WDPCP):c.624G>C (p.Leu208Phe)', 10, 15085, 267606692),
(41, 'single nucleotide variant', 'NM_015910.7(WDPCP):c.164G>A (p.Arg55Lys)', 10, 15086, 267606693),
(42, 'single nucleotide variant', 'NM_001199107.2(TBC1D24):c.439G>C (p.Asp147His)', 11, 15087, 267607103),
(43, 'single nucleotide variant', 'NM_001199107.2(TBC1D24):c.1544C>T (p.Ala515Val)', 11, 15088, 267607105),
(44, 'single nucleotide variant', 'NM_001199107.2(TBC1D24):c.751T>C (p.Phe251Leu)', 11, 15089, 267607104),
(45, 'single nucleotide variant', 'NM_022098.4(XPNPEP3):c.1357G>T (p.Gly453Cys)', 12, 15090, 267607179),
(46, 'Deletion', 'NM_022098.4(XPNPEP3):c.931_934del (p.Asn311fs)', 12, 15091, 2146270895);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clinical_association`
--
ALTER TABLE `clinical_association`
  ADD PRIMARY KEY (`AssociationID`),
  ADD KEY `fk_variant` (`VariantID`),
  ADD KEY `fk_disease` (`DiseaseID`);

--
-- Indexes for table `disease`
--
ALTER TABLE `disease`
  ADD PRIMARY KEY (`DiseaseID`);

--
-- Indexes for table `gene`
--
ALTER TABLE `gene`
  ADD PRIMARY KEY (`GeneID`);

--
-- Indexes for table `variant`
--
ALTER TABLE `variant`
  ADD PRIMARY KEY (`VariantID`),
  ADD KEY `fk_gene` (`GeneID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `clinical_association`
--
ALTER TABLE `clinical_association`
  ADD CONSTRAINT `fk_disease` FOREIGN KEY (`DiseaseID`) REFERENCES `disease` (`DiseaseID`),
  ADD CONSTRAINT `fk_variant` FOREIGN KEY (`VariantID`) REFERENCES `variant` (`VariantID`);

--
-- Constraints for table `variant`
--
ALTER TABLE `variant`
  ADD CONSTRAINT `fk_gene` FOREIGN KEY (`GeneID`) REFERENCES `gene` (`GeneID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
