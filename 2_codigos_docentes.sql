-- Desactivar temporalmente las restricciones de SQL mode
SET SESSION sql_mode = '';

-- Comprobar si existen DNIs duplicados en tblDocentes
SELECT DNI, COUNT(*) as NumRegistros
FROM tblDocentes
GROUP BY DNI
HAVING COUNT(*) > 1;

-- Verificar si la tabla MapeoDocentes ya existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_name = 'MapeoDocentes'
);

-- Eliminar la tabla si ya existe
SET @drop_query = IF(@table_exists > 0, 
    'DROP TABLE MapeoDocentes', 
    'SELECT "La tabla MapeoDocentes no existe, no es necesario eliminarla"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1. Encontrar el valor máximo de Id en tblTesistas
SET @max_tesista_id = (SELECT MAX(Id) FROM vriunap_pilar3.tblTesistas);

-- 2. Crear tabla de mapeo completa para los IDs de docentes (incluye todos los IDs)
CREATE TABLE MapeoDocentes
SELECT 
    Id as IdOriginal,
    (@row_number:=@row_number+1) + @max_tesista_id as IdNuevo
FROM tblDocentes,
    (SELECT @row_number:=0) as r
ORDER BY Id;

-- 3. Crear índice para mejorar rendimiento
ALTER TABLE MapeoDocentes ADD INDEX (IdOriginal);

-- 4. Actualizar referencias en tesTramites para IdJurado1-5
-- Verificar antes de actualizar para evitar errores
SET @jurado1_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'IdJurado1'
);

SET @update_query = IF(@jurado1_column_exists > 0,
    'UPDATE vriunap_pilar3.tesTramites t
    JOIN MapeoDocentes m ON t.IdJurado1 = m.IdOriginal
    SET t.IdJurado1 = m.IdNuevo',
    'SELECT "La columna IdJurado1 no existe en tesTramites"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @jurado2_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'IdJurado2'
);

SET @update_query = IF(@jurado2_column_exists > 0,
    'UPDATE vriunap_pilar3.tesTramites t
    JOIN MapeoDocentes m ON t.IdJurado2 = m.IdOriginal
    SET t.IdJurado2 = m.IdNuevo',
    'SELECT "La columna IdJurado2 no existe en tesTramites"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @jurado3_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'IdJurado3'
);

SET @update_query = IF(@jurado3_column_exists > 0,
    'UPDATE vriunap_pilar3.tesTramites t
    JOIN MapeoDocentes m ON t.IdJurado3 = m.IdOriginal
    SET t.IdJurado3 = m.IdNuevo',
    'SELECT "La columna IdJurado3 no existe en tesTramites"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @jurado4_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'IdJurado4'
);

SET @update_query = IF(@jurado4_column_exists > 0,
    'UPDATE vriunap_pilar3.tesTramites t
    JOIN MapeoDocentes m ON t.IdJurado4 = m.IdOriginal
    SET t.IdJurado4 = m.IdNuevo',
    'SELECT "La columna IdJurado4 no existe en tesTramites"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @jurado5_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tesTramites'
    AND COLUMN_NAME = 'IdJurado5'
);

SET @update_query = IF(@jurado5_column_exists > 0,
    'UPDATE vriunap_pilar3.tesTramites t
    JOIN MapeoDocentes m ON t.IdJurado5 = m.IdOriginal
    SET t.IdJurado5 = m.IdNuevo',
    'SELECT "La columna IdJurado5 no existe en tesTramites"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5. Verificar si ya existe la tabla tblDocentes_nueva
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_name = 'tblDocentes_nueva'
);

-- Eliminar la tabla si ya existe
SET @drop_query = IF(@table_exists > 0, 
    'DROP TABLE tblDocentes_nueva', 
    'SELECT "La tabla tblDocentes_nueva no existe, no es necesario eliminarla"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Crear nueva tabla con estructura modificada
CREATE TABLE tblDocentes_nueva LIKE tblDocentes;
ALTER TABLE tblDocentes_nueva MODIFY FechaCon date NULL;
ALTER TABLE tblDocentes_nueva MODIFY FechaIn date NULL;
ALTER TABLE tblDocentes_nueva MODIFY FechaAsc date NULL;
ALTER TABLE tblDocentes_nueva MODIFY FechaNac date NULL;

-- 6. Verificar que las columnas necesarias existen en tblDocentes antes de la migración
SET @columns_exist = (
    SELECT COUNT(*) >= 24
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tblDocentes'
);

-- Insertar datos con los nuevos IDs, convirtiendo fechas '0000-00-00' a NULL
SET SESSION sql_mode = '';

SET @insert_query = IF(@columns_exist = 1,
    'INSERT INTO tblDocentes_nueva
    SELECT m.IdNuevo, d.Activo, d.DNI, d.Sexo, d.Codigo, d.IdCategoria, d.SubCat,
     d.IdFacultad, d.IdCarrera, d.IdPrograma, d.Apellidos, d.Nombres,
    CASE WHEN d.FechaCon = "0000-00-00" THEN NULL ELSE d.FechaCon END,
     d.ResolCon,
    CASE WHEN d.FechaIn = "0000-00-00" THEN NULL ELSE d.FechaIn END,
    CASE WHEN d.FechaAsc = "0000-00-00" THEN NULL ELSE d.FechaAsc END,
     d.ResolAsc, d.Resolucion,
    CASE WHEN d.FechaNac = "0000-00-00" THEN NULL ELSE d.FechaNac END,
     d.Direccion, d.NroCelular, d.Renacyt, d.Orcid, d.Correo, d.Clave
    FROM tblDocentes d
    JOIN MapeoDocentes m ON d.Id = m.IdOriginal
    ORDER BY m.IdNuevo',
    'SELECT "Faltan algunas columnas necesarias en tblDocentes para realizar la migración"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 7. Eliminar tabla antigua y renombrar la nueva sólo si la nueva tiene datos
SET @new_table_has_data = (
    SELECT COUNT(*) > 0
    FROM tblDocentes_nueva
);

-- Primero eliminar la tabla antigua si la nueva tiene datos
SET @drop_query = IF(@new_table_has_data = 1,
    'DROP TABLE tblDocentes',
    'SELECT "La tabla tblDocentes_nueva no tiene datos, no se realizará el reemplazo"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Luego renombrar la nueva tabla si la nueva tiene datos
SET @rename_query = IF(@new_table_has_data = 1,
    'RENAME TABLE tblDocentes_nueva TO tblDocentes',
    'SELECT "La tabla tblDocentes_nueva no tiene datos, no se realizará el reemplazo"'
);

PREPARE stmt FROM @rename_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 8. Observar cuál es el último ID asignado
SELECT MAX(IdNuevo) FROM MapeoDocentes;

-- Ver los mapeos de IDs originales a IDs nuevos (muestra TODOS los mapeos)
SELECT 
    m.IdOriginal as IdAntiguo, 
    m.IdNuevo as IdNuevo,
    d.DNI,
    d.Nombres,
    d.Apellidos
FROM MapeoDocentes m
JOIN tblDocentes d ON m.IdNuevo = d.Id
ORDER BY d.DNI, m.IdOriginal;

-- Actualizar referencias en tesJuCambios
-- Verificar si la tabla existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tesJuCambios'
);

-- Actualizar referencias solo si la tabla existe
SET @update_jurado1_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.tesJuCambios t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdJurado1 = m.IdOriginal
    SET t.IdJurado1 = m.IdNuevo',
    'SELECT "La tabla tesJuCambios no existe"'
);

PREPARE stmt FROM @update_jurado1_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @update_jurado2_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.tesJuCambios t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdJurado2 = m.IdOriginal
    SET t.IdJurado2 = m.IdNuevo',
    'SELECT "La tabla tesJuCambios no existe"'
);

PREPARE stmt FROM @update_jurado2_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @update_jurado3_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.tesJuCambios t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdJurado3 = m.IdOriginal
    SET t.IdJurado3 = m.IdNuevo',
    'SELECT "La tabla tesJuCambios no existe"'
);

PREPARE stmt FROM @update_jurado3_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @update_jurado4_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.tesJuCambios t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdJurado4 = m.IdOriginal
    SET t.IdJurado4 = m.IdNuevo',
    'SELECT "La tabla tesJuCambios no existe"'
);

PREPARE stmt FROM @update_jurado4_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Actualizar referencias en docLineas
-- Verificar si la tabla existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'docLineas'
);

-- Actualizar referencias solo si la tabla existe
SET @update_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.docLineas t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdDocente = m.IdOriginal
    SET t.IdDocente = m.IdNuevo',
    'SELECT "La tabla docLineas no existe"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Actualizar referencias en docParentesco
-- Verificar si la tabla existe
SET @table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'docParentesco'
);

-- Actualizar referencias solo si la tabla existe
SET @update_docente1_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.docParentesco t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdDocente1 = m.IdOriginal
    SET t.IdDocente1 = m.IdNuevo',
    'SELECT "La tabla docParentesco no existe"'
);

PREPARE stmt FROM @update_docente1_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @update_docente2_query = IF(@table_exists > 0,
    'UPDATE vriunap_pilar3.docParentesco t
    JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON t.IdDocente2 = m.IdOriginal
    SET t.IdDocente2 = m.IdNuevo',
    'SELECT "La tabla docParentesco no existe"'
);

PREPARE stmt FROM @update_docente2_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;