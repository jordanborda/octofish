-- Paso 0: Configurar entorno
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Paso 1: Verificar si la columna idTramite ya existe, si no, crearla
SET @existe_col_idTramite := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'legacy_vriunap'
    AND TABLE_NAME = 'tbl_Tramites'
    AND COLUMN_NAME = 'idTramite'
);

SET @crear_col_idTramite := IF(@existe_col_idTramite = 0,
  'ALTER TABLE legacy_vriunap.tbl_Tramites ADD COLUMN idTramite INT NULL;',
  'SELECT 1;'
);

PREPARE stmt1 FROM @crear_col_idTramite;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

-- Paso 2: Verificar si la columna IdLinea ya existe, si no, crearla
SET @existe_col_idLinea := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'legacy_vriunap'
    AND TABLE_NAME = 'tbl_Tramites'
    AND COLUMN_NAME = 'IdLinea'
);

SET @crear_col_idLinea := IF(@existe_col_idLinea = 0,
  'ALTER TABLE legacy_vriunap.tbl_Tramites ADD COLUMN IdLinea INT NULL;',
  'SELECT 1;'
);

PREPARE stmt2 FROM @crear_col_idLinea;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Paso 3: Insertar datos duplicando por cada tesista y corrigiendo TipoTrabajo con el campo Tipo
INSERT INTO legacy_vriunap.tbl_Tramites (
  IdTesista,
  Codigo,
  Anio,
  IdEstado,
  IdSubLinea,
  IdModalidad,
  TieneCoAsesorExterno,
  IdFacultad,
  IdCarrera,
  IdEspecialidad,
  TipoTrabajo,
  FechaRegistro,
  idTramite,
  IdLinea
)
SELECT
  t.IdTesista,
  t.Codigo,
  t.Anio,
  t.Estado,
  t.IdLinAlte,
  1,                  -- IdModalidad ← fijo 1
  t.SuEst,
  NULL,
  t.IdCarrera,
  NULL,
  t.Tipo,             -- TipoTrabajo ← corregido, proviene del campo Tipo
  t.FechRegProy,
  t.IdTramite,
  t.IdLinea
FROM (
  SELECT 
    Id AS IdTramite,
    IdTesista1 AS IdTesista,
    Codigo,
    Anio,
    Estado,
    IdLinAlte,
    IdLinea,
    SuEst,
    IdCarrera,
    Tipo,
    FechRegProy
  FROM vriunap_pilar3.tesTramites
  WHERE IdTesista1 IS NOT NULL

  UNION ALL

  SELECT 
    Id AS IdTramite,
    IdTesista2 AS IdTesista,
    Codigo,
    Anio,
    Estado,
    IdLinAlte,
    IdLinea,
    SuEst,
    IdCarrera,
    Tipo,
    FechRegProy
  FROM vriunap_pilar3.tesTramites
  WHERE IdTesista2 IS NOT NULL
) AS t;

-- Paso 4: Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;




-- Paso 0: Configurar entorno
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Paso 1: Actualizar los IdTesista en legacy_vriunap.tbl_Tramites usando MapeoTesistas
UPDATE legacy_vriunap.tbl_Tramites t
JOIN vriunap_pilar3.MapeoTesistas m ON t.IdTesista = m.idOriginal
SET t.IdTesista = m.idNuevo;

-- Paso 2: Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;
