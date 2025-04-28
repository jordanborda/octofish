-- Desactivar temporalmente las restricciones de SQL mode
SET SESSION sql_mode = '';

-- Verificar si la columna Activo existe antes de intentar añadirla
SET @exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'Activo'
);

-- Solo añadir la columna si no existe
SET @query = IF(@exists = 0,
    'ALTER TABLE `tesTramites` ADD `Activo` TINYINT NOT NULL DEFAULT 0',
    'SELECT "La columna Activo ya existe en la tabla tesTramites"'
);

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Actualizar los valores según el criterio
UPDATE `tesTramites` SET `Activo` = 1 WHERE `Tipo` > 1;

-- Variables para seguimiento
SET @contador = 1;

-- Actualizar los DNI vacíos con valores únicos secuenciales
UPDATE tblTesistas
SET DNI = CONCAT('0000000', @contador := @contador + 1)
WHERE DNI = '' OR DNI IS NULL;

-- Para asegurarnos que todos los números tengan 8 dígitos (formato estándar de DNI)
UPDATE tblTesistas
SET DNI = LPAD(DNI, 8, '0')
WHERE LENGTH(DNI) < 8 AND (DNI REGEXP '^[0-9]+$');

-- 1. Identificar usuarios duplicados
SELECT DNI, COUNT(*) as NumRegistros
FROM tblTesistas
GROUP BY DNI
HAVING COUNT(*) > 1;

-- Verificar si la tabla TesistasUnicos ya existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_name = 'TesistasUnicos'
);

-- Eliminar la tabla si ya existe
SET @drop_query = IF(@table_exists > 0, 
    'DROP TABLE TesistasUnicos', 
    'SELECT "La tabla TesistasUnicos no existe, no es necesario eliminarla"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1. Identificar los DNIs duplicados y el ID principal a conservar para cada DNI
CREATE TABLE TesistasUnicos
SELECT MIN(Id) as IdPrincipal, DNI
FROM tblTesistas
GROUP BY DNI;

-- Verificar si la tabla MapeoTesistas ya existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_name = 'MapeoTesistas'
);

-- Eliminar la tabla si ya existe
SET @drop_query = IF(@table_exists > 0, 
    'DROP TABLE MapeoTesistas', 
    'SELECT "La tabla MapeoTesistas no existe, no es necesario eliminarla"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. Crear tabla de mapeo completa que incluya TODOS los IDs, no solo los que cambiaron
CREATE TABLE MapeoTesistas
SELECT 
    ts.Id as IdOriginal, 
    COALESCE(tu.IdPrincipal, ts.Id) as IdPrincipal
FROM tblTesistas ts
LEFT JOIN TesistasUnicos tu ON ts.DNI = tu.DNI;

-- 3. Agregar índice para mejorar rendimiento
ALTER TABLE MapeoTesistas ADD INDEX (IdOriginal);

-- Verificar si la tabla tblTesistasCodigos ya existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_name = 'tblTesistasCodigos'
);

-- Eliminar la tabla si ya existe
SET @drop_query = IF(@table_exists > 0, 
    'DROP TABLE tblTesistasCodigos', 
    'SELECT "La tabla tblTesistasCodigos no existe, no es necesario eliminarla"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. Crear tabla para almacenar todos los códigos de estudiantes
CREATE TABLE tblTesistasCodigos (
  Id int NOT NULL AUTO_INCREMENT,
  IdTesista int NOT NULL,
  Codigo varchar(8) NOT NULL,
  IdCarrera int NOT NULL,
  IdFacultad int NOT NULL,
  IdEspec int NOT NULL,
  FechaReg datetime NULL,
  SemReg varchar(25) NOT NULL,
  PRIMARY KEY (Id),
  INDEX (IdTesista)
);

-- 5. Migrar TODOS los códigos de TODOS los tesistas a la nueva tabla
SET SESSION sql_mode = '';

-- Verificar que las columnas necesarias existen en tblTesistas antes de realizar la migración
SET @columns_exist = (
    SELECT COUNT(*) = 7
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tblTesistas'
    AND COLUMN_NAME IN ('Id', 'Codigo', 'IdCarrera', 'IdFacultad', 'IdEspec', 'FechaReg', 'SemReg')
);

SET @insert_query = IF(@columns_exist = 1,
    'INSERT INTO tblTesistasCodigos (IdTesista, Codigo, IdCarrera, IdFacultad, IdEspec, FechaReg, SemReg)
    SELECT 
        COALESCE(m.IdPrincipal, ts.Id) AS IdTesista, 
        ts.Codigo, 
        ts.IdCarrera, 
        ts.IdFacultad, 
        ts.IdEspec,
        ts.FechaReg,
        ts.SemReg
    FROM tblTesistas ts
    LEFT JOIN MapeoTesistas m ON ts.Id = m.IdOriginal',
    'SELECT "Faltan algunas columnas necesarias en tblTesistas para realizar la migración"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 6. Actualizar referencias en tesTramites para IdTesista1
UPDATE tesTramites t
JOIN MapeoTesistas m ON t.IdTesista1 = m.IdOriginal
SET t.IdTesista1 = m.IdPrincipal
WHERE m.IdOriginal != m.IdPrincipal;

-- 7. Actualizar referencias en tesTramites para IdTesista2
UPDATE tesTramites t
JOIN MapeoTesistas m ON t.IdTesista2 = m.IdOriginal
SET t.IdTesista2 = m.IdPrincipal
WHERE t.IdTesista2 > 0 AND m.IdOriginal != m.IdPrincipal;

-- 8. Eliminar los registros duplicados de tblTesistas
DELETE FROM tblTesistas
WHERE Id IN (SELECT IdOriginal FROM MapeoTesistas WHERE IdOriginal != IdPrincipal);

-- NOTA: Se ha quitado la parte que eliminaba las columnas de tblTesistas
-- para mantener la estructura original de la tabla con todas sus columnas

-- Usuarios con múltiples códigos (que antes tenían múltiples IDs)
SELECT 
    c.IdTesista, 
    t.DNI, 
    t.Nombres, 
    t.Apellidos, 
    COUNT(*) as NumCodigos,
    GROUP_CONCAT(c.Codigo) as Codigos
FROM tblTesistasCodigos c
JOIN tblTesistas t ON c.IdTesista = t.Id
GROUP BY c.IdTesista, t.DNI, t.Nombres, t.Apellidos
HAVING COUNT(*) > 1
ORDER BY NumCodigos DESC;

-- Ver los mapeos de IDs originales a IDs principales (ahora muestra TODOS los mapeos)
SELECT 
    m.IdOriginal as IdAntiguo, 
    m.IdPrincipal as IdNuevo,
    t.DNI,
    t.Nombres,
    t.Apellidos
FROM MapeoTesistas m
JOIN tblTesistas t ON m.IdPrincipal = t.Id
ORDER BY t.DNI, m.IdOriginal;

-- 1. Verificar qué IDs fueron reemplazados en tesTramites
SELECT 
    t.Id as IdTramite, 
    t.Codigo as CodigoTramite,
    m.IdOriginal as IdTesistaAntiguo, 
    t.IdTesista1 as IdTesistaActual,
    ts.DNI,
    ts.Nombres,
    ts.Apellidos
FROM tesTramites t
JOIN MapeoTesistas m ON m.IdPrincipal = t.IdTesista1
JOIN tblTesistas ts ON t.IdTesista1 = ts.Id
WHERE m.IdOriginal != m.IdPrincipal;

-- 2. Lo mismo para IdTesista2
SELECT 
    t.Id as IdTramite, 
    t.Codigo as CodigoTramite,
    m.IdOriginal as IdTesistaAntiguo, 
    t.IdTesista2 as IdTesistaActual,
    ts.DNI,
    ts.Nombres,
    ts.Apellidos
FROM tesTramites t
JOIN MapeoTesistas m ON m.IdPrincipal = t.IdTesista2
JOIN tblTesistas ts ON t.IdTesista2 = ts.Id
WHERE m.IdOriginal != m.IdPrincipal AND t.IdTesista2 > 0;

-- 3. Verificar que no haya referencias inválidas
SELECT COUNT(*) as ReferenciasInvalidas 
FROM tesTramites 
WHERE IdTesista1 NOT IN (SELECT Id FROM tblTesistas);

SELECT COUNT(*) as ReferenciasInvalidas 
FROM tesTramites 
WHERE IdTesista2 > 0 AND IdTesista2 NOT IN (SELECT Id FROM tblTesistas);

-- 4. Contar cuántos trámites tienen ahora el mismo tesista como IdTesista1 e IdTesista2
-- (esto podría indicar un error si no debería ocurrir)
SELECT COUNT(*) as TramitesConTesistasDuplicados
FROM tesTramites
WHERE IdTesista1 = IdTesista2 AND IdTesista2 > 0;