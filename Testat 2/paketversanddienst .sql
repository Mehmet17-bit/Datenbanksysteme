-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 15. Jan 2021 um 23:27
-- Server-Version: 10.4.14-MariaDB
-- PHP-Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `paketversanddienst`
--

DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Sendungverifizierung` ()  MODIFIES SQL DATA
    COMMENT 'Wenn Sendung länger als 14 Tage, Frage-> Was passiert?'
UPDATE auftragv1 SET auftragv1.Status = 8
WHERE auftragv1.Status < 6 AND CURRENT_DATE -  auftragv1.Datum > 14$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `abteilung`
--

CREATE TABLE `abteilung` (
  `ID` int(11) NOT NULL,
  `Beschreibung` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `abteilung`
--

INSERT INTO `abteilung` (`ID`, `Beschreibung`) VALUES
(1, 'Shopinhaber'),
(2, 'Lieferant'),
(3, 'Shopangestellter');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auftragv1`
--

CREATE TABLE `auftragv1` (
  `AuftragID` int(11) NOT NULL,
  `Empfaenger` int(11) DEFAULT NULL,
  `Absender` int(11) DEFAULT NULL,
  `Datum` date NOT NULL,
  `Anzahl_Sendungen` int(11) NOT NULL,
  `Status` int(11) DEFAULT NULL,
  `Verguetungsgruppe` int(11) DEFAULT NULL,
  `Paketklasse` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `auftragv1`
--

INSERT INTO `auftragv1` (`AuftragID`, `Empfaenger`, `Absender`, `Datum`, `Anzahl_Sendungen`, `Status`, `Verguetungsgruppe`, `Paketklasse`) VALUES
(1, 4, 1, '2020-12-04', 2, 6, 3, 1),
(2, 7, 3, '2020-10-14', 1, 7, 4, 2),
(3, 9, 2, '2020-12-31', 1, 6, 2, 5),
(4, 6, 1, '2020-12-26', 3, 8, 3, 4),
(5, 9, 1, '2021-01-13', 3, 2, 5, 4),
(6, 9, 3, '2021-01-10', 1, 7, 1, 6);

--
-- Trigger `auftragv1`
--
DELIMITER $$
CREATE TRIGGER `Paket_Retoure` AFTER UPDATE ON `auftragv1` FOR EACH ROW BEGIN
IF NEW.Status = 7 
THEN INSERT INTO log_retoure(log_retoure.AuftragNr,log_retoure.Retouredatum) VALUES
(OLD.AuftragID, NOW());
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Paket_zugestellt` AFTER UPDATE ON `auftragv1` FOR EACH ROW BEGIN
IF NEW.Status = 6 
THEN INSERT INTO log_pakete_zugestellt(log_pakete_zugestellt.AuftragNr,log_pakete_zugestellt.Zustelldatum) VALUES
(OLD.AuftragID, NOW());
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bezirk`
--

CREATE TABLE `bezirk` (
  `BezirkNr` int(11) NOT NULL,
  `Region` varchar(255) NOT NULL,
  `PLZ` int(11) NOT NULL,
  `Ort` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `bezirk`
--

INSERT INTO `bezirk` (`BezirkNr`, `Region`, `PLZ`, `Ort`) VALUES
(1, 'Hessen', 35390, 'Gießen'),
(2, 'Hessen', 60313, 'Frankfurt'),
(3, 'Hessen', 61169, 'Friedberg'),
(4, 'Hessen', 61231, 'Bad Nauheim'),
(5, 'Hessen', 60165, 'Mannheim'),
(6, 'Nordrhein-Westfalen', 33098, 'Paderborn'),
(7, 'Nordrhein-Westfalen', 33602, 'Bielefeld'),
(8, 'Hessen', 34117, 'Kassel'),
(9, 'Hessen', 35037, 'Marburg'),
(10, 'Hessen', 36037, 'Fulda');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kunde`
--

CREATE TABLE `kunde` (
  `KundenNr` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Adresse` varchar(255) DEFAULT NULL,
  `Telefon` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `kunde`
--

INSERT INTO `kunde` (`KundenNr`, `Name`, `Adresse`, `Telefon`, `Email`) VALUES
(1, 'Efecan Kurt', '61169 Friedberg, Altstadt 23', '0175244889', 'Efecan.Kurt@yahoo.de'),
(2, 'Peter Lüstler', '35390 Gießen, Licherstraße 30', '01748856559', 'Peter.Luestler@gmail.de'),
(3, 'Yeliz Yesilgöz', '61231 Bad Nauheim, Elonering 12', '0175556987', 'Yeliz.Yesilgoez@hotmail.com'),
(4, 'Tom Cruise', '60313 Frankfurt, Bahnhofsstrße 30', '01766989532', 'Tom.Cruise@gmail.de'),
(5, 'Adonis Strong', '60165 Mannheim, Kellerstraße 50a', '0174236569', 'Adonis.Strong@hotmail.de'),
(6, 'Ufuk Güler', '35037 Marburg, Schlossstraße 25', '0172235645', 'Ufuk.Gueler@gmail.de'),
(7, 'Alex Höger', '34117 Kassel, Schildstraße 22', '0174545896', 'Alex.Hoeger@hotmail.de'),
(8, 'Dilara Diken', '33602 Bielefeld, Feldstraße 10', '0172965485', 'Diken.Dilara@gamil.de'),
(9, 'Joshua Stahl', '33602 Bielefeld, Schöngasse 17', '0176669897', 'Josh.Stahl@hotmail.com'),
(10, 'Phillip Pröger', '35390 Gießen, Am Marktplatz 10', '01524696963', 'Phillip.Proeger@yahoo.de');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `leistung`
--

CREATE TABLE `leistung` (
  `LeistungID` int(11) NOT NULL,
  `Service` varchar(255) DEFAULT NULL,
  `Preis` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `leistung`
--

INSERT INTO `leistung` (`LeistungID`, `Service`, `Preis`) VALUES
(1, 'Standard Versand', '0.00'),
(2, 'Premium Versand', '6.95'),
(3, 'Haftschutz bis 100 Euro', '4.95'),
(4, 'Stornierung', '2.50'),
(5, 'Transportschutzversicherung', '5.75'),
(6, 'Altersüberprüfung', '2.25'),
(7, 'Sendungsverfolgung', '1.75');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `log_pakete_zugestellt`
--

CREATE TABLE `log_pakete_zugestellt` (
  `Log_ID` int(11) NOT NULL,
  `AuftragNr` int(11) DEFAULT NULL,
  `Zustelldatum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `log_pakete_zugestellt`
--

INSERT INTO `log_pakete_zugestellt` (`Log_ID`, `AuftragNr`, `Zustelldatum`) VALUES
(1, 1, '2021-01-06 16:08:47'),
(2, 3, '2021-01-09 17:28:42');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `log_retoure`
--

CREATE TABLE `log_retoure` (
  `RetoureID` int(11) NOT NULL,
  `AuftragNr` int(11) DEFAULT NULL,
  `Retouredatum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `log_retoure`
--

INSERT INTO `log_retoure` (`RetoureID`, `AuftragNr`, `Retouredatum`) VALUES
(1, 2, '2021-01-10 01:35:16'),
(2, 6, '2021-01-14 13:22:27');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mitarbeiter`
--

CREATE TABLE `mitarbeiter` (
  `MitarbeitNr` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Telefon` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Abteilung` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `mitarbeiter`
--

INSERT INTO `mitarbeiter` (`MitarbeitNr`, `Name`, `Telefon`, `Email`, `Abteilung`) VALUES
(1, 'Frederik Keller', '0176123456', 'Frederik.Keller@gmail.de', 3),
(2, 'Bernd Welk', '015222345', 'Bernd.Welk@hotmail.com', 1),
(3, 'Jürgen Klaus', '0176998546', 'Juergen.Klaus@hotmail.com', 2),
(4, 'Ken Kaneki', '017645451', 'Ken.Kaneki@yahoo.de', 2),
(5, 'Violete Helli', '0175454677', 'Violete.Helli@gmail.de', 1),
(6, 'Kate Monroe', '017545646', 'Kate.Mon@hotmail.de', 3),
(7, 'Harald Westling', '017645456', 'Harald.Westling@hotmail.com', 2),
(8, 'Ahmet Özbek', '01733312456', 'Ahmet.Oezbek@hotmail.com', 1),
(9, 'Felix Klein', '017688954', 'Felix.Klein@hotmail.de', 1),
(10, 'Gerd Grünling', '01768894563', 'Gerd.Gruenling@yahoo.de', 2),
(11, 'Lee Chong Chu', '0176254666', 'Lee.Chong.Chu@hotmail.de', 1),
(12, 'Max Keller', '0152469888', 'Max.Keller@hotmail.de', 2),
(13, 'Fatma Demir', '0174321555', 'Fatma.Demir@gmail.de', 3),
(14, 'Angeline Jossy', '0174545444', 'Angeline.Jossy@yahoo.de', 3),
(15, 'Roland Henker', '0174441222', 'Roland.Henker@hotmail.de', 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `paketklassen`
--

CREATE TABLE `paketklassen` (
  `PaketNr` int(11) NOT NULL,
  `Paketname` varchar(255) NOT NULL,
  `Maße` varchar(255) NOT NULL,
  `Onlinepreis` decimal(4,2) NOT NULL,
  `Shoppreis` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `paketklassen`
--

INSERT INTO `paketklassen` (`PaketNr`, `Paketname`, `Maße`, `Onlinepreis`, `Shoppreis`) VALUES
(1, '2 Kg-Paket S', '35x25x10 cm', '2.50', '1.75'),
(2, '2 Kg-Paket M', '60x30x15 cm', '3.80', '2.75'),
(3, '2 Kg-Paket XL', '60x60x30 cm', '4.75', '5.50'),
(4, '5 Kg-Paket', '120x60x60 cm', '5.99', '6.99'),
(5, '10 Kg-Paket', '120x60x60 cm', '8.85', '9.75'),
(6, '31,5 Kg-Paket', '120x60x60 cm', '14.50', '12.99');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `paketklassev1`
--

CREATE TABLE `paketklassev1` (
  `ID` int(11) NOT NULL,
  `Klasse` int(11) DEFAULT NULL,
  `Leistung1` int(11) DEFAULT NULL,
  `Leistung2` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `paketklassev1`
--

INSERT INTO `paketklassev1` (`ID`, `Klasse`, `Leistung1`, `Leistung2`) VALUES
(1, 1, 1, 3),
(2, 2, 2, 7),
(3, 3, 4, 5),
(4, 4, 4, 6),
(5, 5, 2, 3),
(6, 6, 5, 7);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `parcel_express_shop`
--

CREATE TABLE `parcel_express_shop` (
  `ShopID` int(11) NOT NULL,
  `Shopname` varchar(255) DEFAULT NULL,
  `Shopinhaber` int(11) DEFAULT NULL,
  `Adresse` varchar(255) DEFAULT NULL,
  `Telefon` varchar(255) DEFAULT NULL,
  `Öffnungszeiten` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `parcel_express_shop`
--

INSERT INTO `parcel_express_shop` (`ShopID`, `Shopname`, `Shopinhaber`, `Adresse`, `Telefon`, `Öffnungszeiten`) VALUES
(1, 'Everything You Need', 8, '61231, Bad Nauheim, Haupstraße 22', '06032/995', 'Mo-Fr 9-20 Uhr'),
(2, 'Sell Paradise', 2, '61169, Friedberg, Kaiserstraße 12', '06031/221', 'Mo-Fr 9-19 Uhr'),
(3, 'Big City Post', 11, '60165, Mannheim, Rödelallee 45', '0621/7777', 'Mo-Sa 9-20 Uhr'),
(4, 'Paket Dream', 5, '35390,Gießen, Neustädter Tor 21', '0641/559', 'Mo-Fr 10-18 Uhr'),
(5, 'Big City Post', 9, '60313, Frankurt, Zeil 12-14', '069/698', 'Mo-Fr 9-20 Uhr');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sendungsstatus`
--

CREATE TABLE `sendungsstatus` (
  `ZustellNr` int(11) NOT NULL,
  `Zustellstatus` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `sendungsstatus`
--

INSERT INTO `sendungsstatus` (`ZustellNr`, `Zustellstatus`) VALUES
(1, 'Ankündigung der Sendung'),
(2, 'In Bearbeitung'),
(3, 'Abgabe im Shop'),
(4, 'Transport zu Niederlassung'),
(5, 'in Zustellung'),
(6, 'zugestellt'),
(7, 'Retoure'),
(8, 'verloren gegangen?'),
(9, 'keine Bestellung');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `verguetungsgruppe`
--

CREATE TABLE `verguetungsgruppe` (
  `VerguetungsID` int(11) NOT NULL,
  `Verguetungsname` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `verguetungsgruppe`
--

INSERT INTO `verguetungsgruppe` (`VerguetungsID`, `Verguetungsname`) VALUES
(1, 'Möbel'),
(2, 'Textil'),
(3, 'Elektronik'),
(4, 'Lebensmittel'),
(5, 'Hygiene');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `zusteller`
--

CREATE TABLE `zusteller` (
  `ID` int(11) NOT NULL,
  `ZustellNr` int(11) DEFAULT NULL,
  `Zustellbezirk` int(11) NOT NULL,
  `AuftragNr` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `zusteller`
--

INSERT INTO `zusteller` (`ID`, `ZustellNr`, `Zustellbezirk`, `AuftragNr`) VALUES
(1, 3, 4, 1),
(2, 4, 8, 2),
(3, 7, 7, 3),
(4, 12, 9, 4),
(5, 3, 7, 5),
(6, 4, 8, 6);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `abteilung`
--
ALTER TABLE `abteilung`
  ADD PRIMARY KEY (`ID`);

--
-- Indizes für die Tabelle `auftragv1`
--
ALTER TABLE `auftragv1`
  ADD PRIMARY KEY (`AuftragID`),
  ADD KEY `Empfaenger` (`Empfaenger`),
  ADD KEY `Absender` (`Absender`),
  ADD KEY `Status` (`Status`),
  ADD KEY `auftragv1_ibfk_4` (`Verguetungsgruppe`),
  ADD KEY `auftragv1_ibfk_5` (`Paketklasse`);

--
-- Indizes für die Tabelle `bezirk`
--
ALTER TABLE `bezirk`
  ADD PRIMARY KEY (`BezirkNr`);

--
-- Indizes für die Tabelle `kunde`
--
ALTER TABLE `kunde`
  ADD PRIMARY KEY (`KundenNr`);

--
-- Indizes für die Tabelle `leistung`
--
ALTER TABLE `leistung`
  ADD PRIMARY KEY (`LeistungID`);

--
-- Indizes für die Tabelle `log_pakete_zugestellt`
--
ALTER TABLE `log_pakete_zugestellt`
  ADD PRIMARY KEY (`Log_ID`),
  ADD KEY `log_pakete_zugestellt_ibfk_1` (`AuftragNr`);

--
-- Indizes für die Tabelle `log_retoure`
--
ALTER TABLE `log_retoure`
  ADD PRIMARY KEY (`RetoureID`),
  ADD KEY `log_retoure_ibfk_1` (`AuftragNr`);

--
-- Indizes für die Tabelle `mitarbeiter`
--
ALTER TABLE `mitarbeiter`
  ADD PRIMARY KEY (`MitarbeitNr`),
  ADD KEY `Abteilung` (`Abteilung`);

--
-- Indizes für die Tabelle `paketklassen`
--
ALTER TABLE `paketklassen`
  ADD PRIMARY KEY (`PaketNr`);

--
-- Indizes für die Tabelle `paketklassev1`
--
ALTER TABLE `paketklassev1`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Klasse` (`Klasse`),
  ADD KEY `paketklassev1_ibfk_2` (`Leistung1`),
  ADD KEY `paketklassev1_ibfk_3` (`Leistung2`);

--
-- Indizes für die Tabelle `parcel_express_shop`
--
ALTER TABLE `parcel_express_shop`
  ADD PRIMARY KEY (`ShopID`),
  ADD KEY `parcel_express_shop_ibfk_1` (`Shopinhaber`);

--
-- Indizes für die Tabelle `sendungsstatus`
--
ALTER TABLE `sendungsstatus`
  ADD PRIMARY KEY (`ZustellNr`);

--
-- Indizes für die Tabelle `verguetungsgruppe`
--
ALTER TABLE `verguetungsgruppe`
  ADD PRIMARY KEY (`VerguetungsID`);

--
-- Indizes für die Tabelle `zusteller`
--
ALTER TABLE `zusteller`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Zustellbezirk` (`Zustellbezirk`),
  ADD KEY `ZustellNr` (`ZustellNr`),
  ADD KEY `zusteller_ibfk_5` (`AuftragNr`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `abteilung`
--
ALTER TABLE `abteilung`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT für Tabelle `auftragv1`
--
ALTER TABLE `auftragv1`
  MODIFY `AuftragID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `bezirk`
--
ALTER TABLE `bezirk`
  MODIFY `BezirkNr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT für Tabelle `kunde`
--
ALTER TABLE `kunde`
  MODIFY `KundenNr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT für Tabelle `leistung`
--
ALTER TABLE `leistung`
  MODIFY `LeistungID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT für Tabelle `log_pakete_zugestellt`
--
ALTER TABLE `log_pakete_zugestellt`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `log_retoure`
--
ALTER TABLE `log_retoure`
  MODIFY `RetoureID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `mitarbeiter`
--
ALTER TABLE `mitarbeiter`
  MODIFY `MitarbeitNr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT für Tabelle `paketklassen`
--
ALTER TABLE `paketklassen`
  MODIFY `PaketNr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `parcel_express_shop`
--
ALTER TABLE `parcel_express_shop`
  MODIFY `ShopID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT für Tabelle `sendungsstatus`
--
ALTER TABLE `sendungsstatus`
  MODIFY `ZustellNr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT für Tabelle `verguetungsgruppe`
--
ALTER TABLE `verguetungsgruppe`
  MODIFY `VerguetungsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT für Tabelle `zusteller`
--
ALTER TABLE `zusteller`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `auftragv1`
--
ALTER TABLE `auftragv1`
  ADD CONSTRAINT `auftragv1_ibfk_1` FOREIGN KEY (`Empfaenger`) REFERENCES `kunde` (`KundenNr`),
  ADD CONSTRAINT `auftragv1_ibfk_2` FOREIGN KEY (`Absender`) REFERENCES `parcel_express_shop` (`ShopID`),
  ADD CONSTRAINT `auftragv1_ibfk_3` FOREIGN KEY (`Status`) REFERENCES `sendungsstatus` (`ZustellNr`),
  ADD CONSTRAINT `auftragv1_ibfk_4` FOREIGN KEY (`Verguetungsgruppe`) REFERENCES `verguetungsgruppe` (`VerguetungsID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `auftragv1_ibfk_5` FOREIGN KEY (`Paketklasse`) REFERENCES `paketklassev1` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `log_pakete_zugestellt`
--
ALTER TABLE `log_pakete_zugestellt`
  ADD CONSTRAINT `log_pakete_zugestellt_ibfk_1` FOREIGN KEY (`AuftragNr`) REFERENCES `auftragv1` (`AuftragID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `log_retoure`
--
ALTER TABLE `log_retoure`
  ADD CONSTRAINT `log_retoure_ibfk_1` FOREIGN KEY (`AuftragNr`) REFERENCES `auftragv1` (`AuftragID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mitarbeiter`
--
ALTER TABLE `mitarbeiter`
  ADD CONSTRAINT `mitarbeiter_ibfk_1` FOREIGN KEY (`Abteilung`) REFERENCES `abteilung` (`ID`);

--
-- Constraints der Tabelle `paketklassev1`
--
ALTER TABLE `paketklassev1`
  ADD CONSTRAINT `paketklassev1_ibfk_1` FOREIGN KEY (`Klasse`) REFERENCES `paketklassen` (`PaketNr`),
  ADD CONSTRAINT `paketklassev1_ibfk_2` FOREIGN KEY (`Leistung1`) REFERENCES `leistung` (`LeistungID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `paketklassev1_ibfk_3` FOREIGN KEY (`Leistung2`) REFERENCES `leistung` (`LeistungID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `parcel_express_shop`
--
ALTER TABLE `parcel_express_shop`
  ADD CONSTRAINT `parcel_express_shop_ibfk_1` FOREIGN KEY (`Shopinhaber`) REFERENCES `mitarbeiter` (`MitarbeitNr`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `zusteller`
--
ALTER TABLE `zusteller`
  ADD CONSTRAINT `zusteller_ibfk_4` FOREIGN KEY (`Zustellbezirk`) REFERENCES `bezirk` (`BezirkNr`),
  ADD CONSTRAINT `zusteller_ibfk_5` FOREIGN KEY (`AuftragNr`) REFERENCES `auftragv1` (`AuftragID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `zusteller_ibfk_6` FOREIGN KEY (`ZustellNr`) REFERENCES `mitarbeiter` (`MitarbeitNr`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
