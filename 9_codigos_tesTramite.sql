-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Verificar si las tablas existen antes de realizar la migración
SET @origen_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tesTramites'
);

SET @destino_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'legacy_vriunap'
    AND table_name = 'tbl_Tramites'
);

-- Migrar datos de vriunap_pilar3.tesTramites a legacy_vriunap.tbl_Tramites
SET @insert_query = IF(@origen_exists > 0 AND @destino_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_Tramites (
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
        FechaRegistro
    )
    SELECT 
        tt.IdTesista1 AS IdTesista,
        tt.Codigo,
        tt.Anio,
        tt.Estado AS IdEstado,
        tt.IdLinea AS IdSubLinea,
        0 AS IdModalidad, -- Valor por defecto ya que no existe en origen
        CASE WHEN tt.IdTesista2 > 0 THEN 1 ELSE 0 END AS TieneCoAsesorExterno,
        tc.IdFacultad,
        tt.IdCarrera,
        tc.IdEspec AS IdEspecialidad,
        IFNULL(tt._T_, "T") AS TipoTrabajo,
        IFNULL(tt.FechRegProy, CURRENT_TIMESTAMP) AS FechaRegistro
    FROM 
        vriunap_pilar3.tesTramites tt
    LEFT JOIN 
        vriunap_pilar3.tblTesistasCodigos tc ON tt.IdTesista1 = tc.IdTesista
    WHERE 
        EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tesistas t WHERE t.IdUsuario = tt.IdTesista1)',
    'SELECT "No se puede realizar la migración porque alguna tabla necesaria no existe"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar los resultados de la migración
SET @count_query = IF(@destino_exists > 0,
    'SELECT COUNT(*) AS RegistrosMigrados FROM legacy_vriunap.tbl_Tramites',
    'SELECT "No se puede verificar los resultados porque la tabla destino no existe"'
);

PREPARE stmt FROM @count_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



-- Configurar SQL_MODE temporalmente para permitir valores de fecha cero
SET SESSION sql_mode = '';

-- Verificar si las tablas existen
SET @origen_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tesTramites'
);

-- Primero, crear la tabla tbl_ConformacionJurados si aún no existe
CREATE TABLE IF NOT EXISTS legacy_vriunap.`tbl_ConformacionJurados` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `IdTramite` int NOT NULL,
  `IdJurado` int NOT NULL,
  `Orden` int NOT NULL,
  `IdEstado` int NOT NULL,
  `FechaAsignacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IdUsuarioAsignador` int NOT NULL,1
  `Estado` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `idx_tramite_jurado_orden` (`IdTramite`, `IdJurado`, `Orden`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- Insertar registros de jurado1 si la tabla de origen existe
SET @insert_query1 = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_ConformacionJurados 
      (IdTramite, IdJurado, Orden, IdEstado, FechaAsignacion, IdUsuarioAsignador, Estado)
     SELECT
       Id AS IdTramite,
       IdJurado1 AS IdJurado,
       1 AS Orden,
       Estado AS IdEstado,
       IFNULL(FechRegProy, CURRENT_TIMESTAMP) AS FechaAsignacion,
       1 AS IdUsuarioAsignador,
       CASE WHEN Estado > 0 THEN 1 ELSE 0 END AS Estado
     FROM vriunap_pilar3.tesTramites
     WHERE IdJurado1 > 0
     AND EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramites.Id)',
    'SELECT "No se puede realizar la inserción de jurado1 porque la tabla origen no existe"'
);

PREPARE stmt FROM @insert_query1;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insertar registros de jurado2 si la tabla de origen existe
SET @insert_query2 = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_ConformacionJurados 
      (IdTramite, IdJurado, Orden, IdEstado, FechaAsignacion, IdUsuarioAsignador, Estado)
     SELECT
       Id AS IdTramite,
       IdJurado2 AS IdJurado,
       2 AS Orden,
       Estado AS IdEstado,
       IFNULL(FechRegProy, CURRENT_TIMESTAMP) AS FechaAsignacion,
       1 AS IdUsuarioAsignador,
       CASE WHEN Estado > 0 THEN 1 ELSE 0 END AS Estado
     FROM vriunap_pilar3.tesTramites
     WHERE IdJurado2 > 0
     AND EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramites.Id)',
    'SELECT "No se puede realizar la inserción de jurado2 porque la tabla origen no existe"'
);

PREPARE stmt FROM @insert_query2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insertar registros de jurado3 si la tabla de origen existe
SET @insert_query3 = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_ConformacionJurados 
      (IdTramite, IdJurado, Orden, IdEstado, FechaAsignacion, IdUsuarioAsignador, Estado)
     SELECT
       Id AS IdTramite,
       IdJurado3 AS IdJurado,
       3 AS Orden,
       Estado AS IdEstado,
       IFNULL(FechRegProy, CURRENT_TIMESTAMP) AS FechaAsignacion,
       1 AS IdUsuarioAsignador,
       CASE WHEN Estado > 0 THEN 1 ELSE 0 END AS Estado
     FROM vriunap_pilar3.tesTramites
     WHERE IdJurado3 > 0
     AND EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramites.Id)',
    'SELECT "No se puede realizar la inserción de jurado3 porque la tabla origen no existe"'
);

PREPARE stmt FROM @insert_query3;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insertar registros de jurado4 si la tabla de origen existe
SET @insert_query4 = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_ConformacionJurados 
      (IdTramite, IdJurado, Orden, IdEstado, FechaAsignacion, IdUsuarioAsignador, Estado)
     SELECT
       Id AS IdTramite,
       IdJurado4 AS IdJurado,
       4 AS Orden,
       Estado AS IdEstado,
       IFNULL(FechRegProy, CURRENT_TIMESTAMP) AS FechaAsignacion,
       1 AS IdUsuarioAsignador,
       CASE WHEN Estado > 0 THEN 1 ELSE 0 END AS Estado
     FROM vriunap_pilar3.tesTramites
     WHERE IdJurado4 > 0
     AND EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramites.Id)',
    'SELECT "No se puede realizar la inserción de jurado4 porque la tabla origen no existe"'
);

PREPARE stmt FROM @insert_query4;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insertar registros de jurado5 si la tabla de origen existe
SET @insert_query5 = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_ConformacionJurados 
      (IdTramite, IdJurado, Orden, IdEstado, FechaAsignacion, IdUsuarioAsignador, Estado)
     SELECT
       Id AS IdTramite,
       IdJurado5 AS IdJurado,
       5 AS Orden,
       Estado AS IdEstado,
       IFNULL(FechRegProy, CURRENT_TIMESTAMP) AS FechaAsignacion,
       1 AS IdUsuarioAsignador,
       CASE WHEN Estado > 0 THEN 1 ELSE 0 END AS Estado
     FROM vriunap_pilar3.tesTramites
     WHERE IdJurado5 > 0
     AND EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramites.Id)',
    'SELECT "No se puede realizar la inserción de jurado5 porque la tabla origen no existe"'
);

PREPARE stmt FROM @insert_query5;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar los resultados de la migración
SELECT COUNT(*) AS RegistrosMigrados FROM legacy_vriunap.tbl_ConformacionJurados;