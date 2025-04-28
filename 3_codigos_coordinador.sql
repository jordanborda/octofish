-- Desactivar temporalmente las restricciones de SQL mode
SET SESSION sql_mode = '';

-- Eliminar tablas temporales si existen
DROP TABLE IF EXISTS vriunap_pilar3.MapeoSecres;
DROP TABLE IF EXISTS vriunap_pilar3.tblSecres_nueva;

-- 1. Encontrar el valor máximo de Id en tblDocentes
-- Verificar primero si la tabla tblDocentes existe
SET @docentes_table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3_abs_main'
    AND table_name = 'tblDocentes'
);

SET @max_docente_id = IF(@docentes_table_exists > 0,
    (SELECT MAX(Id) FROM vriunap_pilar3_abs_main.tblDocentes),
    0
);

-- 2. Verificar si la tabla tblSecres existe antes de intentar crear el mapeo
SET @secres_table_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tblSecres'
);

-- Si la tabla tblSecres no existe, mostrar un mensaje y detener el proceso
SET @create_mapeo_query = IF(@secres_table_exists > 0,
    'CREATE TABLE vriunap_pilar3.MapeoSecres
    SELECT Id as IdOriginal,
     (@row_number:=@row_number+1) + @max_docente_id as IdNuevo
    FROM vriunap_pilar3.tblSecres,
     (SELECT @row_number:=0) as r
    ORDER BY Id',
    'SELECT "La tabla tblSecres no existe, no se puede crear el mapeo"'
);

PREPARE stmt FROM @create_mapeo_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar si se creó la tabla de mapeo correctamente
SET @mapeo_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'MapeoSecres'
);

-- 3. Crear índice para mejorar rendimiento solo si se creó el mapeo
SET @index_query = IF(@mapeo_exists > 0,
    'ALTER TABLE vriunap_pilar3.MapeoSecres ADD INDEX (IdOriginal)',
    'SELECT "No se puede crear el índice porque la tabla MapeoSecres no existe"'
);

PREPARE stmt FROM @index_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. Crear tabla tblSecres_nueva solo si existe la tabla original
SET @create_nueva_query = IF(@secres_table_exists > 0,
    'CREATE TABLE vriunap_pilar3.tblSecres_nueva LIKE vriunap_pilar3.tblSecres',
    'SELECT "No se puede crear tblSecres_nueva porque la tabla original no existe"'
);

PREPARE stmt FROM @create_nueva_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar si se creó la tabla nueva correctamente
SET @nueva_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tblSecres_nueva'
);

-- 5. Insertar datos con los nuevos IDs solo si ambas tablas existen
SET @insert_query = IF(@mapeo_exists > 0 AND @nueva_exists > 0,
    'INSERT INTO vriunap_pilar3.tblSecres_nueva
    SELECT
     m.IdNuevo,
     s.Id_Facultad,
     s.IdCarrera,
     s.UserLevel,
     s.Estado,
     s.Resp,
     s.Usuario,
     s.Clave,
     s.Celular,
     s.Correo,
     s.Direccion,
     s.Horario,
     s.FechReg
    FROM vriunap_pilar3.tblSecres s
    JOIN vriunap_pilar3.MapeoSecres m ON s.Id = m.IdOriginal
    ORDER BY m.IdNuevo',
    'SELECT "No se puede insertar datos porque alguna de las tablas no existe"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar que los datos se insertaron correctamente
SET @new_table_has_data = (
    SELECT IF(@nueva_exists > 0, 
        (SELECT COUNT(*) > 0 FROM vriunap_pilar3.tblSecres_nueva),
        0)
);

-- 6. Eliminar tabla antigua y renombrar la nueva solo si la nueva tiene datos
-- Primero eliminar la tabla antigua si la nueva tiene datos
SET @drop_query = IF(@new_table_has_data = 1,
    'DROP TABLE vriunap_pilar3.tblSecres',
    'SELECT "La tabla tblSecres_nueva no tiene datos, no se realizará el reemplazo"'
);

PREPARE stmt FROM @drop_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Luego renombrar la nueva tabla si la antigua fue eliminada
SET @rename_query = IF(@new_table_has_data = 1,
    'RENAME TABLE vriunap_pilar3.tblSecres_nueva TO vriunap_pilar3.tblSecres',
    'SELECT "No se renombrará la tabla porque no se eliminó la tabla original"'
);

PREPARE stmt FROM @rename_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 7. Mostrar el último ID asignado para configurar AUTO_INCREMENT manualmente
-- Verificar si existe la tabla de mapeo
SET @show_max_id_query = IF(@mapeo_exists > 0,
    'SELECT MAX(IdNuevo) AS UltimoID FROM vriunap_pilar3.MapeoSecres',
    'SELECT "No se puede mostrar el último ID porque la tabla MapeoSecres no existe"'
);

PREPARE stmt FROM @show_max_id_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Ver todos los mapeos de IDs originales a IDs nuevos con información del secretario
SET @show_mapeos_query = IF(@mapeo_exists > 0,
    'SELECT 
        m.IdOriginal as IdAntiguo, 
        m.IdNuevo as IdNuevo,
        s.Resp as Responsable,
        s.Usuario,
        s.Correo
    FROM vriunap_pilar3.MapeoSecres m
    JOIN vriunap_pilar3.tblSecres s ON m.IdNuevo = s.Id
    ORDER BY s.Usuario, m.IdOriginal',
    'SELECT "No se puede mostrar los mapeos porque la tabla MapeoSecres no existe"'
);

PREPARE stmt FROM @show_mapeos_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Actualizar referencias a secretarios en logCordinads (IdUser)
-- Verificar si existe la tabla logCordinads
SET @logcordinads_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'logCordinads'
);

-- Verificar si existe la columna IdUser en logCordinads
SET @iduser_column_exists = IF(@logcordinads_exists > 0,
    (SELECT COUNT(*)
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'vriunap_pilar3'
     AND TABLE_NAME = 'logCordinads'
     AND COLUMN_NAME = 'IdUser'),
    0
);

-- Actualizar referencias solo si existen tanto la tabla como la columna
SET @update_query = IF(@mapeo_exists > 0 AND @logcordinads_exists > 0 AND @iduser_column_exists > 0,
    'UPDATE vriunap_pilar3.logCordinads l
    JOIN vriunap_pilar3.MapeoSecres m ON l.IdUser = m.IdOriginal
    SET l.IdUser = m.IdNuevo',
    'SELECT "No se pueden actualizar referencias porque falta alguna tabla o columna necesaria"'
);

PREPARE stmt FROM @update_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;