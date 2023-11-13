-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-12-2021 a las 02:41:26
-- Versión del servidor: 10.4.21-MariaDB
-- Versión de PHP: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd2_p2`
--

DELIMITER $$
--
-- Procedimientos
--


CREATE DEFINER=`root`@`localhost` PROCEDURE `facturasprocedure` ()  BEGIN
    BEGIN
        DECLARE localId int(11);
        DECLARE localProxDataFact date;
        DECLARE localTipus varchar(20);
        DECLARE acabar int default false;
        DECLARE contratos CURSOR FOR SELECT id, proxDataFact, tipusContracte
                                     FROM contractes
                                     WHERE proxDataFact = (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY);
        DECLARE continue HANDLER FOR NOT FOUND SET acabar = TRUE;
        # recoger todos los contratos que tengan la fecha de proxima facturación de mañana
        OPEN contratos;
        # para cada contrato
        etiqueta:
        LOOP
            FETCH contratos INTO localId, localProxDataFact, localTipus;
            IF acabar THEN
                LEAVE etiqueta;
            END IF;
            IF localTipus = "mensual" THEN
                # actualizar su fecha de proxima facturación
                UPDATE contracte SET proxDataFact = localProxDataFact + INTERVAL 1 MONTH WHERE localID = id;
                # crear una factura
                INSERT INTO factura(data, import, vist, idContracte)
                VALUES (NOW(), 15, 0, localId);
            END IF;
            IF localTipus = "trimestral" THEN
                # actualizar su fecha de proxima facturación
                UPDATE contracte SET proxDataFact = localProxDataFact + INTERVAL 3 MONTH WHERE localId = id;
                # crear una factura
                INSERT INTO factura(data, import, vist, idContracte)
                VALUES (NOW(), 40, 0, localId);
            end if;
        END LOOP;
        CLOSE contratos;
    END;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generarRecomanacio` (IN `id` INT)  INSERT INTO missatge(data,vist,idContingut,nomUsuari)
SELECT NOW(),0,id, usuari.nomUsuari
from contingut
join categoria_favorit on categoria_favorit.categoria = contingut.categoria
JOIN contracte on contracte.idContracte = categoria_favorit.idContracte
JOIN tipususuari_contingut on tipususuari_contingut.idContingut=contingut.idContingut
JOIN usuari on usuari.nomUsuari = contracte.nomUsuari AND usuari.tipusUsuari = tipususuari_contingut.tipusUsuari
WHERE contingut.idContingut=id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `categoria` varchar(20) NOT NULL,
  `descripcio` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`categoria`, `descripcio`) VALUES
('accion', 'Altas dosis de adrenalina con peleas persecuciones y explosiones'),
('fantasia', 'Mundos y personajes magicos se hacen realidad'),
('misterio', 'Fenomenos sin explicacion esperan a ser desenmascarados'),
('romance', 'Temas amorosos totalmente relatables');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria_favorit`
--

CREATE TABLE `categoria_favorit` (
  `idContracte` int(11) NOT NULL,
  `categoria` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `categoria_favorit`
--

INSERT INTO `categoria_favorit` (`idContracte`, `categoria`) VALUES
(33, 'accion'),
(33, 'fantasia'),
(33, 'misterio'),
(33, 'romance');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contingut`
--

CREATE TABLE `contingut` (
  `idContingut` int(11) NOT NULL,
  `titol` varchar(40) NOT NULL,
  `URL` varchar(200) NOT NULL,
  `categoria` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contingut`
--

INSERT INTO `contingut` (`idContingut`, `titol`, `URL`, `categoria`) VALUES
(1, 'Rocky', 'ADGFuE7T8Qc', 'accion'),
(2, 'Fast and Furious', 'vsQVAQZjiUo', 'accion'),
(3, 'Misterios de Laura', 'yazClPcVfGM', 'misterio'),
(4, 'Sherlock Holmes', 'uUUi4ccE6-w', 'misterio'),
(5, 'After', '3OZBdwv5fyU', 'romance'),
(6, 'Crepusculo', 'bpcwhWgWfCc', 'romance'),
(7, 'Harry Potter', 'H65VbhCakb8', 'fantasia'),
(8, 'El señor de los anillos', 'kVa9q4DywiY', 'fantasia'),
(15, 'Origen', 'RV9L7ui9Cn8', 'fantasia'),
(16, 'Misión imposible', 'Ohws8y572KE', 'accion'),
(17, 'Fantastic Beasts: The Secrets of Dumbled', 'Y9dr2zw-TXQ', 'fantasia'),
(18, 'The Matrix Resurrection', 'nNpvWBuTfrc', 'fantasia'),
(19, 'Scary movie', 'q9QJ_S62yVo', 'misterio');

--
-- Disparadores `contingut`
--
DELIMITER $$
CREATE TRIGGER `eliminarContingut` BEFORE DELETE ON `contingut` FOR EACH ROW BEGIN 
DELETE FROM tipususuari_contingut WHERE idContingut = OLD.idContingut;
DELETE FROM missatge WHERE idContingut=OLD.idContingut;
DELETE FROM contingut_favorit WHERE idContingut = OLD.idContingut;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contingut_favorit`
--

CREATE TABLE `contingut_favorit` (
  `idContracte` int(11) NOT NULL,
  `idContingut` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contingut_favorit`
--

INSERT INTO `contingut_favorit` (`idContracte`, `idContingut`) VALUES
(33, 3),
(33, 5),
(33, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contracte`
--

CREATE TABLE `contracte` (
  `idContracte` int(11) NOT NULL,
  `dataAlta` date NOT NULL,
  `actiu` tinyint(1) NOT NULL,
  `proxDataFact` date NOT NULL,
  `tipusContracte` varchar(20) DEFAULT NULL,
  `nomUsuari` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contracte`
--

INSERT INTO `contracte` (`idContracte`, `dataAlta`, `actiu`, `proxDataFact`, `tipusContracte`, `nomUsuari`) VALUES
(30, '2021-12-18', 0, '0000-00-00', 'mensual', 'administrador'),
(31, '2021-12-18', 0, '0000-00-00', 'mensual', 'Odilo'),
(33, '2021-12-18', 1, '2022-01-18', 'mensual', 'iker');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `idfactura` int(11) NOT NULL,
  `data` date NOT NULL,
  `import` int(11) NOT NULL,
  `vist` tinyint(1) NOT NULL,
  `idContracte` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`idfactura`, `data`, `import`, `vist`, `idContracte`) VALUES
(9, '2021-12-15', 15, 0, 33),
(10, '2021-09-16', 10, 1, 33),
(11, '2021-06-17', 20, 0, 33),
(12, '2021-03-18', 16, 0, 33),
(13, '2020-12-23', 24, 1, 33);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `missatge`
--

CREATE TABLE `missatge` (
  `idmissatge` int(11) NOT NULL,
  `data` datetime NOT NULL,
  `vist` tinyint(1) NOT NULL,
  `idContingut` int(11) DEFAULT NULL,
  `nomUsuari` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `missatge`
--

INSERT INTO `missatge` (`idmissatge`, `data`, `vist`, `idContingut`, `nomUsuari`) VALUES
(37, '2021-12-20 02:17:11', 1, 2, 'iker'),
(39, '2021-12-20 02:18:21', 0, 15, 'iker');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipuscontracte`
--

CREATE TABLE `tipuscontracte` (
  `tipusContracte` varchar(20) NOT NULL,
  `duracioDies` int(11) NOT NULL,
  `preu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipuscontracte`
--

INSERT INTO `tipuscontracte` (`tipusContracte`, `duracioDies`, `preu`) VALUES
('mensual', 30, 10),
('trimestral', 90, 25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipususuari`
--

CREATE TABLE `tipususuari` (
  `tipusUsuari` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipususuari`
--

INSERT INTO `tipususuari` (`tipusUsuari`) VALUES
('adult'),
('menor'),
('mitja');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipususuari_contingut`
--

CREATE TABLE `tipususuari_contingut` (
  `tipusUsuari` varchar(10) NOT NULL,
  `idContingut` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipususuari_contingut`
--

INSERT INTO `tipususuari_contingut` (`tipusUsuari`, `idContingut`) VALUES
('adult', 1),
('adult', 3),
('adult', 4),
('adult', 17),
('adult', 19),
('menor', 1),
('menor', 6),
('menor', 7),
('menor', 8),
('menor', 16),
('menor', 18),
('mitja', 1),
('mitja', 2),
('mitja', 7),
('mitja', 8),
('mitja', 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuari`
--

CREATE TABLE `usuari` (
  `nomUsuari` varchar(20) NOT NULL,
  `contrasenya` varchar(255) NOT NULL,
  `mote` varchar(20) NOT NULL,
  `llinatges` varchar(40) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  `tipusUsuari` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuari`
--

INSERT INTO `usuari` (`nomUsuari`, `contrasenya`, `mote`, `llinatges`, `admin`, `tipusUsuari`) VALUES
('administrador', '$2y$10$.n.4E9BPfE/nmUF/uIY8SucUPR4t7q8z5Jlbg2WZZaGar3deAi096', 'Jaume', 'Jaume Mayol', 1, 'adult'),
('iker', '$2y$10$xHIK3QWZL74HgfqbMYgcE.8mC9.U7e6DsGHhokzqDgXa3jp/DcgPO', 'iker', 'diaz', 0, 'mitja'),
('Odilo', '$2y$10$wOxR/gPyzi3sXuaANvGCOOysUoyzcTpc4PE7ifTjBtMqJzdHROYiK', 'Odilo', 'Odilo', 0, 'adult');

--
-- Disparadores `usuari`
--
DELIMITER $$
CREATE TRIGGER `addContrato` AFTER INSERT ON `usuari` FOR EACH ROW BEGIN
        INSERT INTO contracte (dataAlta, actiu, proxDataFact, tipusContracte, nomUsuari)
            VALUES (NOW(), 0, 0000-00-00, "mensual", NEW.nomUsuari);
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`categoria`);

--
-- Indices de la tabla `categoria_favorit`
--
ALTER TABLE `categoria_favorit`
  ADD PRIMARY KEY (`idContracte`,`categoria`),
  ADD KEY `categoria` (`categoria`);

--
-- Indices de la tabla `contingut`
--
ALTER TABLE `contingut`
  ADD PRIMARY KEY (`idContingut`),
  ADD KEY `categoria` (`categoria`);

--
-- Indices de la tabla `contingut_favorit`
--
ALTER TABLE `contingut_favorit`
  ADD PRIMARY KEY (`idContracte`,`idContingut`),
  ADD KEY `idContingut` (`idContingut`);

--
-- Indices de la tabla `contracte`
--
ALTER TABLE `contracte`
  ADD PRIMARY KEY (`idContracte`),
  ADD KEY `tipusContracte` (`tipusContracte`),
  ADD KEY `nomUsuari` (`nomUsuari`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`idfactura`),
  ADD KEY `idContracte` (`idContracte`);

--
-- Indices de la tabla `missatge`
--
ALTER TABLE `missatge`
  ADD PRIMARY KEY (`idmissatge`),
  ADD KEY `idContingut` (`idContingut`),
  ADD KEY `nomUsuari` (`nomUsuari`);

--
-- Indices de la tabla `tipuscontracte`
--
ALTER TABLE `tipuscontracte`
  ADD PRIMARY KEY (`tipusContracte`);

--
-- Indices de la tabla `tipususuari`
--
ALTER TABLE `tipususuari`
  ADD PRIMARY KEY (`tipusUsuari`);

--
-- Indices de la tabla `tipususuari_contingut`
--
ALTER TABLE `tipususuari_contingut`
  ADD PRIMARY KEY (`tipusUsuari`,`idContingut`),
  ADD KEY `idContingut` (`idContingut`);

--
-- Indices de la tabla `usuari`
--
ALTER TABLE `usuari`
  ADD PRIMARY KEY (`nomUsuari`),
  ADD KEY `tipusUsuari` (`tipusUsuari`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `contingut`
--
ALTER TABLE `contingut`
  MODIFY `idContingut` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `contracte`
--
ALTER TABLE `contracte`
  MODIFY `idContracte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `idfactura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `missatge`
--
ALTER TABLE `missatge`
  MODIFY `idmissatge` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `categoria_favorit`
--
ALTER TABLE `categoria_favorit`
  ADD CONSTRAINT `categoria_favorit_ibfk_1` FOREIGN KEY (`idContracte`) REFERENCES `contracte` (`idContracte`),
  ADD CONSTRAINT `categoria_favorit_ibfk_2` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`categoria`);

--
-- Filtros para la tabla `contingut`
--
ALTER TABLE `contingut`
  ADD CONSTRAINT `contingut_ibfk_1` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`categoria`);

--
-- Filtros para la tabla `contingut_favorit`
--
ALTER TABLE `contingut_favorit`
  ADD CONSTRAINT `contingut_favorit_ibfk_1` FOREIGN KEY (`idContracte`) REFERENCES `contracte` (`idContracte`),
  ADD CONSTRAINT `contingut_favorit_ibfk_2` FOREIGN KEY (`idContingut`) REFERENCES `contingut` (`idContingut`);

--
-- Filtros para la tabla `contracte`
--
ALTER TABLE `contracte`
  ADD CONSTRAINT `contracte_ibfk_1` FOREIGN KEY (`tipusContracte`) REFERENCES `tipuscontracte` (`tipusContracte`),
  ADD CONSTRAINT `contracte_ibfk_2` FOREIGN KEY (`nomUsuari`) REFERENCES `usuari` (`nomUsuari`);

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`idContracte`) REFERENCES `contracte` (`idContracte`);

--
-- Filtros para la tabla `missatge`
--
ALTER TABLE `missatge`
  ADD CONSTRAINT `missatge_ibfk_1` FOREIGN KEY (`idContingut`) REFERENCES `contingut` (`idContingut`),
  ADD CONSTRAINT `missatge_ibfk_2` FOREIGN KEY (`nomUsuari`) REFERENCES `usuari` (`nomUsuari`);

--
-- Filtros para la tabla `tipususuari_contingut`
--
ALTER TABLE `tipususuari_contingut`
  ADD CONSTRAINT `tipususuari_contingut_ibfk_1` FOREIGN KEY (`tipusUsuari`) REFERENCES `tipususuari` (`tipusUsuari`),
  ADD CONSTRAINT `tipususuari_contingut_ibfk_2` FOREIGN KEY (`idContingut`) REFERENCES `contingut` (`idContingut`);

--
-- Filtros para la tabla `usuari`
--
ALTER TABLE `usuari`
  ADD CONSTRAINT `usuari_ibfk_1` FOREIGN KEY (`tipusUsuari`) REFERENCES `tipususuari` (`tipusUsuari`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `facturacion` ON SCHEDULE EVERY 1 DAY STARTS '2022-01-10 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL facturasprocedure()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
