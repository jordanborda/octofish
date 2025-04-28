-- ======================================================================
-- IMPORTANTE: ¡REALICE UNA COPIA DE SEGURIDAD DE SU BASE DE DATOS ANTES DE EJECUTAR ESTE SCRIPT!
-- Base de datos destino: vriunap_pilar3
-- ======================================================================

-- Asegúrese de estar usando la base de datos correcta (descomentar si es necesario)
-- USE vriunap_pilar3;

-- ======================================================================
-- PASO 1: CORREGIR FECHAS INVÁLIDAS ('0000-00-00 00:00:00') EN FechReg
-- Necesario para que ALTER TABLE funcione correctamente.
-- ======================================================================
START TRANSACTION;

UPDATE `tblSecres`
SET `FechReg` = '1970-01-01 00:00:01'
WHERE CAST(`FechReg` AS CHAR) = '0000-00-00 00:00:00';

COMMIT; -- Confirma la corrección de fechas


-- ======================================================================
-- PASO 2: AÑADIR LAS NUEVAS COLUMNAS NOMBRES Y APELLIDOS
-- ======================================================================
ALTER TABLE `tblSecres`
ADD COLUMN `NOMBRES` VARCHAR(200) NULL DEFAULT NULL AFTER `Resp`,
ADD COLUMN `APELLIDOS` VARCHAR(200) NULL DEFAULT NULL AFTER `NOMBRES`;

-- Opcional: Añadir índice si se buscará frecuentemente por nombre/apellido
-- ALTER TABLE `tblSecres` ADD INDEX `idx_nombres_apellidos` (`APELLIDOS`, `NOMBRES`);


-- ======================================================================
-- PASO 3: POBLAR LAS COLUMNAS NOMBRES Y APELLIDOS PARA *TODAS* LAS FILAS
-- Si Resp parece un nombre, se usa la división manual precisa.
-- Si no, se divide la cadena Resp (Primera palabra -> NOMBRES, Resto -> APELLIDOS).
-- La columna Resp original NO se modifica.
-- ======================================================================
START TRANSACTION;

-- Casos con Nombres de Persona (División Manual Precisa)
UPDATE `tblSecres` SET `NOMBRES` = 'JUAN BAUTISTA', `APELLIDOS` = 'ASTORGA NEYRA' WHERE `Id` = 26210;
UPDATE `tblSecres` SET `NOMBRES` = 'ELISEO', `APELLIDOS` = 'FERNANDEZ RUELAS' WHERE `Id` = 26211;
UPDATE `tblSecres` SET `NOMBRES` = 'ERASMO', `APELLIDOS` = 'MANRIQUE ZEGARRA' WHERE `Id` = 26212;
UPDATE `tblSecres` SET `NOMBRES` = 'ALCIDES', `APELLIDOS` = 'PALACIOS SANCHEZ' WHERE `Id` = 26213;
UPDATE `tblSecres` SET `NOMBRES` = 'ROSENDA', `APELLIDOS` = 'AZA TACCA' WHERE `Id` = 26214;
UPDATE `tblSecres` SET `NOMBRES` = 'EUGENIO ALFREDO', `APELLIDOS` = 'CAMAC TORRES' WHERE `Id` = 26216;
UPDATE `tblSecres` SET `NOMBRES` = 'Yudi', `APELLIDOS` = 'Yucra Mamani' WHERE `Id` = 26217;
UPDATE `tblSecres` SET `NOMBRES` = 'ANGEL', `APELLIDOS` = 'CANALES GUTIERREZ' WHERE `Id` = 26218;
UPDATE `tblSecres` SET `NOMBRES` = 'SARA', `APELLIDOS` = 'ARISTA SANTISTEBAN' WHERE `Id` = 26219;
UPDATE `tblSecres` SET `NOMBRES` = 'Leonel', `APELLIDOS` = 'Coyla Idme' WHERE `Id` = 26220;
UPDATE `tblSecres` SET `NOMBRES` = 'JUAN CARLOS', `APELLIDOS` = 'MENDIZABAL GALLEGOS' WHERE `Id` = 26221;
UPDATE `tblSecres` SET `NOMBRES` = 'EDWIN', `APELLIDOS` = 'BOZA CONDORENA' WHERE `Id` = 26222;
UPDATE `tblSecres` SET `NOMBRES` = 'SONIA', `APELLIDOS` = 'MACEDO' WHERE `Id` = 26223;
UPDATE `tblSecres` SET `NOMBRES` = 'EDGAR VIDAL', `APELLIDOS` = 'HURTADO CHAVEZ' WHERE `Id` = 26225;
UPDATE `tblSecres` SET `NOMBRES` = 'EDILBERTO', `APELLIDOS` = 'VELARDE COAQUIRA' WHERE `Id` = 26226;
UPDATE `tblSecres` SET `NOMBRES` = 'GILBERTO', `APELLIDOS` = 'PEÑA VICUÑA' WHERE `Id` = 26227;
UPDATE `tblSecres` SET `NOMBRES` = 'Milder', `APELLIDOS` = 'Zanabria' WHERE `Id` = 26228;
UPDATE `tblSecres` SET `NOMBRES` = 'Pedro', `APELLIDOS` = 'Coila' WHERE `Id` = 26233; -- Extraído manualmente de 'Pedro Coila-...'
UPDATE `tblSecres` SET `NOMBRES` = 'DAVID', `APELLIDOS` = 'ZAIRA CHURATA' WHERE `Id` = 26237;
UPDATE `tblSecres` SET `NOMBRES` = 'ROSENDA', `APELLIDOS` = 'AZA TACCA' WHERE `Id` = 26238;
UPDATE `tblSecres` SET `NOMBRES` = 'Leonel', `APELLIDOS` = 'Coyla Idme' WHERE `Id` = 26250;
UPDATE `tblSecres` SET `NOMBRES` = 'Mirellia Janeth', `APELLIDOS` = 'Talavera Apaza' WHERE `Id` = 26254;
UPDATE `tblSecres` SET `NOMBRES` = 'MAXIMO AMANCIO', `APELLIDOS` = 'MONTALVO ATCO' WHERE `Id` = 26262;
UPDATE `tblSecres` SET `NOMBRES` = 'ARMANDO', `APELLIDOS` = 'CRUZ CABRERA' WHERE `Id` = 26263;
UPDATE `tblSecres` SET `NOMBRES` = 'Milder', `APELLIDOS` = 'Zanabria Ortega' WHERE `Id` = 26264;
UPDATE `tblSecres` SET `NOMBRES` = 'NEIDA LILIANA', `APELLIDOS` = 'RIVERA MAMANI' WHERE `Id` = 26265;
UPDATE `tblSecres` SET `NOMBRES` = 'ELIZABETH', `APELLIDOS` = 'CHOQUE SALLO' WHERE `Id` = 26266;
UPDATE `tblSecres` SET `NOMBRES` = 'BERTA', `APELLIDOS` = 'QUISPE' WHERE `Id` = 26267;
UPDATE `tblSecres` SET `NOMBRES` = 'MASSIEL', `APELLIDOS` = 'GONZALES CONDORI' WHERE `Id` = 26268;
UPDATE `tblSecres` SET `NOMBRES` = 'ROSENDA', `APELLIDOS` = 'AZA TACCA' WHERE `Id` = 26269;
UPDATE `tblSecres` SET `NOMBRES` = 'YOVANA', `APELLIDOS` = 'ARCAYA VALERIANO' WHERE `Id` = 26270;
UPDATE `tblSecres` SET `NOMBRES` = 'MERY NELIDA', `APELLIDOS` = 'CONDORI RAMOS' WHERE `Id` = 26271;
UPDATE `tblSecres` SET `NOMBRES` = 'KELLY DALIA', `APELLIDOS` = 'RÍOS SUCASACA' WHERE `Id` = 26272;
UPDATE `tblSecres` SET `NOMBRES` = 'YRMA', `APELLIDOS` = 'RUELAS ORTEGA' WHERE `Id` = 26273;
UPDATE `tblSecres` SET `NOMBRES` = 'MARY LUZ', `APELLIDOS` = 'ÑACA COPA' WHERE `Id` = 26274;
UPDATE `tblSecres` SET `NOMBRES` = 'ANGEL JOGUES', `APELLIDOS` = 'CALSINA PONCE' WHERE `Id` = 26275;
UPDATE `tblSecres` SET `NOMBRES` = 'NADIA YANETT', `APELLIDOS` = 'PINEDA CHAQUILLA' WHERE `Id` = 26276;
UPDATE `tblSecres` SET `NOMBRES` = 'BERNARDA', `APELLIDOS` = 'QUISPE ALANIA' WHERE `Id` = 26277;
UPDATE `tblSecres` SET `NOMBRES` = 'EDWIN RAFAEL', `APELLIDOS` = 'ACEITUNO LÓPEZ' WHERE `Id` = 26278;
UPDATE `tblSecres` SET `NOMBRES` = 'YENNY', `APELLIDOS` = 'AGUIRRE LUNA' WHERE `Id` = 26279;
UPDATE `tblSecres` SET `NOMBRES` = 'HILDA FIDELA', `APELLIDOS` = 'YANARICO MONROY' WHERE `Id` = 26280;
UPDATE `tblSecres` SET `NOMBRES` = 'SUSANA', `APELLIDOS` = 'QUISPE VARGAS' WHERE `Id` = 26281;
UPDATE `tblSecres` SET `NOMBRES` = 'NORMA', `APELLIDOS` = 'FERNANDEZ COPA' WHERE `Id` = 26282;
UPDATE `tblSecres` SET `NOMBRES` = 'AMANDA AYDEE', `APELLIDOS` = 'ORDOÑEZ PACORI' WHERE `Id` = 26283;
UPDATE `tblSecres` SET `NOMBRES` = 'Amilcar', `APELLIDOS` = 'Chavez' WHERE `Id` = 26285;
UPDATE `tblSecres` SET `NOMBRES` = 'Elida', `APELLIDOS` = 'Heredia Quispe' WHERE `Id` = 26286;
UPDATE `tblSecres` SET `NOMBRES` = 'María Luz', `APELLIDOS` = 'Choquehuanca Panclas' WHERE `Id` = 26287;
UPDATE `tblSecres` SET `NOMBRES` = 'ISABEL', `APELLIDOS` = 'HITO MONTAÑO' WHERE `Id` = 26288;
UPDATE `tblSecres` SET `NOMBRES` = 'JOSÉ PANFILO', `APELLIDOS` = 'TITO LIPA' WHERE `Id` = 26289;
UPDATE `tblSecres` SET `NOMBRES` = 'Fernando Benigno', `APELLIDOS` = 'Salas Urviola' WHERE `Id` = 26290;
UPDATE `tblSecres` SET `NOMBRES` = 'Fredy', `APELLIDOS` = 'Calsin Apaza' WHERE `Id` = 26291;
UPDATE `tblSecres` SET `NOMBRES` = 'Elizabeth', `APELLIDOS` = 'Quispe Javier' WHERE `Id` = 26292;
UPDATE `tblSecres` SET `NOMBRES` = 'Jose', `APELLIDOS` = 'Tito Lipa' WHERE `Id` = 26293;
UPDATE `tblSecres` SET `NOMBRES` = 'Darssy Argélida', `APELLIDOS` = 'Carpio Ramos' WHERE `Id` = 26294;
UPDATE `tblSecres` SET `NOMBRES` = 'Andrés', `APELLIDOS` = 'Olivera Chura' WHERE `Id` = 26295;
UPDATE `tblSecres` SET `NOMBRES` = 'Luis amilcar', `APELLIDOS` = 'Bueno Macedo' WHERE `Id` = 26296;
UPDATE `tblSecres` SET `NOMBRES` = 'Sandra Imelda', `APELLIDOS` = 'Huargaya Quispe' WHERE `Id` = 26297;
UPDATE `tblSecres` SET `NOMBRES` = 'Alicia Magaly', `APELLIDOS` = 'León Tacca' WHERE `Id` = 26298;
UPDATE `tblSecres` SET `NOMBRES` = 'RISTÓBAL RUFINO', `APELLIDOS` = 'YAPUCHURA SAICO' WHERE `Id` = 26299;
UPDATE `tblSecres` SET `NOMBRES` = 'Vidnay Noel', `APELLIDOS` = 'Valero Ancco' WHERE `Id` = 26300;
UPDATE `tblSecres` SET `NOMBRES` = 'James Rolando', `APELLIDOS` = 'Arredondo Mamani' WHERE `Id` = 26301;
UPDATE `tblSecres` SET `NOMBRES` = 'Juan José', `APELLIDOS` = 'Pauro Roque' WHERE `Id` = 26302;
UPDATE `tblSecres` SET `NOMBRES` = 'Julio Fredy', `APELLIDOS` = 'Chura Acero' WHERE `Id` = 26303;
UPDATE `tblSecres` SET `NOMBRES` = 'Roberto', `APELLIDOS` = 'Alfaro Alejo' WHERE `Id` = 26304;
UPDATE `tblSecres` SET `NOMBRES` = 'Javier Santos', `APELLIDOS` = 'Puma Llanqui' WHERE `Id` = 26305;
UPDATE `tblSecres` SET `NOMBRES` = 'Guina Guadalupe', `APELLIDOS` = 'Sotomayor' WHERE `Id` = 26306;
UPDATE `tblSecres` SET `NOMBRES` = 'EMILIO', `APELLIDOS` = 'CASTILLO ARONI' WHERE `Id` = 26307;
UPDATE `tblSecres` SET `NOMBRES` = 'Luz Dominga', `APELLIDOS` = 'Mamani Cahuata' WHERE `Id` = 26308;
UPDATE `tblSecres` SET `NOMBRES` = 'Gabriela', `APELLIDOS` = 'Cornejo Valdivia' WHERE `Id` = 26309;
UPDATE `tblSecres` SET `NOMBRES` = 'MARTHA', `APELLIDOS` = 'YUCRA SOTOMAYOR' WHERE `Id` = 26311;
UPDATE `tblSecres` SET `NOMBRES` = 'BORIS GILMAR', `APELLIDOS` = 'ESPEZUA SALMON' WHERE `Id` = 26312;
UPDATE `tblSecres` SET `NOMBRES` = 'LUIS ALBERTO', `APELLIDOS` = 'MAMANI HUANCA' WHERE `Id` = 26313;
UPDATE `tblSecres` SET `NOMBRES` = 'ERIK RAZIEL', `APELLIDOS` = 'GODOY VILCA' WHERE `Id` = 26314;
UPDATE `tblSecres` SET `NOMBRES` = 'ANTONIO', `APELLIDOS` = 'HOLGUINO HUARZA' WHERE `Id` = 26315;
UPDATE `tblSecres` SET `NOMBRES` = 'Benjamín', `APELLIDOS` = 'Velazco Reyes' WHERE `Id` = 26316;
UPDATE `tblSecres` SET `NOMBRES` = 'JULIO CESAR', `APELLIDOS` = 'SARDON HUAYAPA' WHERE `Id` = 26317;
UPDATE `tblSecres` SET `NOMBRES` = 'Lidia Ensueño', `APELLIDOS` = 'Romero Iruri' WHERE `Id` = 26318;
UPDATE `tblSecres` SET `NOMBRES` = 'Sofía Lourdes', `APELLIDOS` = 'Benavente Fernández' WHERE `Id` = 26319;
UPDATE `tblSecres` SET `NOMBRES` = 'ALEJANDRO', `APELLIDOS` = 'COLOMA PAXI' WHERE `Id` = 26320;
UPDATE `tblSecres` SET `NOMBRES` = 'JUAN', `APELLIDOS` = 'INQUILLA MAMANI' WHERE `Id` = 26321;
UPDATE `tblSecres` SET `NOMBRES` = 'MANUEL', `APELLIDOS` = 'ANCHAPURI QUISPE' WHERE `Id` = 26322;
UPDATE `tblSecres` SET `NOMBRES` = 'Angel Jogues', `APELLIDOS` = 'Calsina Ponce' WHERE `Id` = 26323;
UPDATE `tblSecres` SET `NOMBRES` = 'María Isabel', `APELLIDOS` = 'Vallenas Gaona' WHERE `Id` = 26324;
UPDATE `tblSecres` SET `NOMBRES` = 'Edson Gilmer', `APELLIDOS` = 'QUISPE PONCE' WHERE `Id` = 26325;
UPDATE `tblSecres` SET `NOMBRES` = 'PERCY', `APELLIDOS` = 'QUISPE PINEDA' WHERE `Id` = 26326;
UPDATE `tblSecres` SET `NOMBRES` = 'ELENA', `APELLIDOS` = 'YUNGA ZEGARRA' WHERE `Id` = 26327;
UPDATE `tblSecres` SET `NOMBRES` = 'RUBEN ARTURO', `APELLIDOS` = 'CACSIRE GRIMALDOS' WHERE `Id` = 26328;
UPDATE `tblSecres` SET `NOMBRES` = 'Gladys', `APELLIDOS` = 'Vilca Pacco' WHERE `Id` = 26329;
UPDATE `tblSecres` SET `NOMBRES` = 'Edilberto', `APELLIDOS` = 'VELARDE COAQUIRA' WHERE `Id` = 26330;
UPDATE `tblSecres` SET `NOMBRES` = 'Nilda Elizabeth', `APELLIDOS` = 'Nuñez' WHERE `Id` = 26331;
UPDATE `tblSecres` SET `NOMBRES` = 'Jessica Milena', `APELLIDOS` = 'EURIBE PUMA' WHERE `Id` = 26332;
UPDATE `tblSecres` SET `NOMBRES` = 'Dante Elmer', `APELLIDOS` = 'Hancco Monrroy' WHERE `Id` = 26333;
UPDATE `tblSecres` SET `NOMBRES` = 'Marco Antonio', `APELLIDOS` = 'Ruelas Humpiri' WHERE `Id` = 26334;
UPDATE `tblSecres` SET `NOMBRES` = 'Juana Idelza', `APELLIDOS` = 'Zavaleta Gomez' WHERE `Id` = 26335;
UPDATE `tblSecres` SET `NOMBRES` = 'Efrain Humberto', `APELLIDOS` = 'Yupanqui Pino' WHERE `Id` = 26336;
UPDATE `tblSecres` SET `NOMBRES` = 'Mario Milton', `APELLIDOS` = 'Quisocala Lipa' WHERE `Id` = 26337;
UPDATE `tblSecres` SET `NOMBRES` = 'Jaime', `APELLIDOS` = 'Ortiz Gallegos' WHERE `Id` = 26338;
UPDATE `tblSecres` SET `NOMBRES` = 'Leonel', `APELLIDOS` = 'Palomino Ascencio' WHERE `Id` = 26339;
UPDATE `tblSecres` SET `NOMBRES` = 'Lucas', `APELLIDOS` = 'Ponce Quispe' WHERE `Id` = 26340;
UPDATE `tblSecres` SET `NOMBRES` = 'EVA MARINA', `APELLIDOS` = 'CENTENO ZAVALA' WHERE `Id` = 26341;
UPDATE `tblSecres` SET `NOMBRES` = 'KARLOS ALEXANDER', `APELLIDOS` = 'CCANTUTA CHIRAPO' WHERE `Id` = 26342;
UPDATE `tblSecres` SET `NOMBRES` = 'FREDY BERNARDO', `APELLIDOS` = 'COYLA APAZA' WHERE `Id` = 26343;
UPDATE `tblSecres` SET `NOMBRES` = 'KARLOS ALEXANDER', `APELLIDOS` = 'CCANTUTA CHIRAPO' WHERE `Id` = 26344;
UPDATE `tblSecres` SET `NOMBRES` = 'Alfredo', `APELLIDOS` = 'Tumi Figueroa' WHERE `Id` = 26345;
UPDATE `tblSecres` SET `NOMBRES` = 'RÓMULO', `APELLIDOS` = 'HUACASI GONZALES' WHERE `Id` = 26346;
UPDATE `tblSecres` SET `NOMBRES` = 'Ludwing Roald', `APELLIDOS` = 'Flores Quispe' WHERE `Id` = 26347;
UPDATE `tblSecres` SET `NOMBRES` = 'ILLICH XAVIER', `APELLIDOS` = 'TALAVERA SALAS' WHERE `Id` = 26348;
UPDATE `tblSecres` SET `NOMBRES` = 'Gustavo', `APELLIDOS` = 'Medina Vilca' WHERE `Id` = 26349;
UPDATE `tblSecres` SET `NOMBRES` = 'JUAN CARLOS', `APELLIDOS` = 'JUAREZ VARGAS' WHERE `Id` = 26350;
UPDATE `tblSecres` SET `NOMBRES` = 'JUAN CARLOS', `APELLIDOS` = 'JUAREZ VARGAS' WHERE `Id` = 26351;
UPDATE `tblSecres` SET `NOMBRES` = 'Felix Henry', `APELLIDOS` = 'Gutierrez Castillo' WHERE `Id` = 26352;
UPDATE `tblSecres` SET `NOMBRES` = 'VICKY CRISTINA', `APELLIDOS` = 'GONZALES ALCOS' WHERE `Id` = 26353;
UPDATE `tblSecres` SET `NOMBRES` = 'MARISOL', `APELLIDOS` = 'HUAMAN FLORES' WHERE `Id` = 26354;
UPDATE `tblSecres` SET `NOMBRES` = 'Rene', `APELLIDOS` = 'Mamani Yucra' WHERE `Id` = 26355;
UPDATE `tblSecres` SET `NOMBRES` = 'Victoriano Rolando', `APELLIDOS` = 'Apaza Campos' WHERE `Id` = 26356;
UPDATE `tblSecres` SET `NOMBRES` = 'SABINO EDGAR', `APELLIDOS` = 'MAMANI CHOQUE' WHERE `Id` = 26357;
UPDATE `tblSecres` SET `NOMBRES` = 'Hipolito', `APELLIDOS` = 'Cordova Gutierrez' WHERE `Id` = 26358;
UPDATE `tblSecres` SET `NOMBRES` = 'German', `APELLIDOS` = 'Quille Calizaya' WHERE `Id` = 26359;
UPDATE `tblSecres` SET `NOMBRES` = 'Ulises', `APELLIDOS` = 'Alvarado Mamani' WHERE `Id` = 26360;
UPDATE `tblSecres` SET `NOMBRES` = 'Americo', `APELLIDOS` = 'Arizaca Avalos' WHERE `Id` = 26361;
UPDATE `tblSecres` SET `NOMBRES` = 'SILVIA', `APELLIDOS` = 'ALEJO VISA' WHERE `Id` = 26362;
UPDATE `tblSecres` SET `NOMBRES` = 'HENRY', `APELLIDOS` = 'CATACORA MAYTA' WHERE `Id` = 26363;
UPDATE `tblSecres` SET `NOMBRES` = 'Alcides', `APELLIDOS` = 'Flores Paredes' WHERE `Id` = 26364;
UPDATE `tblSecres` SET `NOMBRES` = 'Melissa Soledad', `APELLIDOS` = 'Bravo Montesinos' WHERE `Id` = 26365;
UPDATE `tblSecres` SET `NOMBRES` = 'FELIX', `APELLIDOS` = 'QUISPE MAMANI' WHERE `Id` = 26366;
UPDATE `tblSecres` SET `NOMBRES` = 'MANUEL ALFREDO', `APELLIDOS` = 'CALLOHUANCA PARIAPAZA' WHERE `Id` = 26367;
UPDATE `tblSecres` SET `NOMBRES` = 'VALERIANO', `APELLIDOS` = 'CONDORI APAZA' WHERE `Id` = 26368;
UPDATE `tblSecres` SET `NOMBRES` = 'EUFEMIA', `APELLIDOS` = 'MARRON HUARANCA' WHERE `Id` = 26369;
UPDATE `tblSecres` SET `NOMBRES` = 'Lourdes', `APELLIDOS` = 'Soto Cruz' WHERE `Id` = 26370;
UPDATE `tblSecres` SET `NOMBRES` = 'Karlos Alexander', `APELLIDOS` = 'Ccantuta Chirapo' WHERE `Id` = 26371;
UPDATE `tblSecres` SET `NOMBRES` = 'Henry', `APELLIDOS` = 'Quispe Cruz' WHERE `Id` = 26372;
UPDATE `tblSecres` SET `NOMBRES` = 'LUIS ALFREDO', `APELLIDOS` = 'PALAO ITURREGUI' WHERE `Id` = 26373;
UPDATE `tblSecres` SET `NOMBRES` = 'Felipe', `APELLIDOS` = 'Condori Chambilla' WHERE `Id` = 26374;
UPDATE `tblSecres` SET `NOMBRES` = 'JAIME', `APELLIDOS` = 'MEDINA LIMA' WHERE `Id` = 26375;
UPDATE `tblSecres` SET `NOMBRES` = 'Jose Antonio', `APELLIDOS` = 'Supo Gutierrez' WHERE `Id` = 26376;
UPDATE `tblSecres` SET `NOMBRES` = 'Yanina mitza', `APELLIDOS` = 'Arias Huaco' WHERE `Id` = 26377;
UPDATE `tblSecres` SET `NOMBRES` = 'Jose Antonio', `APELLIDOS` = 'Supo Gutierrez' WHERE `Id` = 26378;
UPDATE `tblSecres` SET `NOMBRES` = 'Yanina Mitza', `APELLIDOS` = 'Arias Huaco' WHERE `Id` = 26379;
UPDATE `tblSecres` SET `NOMBRES` = 'José Alberto', `APELLIDOS` = 'Llanos Condori' WHERE `Id` = 26380;
UPDATE `tblSecres` SET `NOMBRES` = 'Adelaida', `APELLIDOS` = 'Otazu Conza' WHERE `Id` = 26381;
UPDATE `tblSecres` SET `NOMBRES` = 'MARITZA YOLANDA', `APELLIDOS` = 'QUEA GUTIERREZ' WHERE `Id` = 26382;
UPDATE `tblSecres` SET `NOMBRES` = 'Mauro Octavio', `APELLIDOS` = 'Tapia Cruz' WHERE `Id` = 26383;
UPDATE `tblSecres` SET `NOMBRES` = 'Betsy Zelmira', `APELLIDOS` = 'Avalos Alejo' WHERE `Id` = 26384;
UPDATE `tblSecres` SET `NOMBRES` = 'Edson Gilmar', `APELLIDOS` = 'Quispe Ponce' WHERE `Id` = 26385;
UPDATE `tblSecres` SET `NOMBRES` = 'Jose Carlos', `APELLIDOS` = 'Cucho Cruz' WHERE `Id` = 26388;
UPDATE `tblSecres` SET `NOMBRES` = 'EDUARDO', `APELLIDOS` = 'SOTOMAYOR ABARCA' WHERE `Id` = 26389;
UPDATE `tblSecres` SET `NOMBRES` = 'SAMUEL', `APELLIDOS` = 'GALLEGOS COPA' WHERE `Id` = 26390;
UPDATE `tblSecres` SET `NOMBRES` = 'Andres', `APELLIDOS` = 'Olivera Chura' WHERE `Id` = 26391;
UPDATE `tblSecres` SET `NOMBRES` = 'GRISELDA CATTY', `APELLIDOS` = 'LUNA RAMIREZ' WHERE `Id` = 26392;
UPDATE `tblSecres` SET `NOMBRES` = 'MARTHA ROSARIO', `APELLIDOS` = 'PALOMINO COILA' WHERE `Id` = 26393;
UPDATE `tblSecres` SET `NOMBRES` = 'Ruth Mery', `APELLIDOS` = 'Cruz Huisa' WHERE `Id` = 26394;
UPDATE `tblSecres` SET `NOMBRES` = 'BORIS GILMAR', `APELLIDOS` = 'ESPEZUA SALMON' WHERE `Id` = 26395;
UPDATE `tblSecres` SET `NOMBRES` = 'JUANA IDELZA', `APELLIDOS` = 'ZAVALETA GOMEZ' WHERE `Id` = 26396;
UPDATE `tblSecres` SET `NOMBRES` = 'GRISELL', `APELLIDOS` = 'ALIAGA MELO' WHERE `Id` = 26397;
UPDATE `tblSecres` SET `NOMBRES` = 'Midwar Elias', `APELLIDOS` = 'Valencia Vilca' WHERE `Id` = 26398;
UPDATE `tblSecres` SET `NOMBRES` = 'Domingo Alberto', `APELLIDOS` = 'Ruelas Calloapaza' WHERE `Id` = 26400;
UPDATE `tblSecres` SET `NOMBRES` = 'ELSA MARIA', `APELLIDOS` = 'MAMANI TAPIA' WHERE `Id` = 26401;

-- Casos con Nombres NO de Persona (División Automática: 1ª Palabra -> NOMBRES, Resto -> APELLIDOS)
UPDATE `tblSecres` SET `NOMBRES` = '----', `APELLIDOS` = NULL WHERE `Id` = 26215; -- Resp = '----'
UPDATE `tblSecres` SET `NOMBRES` = '-', `APELLIDOS` = NULL WHERE `Id` = 26224; -- Resp = '-'
UPDATE `tblSecres` SET `NOMBRES` = 'ADMINISTRADORES', `APELLIDOS` = 'PILAR' WHERE `Id` = 26229; -- Resp = 'ADMINISTRADORES PILAR'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'AGRONÓMICA' WHERE `Id` = 26230; -- Resp = 'INGENIERÍA AGRONÓMICA'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'AGROINDUSTRIAL' WHERE `Id` = 26231; -- Resp = 'INGENIERÍA AGROINDUSTRIAL'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'TOPOGRÁFICA Y AGRIMENSURA' WHERE `Id` = 26232; -- Resp = 'INGENIERÍA TOPOGRÁFICA Y AGRIMENSURA'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'ECONÓMICA' WHERE `Id` = 26234; -- Resp = 'INGENIERÍA ECONÓMICA'
UPDATE `tblSecres` SET `NOMBRES` = 'ADMINISTRACIÓN', `APELLIDOS` = NULL WHERE `Id` = 26235; -- Resp = 'ADMINISTRACIÓN'
UPDATE `tblSecres` SET `NOMBRES` = 'CIENCIAS', `APELLIDOS` = 'CONTABLES' WHERE `Id` = 26236; -- Resp = 'CIENCIAS CONTABLES'
UPDATE `tblSecres` SET `NOMBRES` = 'ANTROPOLOGÍA', `APELLIDOS` = NULL WHERE `Id` = 26239; -- Resp = 'ANTROPOLOGÍA'
UPDATE `tblSecres` SET `NOMBRES` = 'ARTE', `APELLIDOS` = NULL WHERE `Id` = 26240; -- Resp = 'ARTE'
UPDATE `tblSecres` SET `NOMBRES` = 'CIENCIAS', `APELLIDOS` = 'DE LA COMUNICACIÓN SOCIAL' WHERE `Id` = 26241; -- Resp = 'CIENCIAS DE LA COMUNICACIÓN SOCIAL'
UPDATE `tblSecres` SET `NOMBRES` = 'SOCIOLOGÍA', `APELLIDOS` = NULL WHERE `Id` = 26242; -- Resp = 'SOCIOLOGÍA'
UPDATE `tblSecres` SET `NOMBRES` = 'TURISMO', `APELLIDOS` = NULL WHERE `Id` = 26243; -- Resp = 'TURISMO'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'DE MINAS' WHERE `Id` = 26244; -- Resp = 'INGENIERÍA DE MINAS'
UPDATE `tblSecres` SET `NOMBRES` = 'BIOLOGIA', `APELLIDOS` = NULL WHERE `Id` = 26245; -- Resp = 'BIOLOGIA'
UPDATE `tblSecres` SET `NOMBRES` = 'EDUCACIÓN', `APELLIDOS` = 'FÍSICA' WHERE `Id` = 26246; -- Resp = 'EDUCACIÓN FÍSICA'
UPDATE `tblSecres` SET `NOMBRES` = 'EDUCACIÓN', `APELLIDOS` = 'INICIAL' WHERE `Id` = 26247; -- Resp = 'EDUCACIÓN INICIAL'
UPDATE `tblSecres` SET `NOMBRES` = 'EDUCACIÓN', `APELLIDOS` = 'PRIMARIA' WHERE `Id` = 26248; -- Resp = 'EDUCACIÓN PRIMARIA'
UPDATE `tblSecres` SET `NOMBRES` = 'EDUCACION', `APELLIDOS` = 'SECUNDARIA' WHERE `Id` = 26249; -- Resp = 'EDUCACION SECUNDARIA'
UPDATE `tblSecres` SET `NOMBRES` = 'DERECHO', `APELLIDOS` = NULL WHERE `Id` = 26251; -- Resp = 'DERECHO'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'QUÍMICA' WHERE `Id` = 26252; -- Resp = 'INGENIERÍA QUÍMICA'
UPDATE `tblSecres` SET `NOMBRES` = 'NUTRICIÓN', `APELLIDOS` = 'HUMANA' WHERE `Id` = 26253; -- Resp = 'NUTRICIÓN HUMANA'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'GEOLÓGICA' WHERE `Id` = 26255; -- Resp = 'INGENIERÍA GEOLÓGICA'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'METALÚRGICA' WHERE `Id` = 26256; -- Resp = 'INGENIERÍA METALÚRGICA'
UPDATE `tblSecres` SET `NOMBRES` = 'ARQUITECTURA', `APELLIDOS` = 'Y URBANISMO' WHERE `Id` = 26257; -- Resp = 'ARQUITECTURA Y URBANISMO'
UPDATE `tblSecres` SET `NOMBRES` = 'CIENCIAS', `APELLIDOS` = 'FISICO MATEMATICAS' WHERE `Id` = 26258; -- Resp = 'CIENCIAS FISICO MATEMATICAS'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'CIVIL' WHERE `Id` = 26259; -- Resp = 'INGENIERÍA CIVIL'
UPDATE `tblSecres` SET `NOMBRES` = 'INGENIERÍA', `APELLIDOS` = 'AGRÍCOLA' WHERE `Id` = 26260; -- Resp = 'INGENIERÍA AGRÍCOLA'
UPDATE `tblSecres` SET `NOMBRES` = 'MEDICINA', `APELLIDOS` = 'HUMANA' WHERE `Id` = 26261; -- Resp = 'MEDICINA HUMANA'
UPDATE `tblSecres` SET `NOMBRES` = 'DERECHO', `APELLIDOS` = NULL WHERE `Id` = 26284; -- Resp = 'DERECHO'
UPDATE `tblSecres` SET `NOMBRES` = 'EDUCACIÓN', `APELLIDOS` = 'SECUNDARIA' WHERE `Id` = 26310; -- Resp = 'EDUCACIÓN SECUNDARIA'
UPDATE `tblSecres` SET `NOMBRES` = 'User', `APELLIDOS` = 'Control de Calidad' WHERE `Id` = 26386; -- Resp = 'User Control de Calidad'
UPDATE `tblSecres` SET `NOMBRES` = 'Coordinación', `APELLIDOS` = 'Estadística' WHERE `Id` = 26387; -- Resp = 'Coordinación Estadística'
UPDATE `tblSecres` SET `NOMBRES` = 'Supid', `APELLIDOS` = NULL WHERE `Id` = 26399; -- Resp = 'Supid'

-- Confirma los cambios de la población de nombres/apellidos
COMMIT;
-- Si algo salió mal durante la población, use ROLLBACK; en lugar de COMMIT;

-- ======================================================================
-- PROCESO COMPLETADO
-- Las columnas NOMBRES y APELLIDOS han sido añadidas y pobladas.
-- La columna Resp original se mantiene intacta.
-- Las fechas inválidas han sido corregidas.
-- ======================================================================