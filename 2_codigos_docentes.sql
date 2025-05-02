-- Paso 0: Corregir fechas inválidas en FechaCon solo si el campo no es NULL
SET @@sql_mode = REPLACE(@@sql_mode, 'NO_ZERO_DATE', '');

UPDATE vriunap_absmain.tblDocentes
SET FechaCon = CURDATE()
WHERE FechaCon = '0000-00-00';

-- Paso 1: Crear columna idDocente si no existe
SET @existe_columna := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'vriunap_absmain'
      AND TABLE_NAME = 'tblDocentes'
      AND COLUMN_NAME = 'idDocente'
);

SET @crear_columna_sql := IF(@existe_columna = 0,
    'ALTER TABLE vriunap_absmain.tblDocentes ADD COLUMN idDocente INT NULL;',
    'SELECT 1;'
);

PREPARE stmt FROM @crear_columna_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Paso 2: Obtener el último idNuevo de MapeoTesistas
SELECT MAX(idNuevo) INTO @ultimo_idNuevo FROM vriunap_pilar3.MapeoTesistas;

-- Paso 3: Asignar idDocente desde idTesista si el DNI ya existe en tblTesistas
UPDATE vriunap_absmain.tblDocentes d
JOIN vriunap_pilar3.tblTesistas t ON d.DNI = t.DNI
SET d.idDocente = t.idTesista
WHERE d.idDocente IS NULL AND t.idTesista IS NOT NULL;

-- Paso 4: Asignar nuevos idDocente (incrementales) solo a los que no fueron asignados desde tblTesistas
UPDATE vriunap_absmain.tblDocentes d
JOIN (
    SELECT DNI, @ultimo_idNuevo := @ultimo_idNuevo + 1 AS nuevoIdDocente
    FROM (
        SELECT DISTINCT DNI
        FROM vriunap_absmain.tblDocentes
        WHERE DNI IS NOT NULL AND DNI != '' AND idDocente IS NULL
        ORDER BY DNI
    ) AS lista
) AS t ON d.DNI = t.DNI
SET d.idDocente = t.nuevoIdDocente
WHERE d.idDocente IS NULL;

-- Paso 5: Crear tabla MapeoDocente si no existe
CREATE TABLE IF NOT EXISTS vriunap_pilar3.MapeoDocente (
    idOriginal INT,
    idNuevo INT
);

-- Paso 6: Insertar mapeo docente
INSERT INTO vriunap_pilar3.MapeoDocente (idOriginal, idNuevo)
SELECT Id AS idOriginal, idDocente AS idNuevo
FROM vriunap_absmain.tblDocentes
WHERE idDocente IS NOT NULL;
