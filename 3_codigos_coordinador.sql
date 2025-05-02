-- Paso 0: Eliminar valor inválido en FechReg
SET @@sql_mode = REPLACE(@@sql_mode, 'NO_ZERO_DATE', '');
SET @@sql_mode = REPLACE(@@sql_mode, 'STRICT_TRANS_TABLES', '');

UPDATE vriunap_pilar3.tblSecres
SET FechReg = CURRENT_TIMESTAMP
WHERE FechReg = '0000-00-00 00:00:00';

-- Paso 1: Verificar si la columna idCoordinador ya existe, si no, crearla
SET @existe_columna := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'vriunap_pilar3'
      AND TABLE_NAME = 'tblSecres'
      AND COLUMN_NAME = 'idCoordinador'
);

SET @crear_columna_sql := IF(@existe_columna = 0,
    'ALTER TABLE vriunap_pilar3.tblSecres ADD COLUMN idCoordinador INT NULL;',
    'SELECT 1;'
);

PREPARE stmt FROM @crear_columna_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Paso 2: Obtener el último idNuevo de MapeoDocente
SELECT MAX(idNuevo) INTO @ultimo_idNuevo FROM vriunap_pilar3.MapeoDocente;

-- Paso 3: Asignar idCoordinador único y secuencial por cada registro
UPDATE vriunap_pilar3.tblSecres s
JOIN (
    SELECT Id, @ultimo_idNuevo := @ultimo_idNuevo + 1 AS nuevoId
    FROM (
        SELECT Id FROM vriunap_pilar3.tblSecres ORDER BY Id
    ) AS ordenados
) AS asignacion ON s.Id = asignacion.Id
SET s.idCoordinador = asignacion.nuevoId;

-- Paso 4: Crear tabla MapeoCoordinador si no existe
CREATE TABLE IF NOT EXISTS vriunap_pilar3.MapeoCoordinador (
    idOriginal INT,
    idNuevo INT
);

-- Paso 5: Insertar mapeo real
INSERT INTO vriunap_pilar3.MapeoCoordinador (idOriginal, idNuevo)
SELECT Id, idCoordinador
FROM vriunap_pilar3.tblSecres
WHERE idCoordinador IS NOT NULL;
