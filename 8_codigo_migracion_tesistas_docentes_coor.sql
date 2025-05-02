-- Paso 0: Configurar entorno
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Paso 1: Buscar y eliminar índice único en CodigoEstudiante si existe
SELECT INDEX_NAME
INTO @idx_codigo
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'legacy_vriunap'
  AND TABLE_NAME = 'tbl_Tesistas'
  AND COLUMN_NAME = 'CodigoEstudiante'
  AND NON_UNIQUE = 0
LIMIT 1;

-- Si se encontró índice único, eliminarlo
SET @drop_sql_codigo = IF(@idx_codigo IS NOT NULL, 
  CONCAT('DROP INDEX ', @idx_codigo, ' ON legacy_vriunap.tbl_Tesistas'), 
  'SELECT "No se encontró índice único en CodigoEstudiante"');

PREPARE stmt FROM @drop_sql_codigo;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Paso 2: Buscar y eliminar índice único en IdUsuario si existe
SELECT INDEX_NAME
INTO @idx_usuario
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'legacy_vriunap'
  AND TABLE_NAME = 'tbl_Tesistas'
  AND COLUMN_NAME = 'IdUsuario'
  AND NON_UNIQUE = 0
LIMIT 1;

-- Si se encontró índice único, eliminarlo
SET @drop_sql_usuario = IF(@idx_usuario IS NOT NULL, 
  CONCAT('DROP INDEX ', @idx_usuario, ' ON legacy_vriunap.tbl_Tesistas'), 
  'SELECT "No se encontró índice único en IdUsuario"');

PREPARE stmt2 FROM @drop_sql_usuario;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Paso 3: Insertar los datos permitiendo duplicados
INSERT INTO legacy_vriunap.tbl_Tesistas (
  IdUsuario,
  CodigoEstudiante,
  IdFacultad,
  IdCarrera,
  IdEspecialidad,
  Estado
)
SELECT
  idTesista,
  Codigo,
  IdFacultad,
  IdCarrera,
  IdEspec,
  Activo
FROM vriunap_pilar3.tblTesistas
WHERE idTesista IS NOT NULL;

-- Paso 4: Restaurar entorno
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;



-- Paso 0: Configurar entorno para evitar errores por restricciones
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Paso 1: Eliminar índice único sobre IdUsuario si existe (para permitir duplicados)
SELECT INDEX_NAME
INTO @idx_docente
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'legacy_vriunap'
  AND TABLE_NAME = 'tbl_Docentes'
  AND COLUMN_NAME = 'IdUsuario'
  AND NON_UNIQUE = 0
LIMIT 1;

SET @drop_idx_docente = IF(@idx_docente IS NOT NULL,
  CONCAT('DROP INDEX ', @idx_docente, ' ON legacy_vriunap.tbl_Docentes'),
  'SELECT "No se encontró índice único en IdUsuario"');

PREPARE stmt_doc FROM @drop_idx_docente;
EXECUTE stmt_doc;
DEALLOCATE PREPARE stmt_doc;

-- Paso 2: Eliminar índice único sobre CodigoDocente si existe (para permitir duplicados)
SELECT INDEX_NAME
INTO @idx_codigo
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'legacy_vriunap'
  AND TABLE_NAME = 'tbl_Docentes'
  AND COLUMN_NAME = 'CodigoDocente'
  AND NON_UNIQUE = 0
LIMIT 1;

SET @drop_idx_codigo = IF(@idx_codigo IS NOT NULL,
  CONCAT('DROP INDEX ', @idx_codigo, ' ON legacy_vriunap.tbl_Docentes'),
  'SELECT "No se encontró índice único en CodigoDocente"');

PREPARE stmt_cod FROM @drop_idx_codigo;
EXECUTE stmt_cod;
DEALLOCATE PREPARE stmt_cod;

-- Paso 3: Insertar los datos permitiendo duplicados, idDocente como IdUsuario
INSERT INTO legacy_vriunap.tbl_Docentes (
  IdUsuario,
  CodigoDocente,
  IdCategoria,
  IdSubCategoria,
  CodigoAIRHS,
  Estado
)
SELECT
  idDocente,        -- IdUsuario → idDocente (ya migrado como ID en tbl_Usuarios)
  Codigo,           -- CodigoDocente
  IdCategoria,      -- IdCategoria
  SubCat,             -- IdSubCategoria (sin mapeo exacto de SubCat)
  NULL,             -- CodigoAIRHS (no se especifica origen)
  Activo            -- Estado
FROM vriunap_absmain.tblDocentes
WHERE idDocente IS NOT NULL;

-- Paso 4: Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;




-- Paso 0: Configurar entorno para evitar errores por restricciones
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Paso 1: Eliminar índice único en IdUsuario si existe (para permitir duplicados)
SELECT INDEX_NAME
INTO @idx_coor
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'legacy_vriunap'
  AND TABLE_NAME = 'tbl_Coordinadores'
  AND COLUMN_NAME = 'IdUsuario'
  AND NON_UNIQUE = 0
LIMIT 1;

SET @drop_idx_coor = IF(@idx_coor IS NOT NULL,
  CONCAT('DROP INDEX ', @idx_coor, ' ON legacy_vriunap.tbl_Coordinadores'),
  'SELECT "No se encontró índice único en IdUsuario"');

PREPARE stmt_coor FROM @drop_idx_coor;
EXECUTE stmt_coor;
DEALLOCATE PREPARE stmt_coor;

-- Paso 2: Insertar datos desde tblSecres a tbl_Coordinadores
INSERT INTO legacy_vriunap.tbl_Coordinadores (
  IdUsuario,
  IdFacultad,
  IdCarrera,
  NivelUsuario,
  CorreoOficina,
  DireccionOficina,
  Horario,
  FechaInicio,
  FechaFin,
  Estado
)
SELECT
  idCoordinador,      -- IdUsuario
  Id_Facultad,        -- IdFacultad
  IdCarrera,          -- IdCarrera
  UserLevel,          -- NivelUsuario
  Correo,             -- CorreoOficina
  Direccion,          -- DireccionOficina
  Horario,            -- Horario
  FechReg,            -- FechaInicio
  NULL,               -- FechaFin
  Estado              -- Estado
FROM vriunap_pilar3.tblSecres
WHERE idCoordinador IS NOT NULL;

-- Paso 3: Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;

