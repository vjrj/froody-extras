SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `froody`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `froody_entry`
--

CREATE TABLE IF NOT EXISTS `froody_entry` (
  `entryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UID of entry',
  `userId` bigint(20) NOT NULL COMMENT 'User.userId',
  `creationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date of creation',
  `geohash` varchar(9) NOT NULL COMMENT 'Geohash (=Location)',
  `entryType` int(11) NOT NULL COMMENT 'Type of entry',
  `certificationType` int(11) NOT NULL COMMENT 'Type of certification',
  `distributionType` int(11) NOT NULL COMMENT 'Type of distribution',
  `contact` text CHARACTER SET utf8 NOT NULL COMMENT 'Contact info',
  `description` text CHARACTER SET utf8 NOT NULL COMMENT 'Description',
  `address` text CHARACTER SET utf8 NOT NULL COMMENT 'Resolved address',
  `modificationDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `wasDeleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'True if entry was deleted',
  `managementCode` int(11) NOT NULL COMMENT 'Code for manage/delete',
  PRIMARY KEY (`entryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='Entries are stored in here' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `froody_user`
--

CREATE TABLE IF NOT EXISTS `froody_user` (
  `userId` bigint(20) NOT NULL,
  `creationDate` datetime NOT NULL,
  `checkDate` datetime NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
