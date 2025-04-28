-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Verificar si la tabla origen existe
SET @origen_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tesTramsDet'
);

-- Verificar si la tabla destino existe
SET @destino_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'legacy_vriunap'
    AND table_name = 'tbl_TramitesDet'
);

-- Crear tabla si no existe
SET @create_query = IF(@destino_exists = 0,
    'CREATE TABLE legacy_vriunap.tbl_TramitesDet (
        Id int NOT NULL AUTO_INCREMENT,
        IdTramite int NOT NULL,
        Iteracion int NOT NULL,
        Titulo varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
        Archivo varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
        vb1 int NOT NULL,
        vb2 int NOT NULL,
        vb3 int NOT NULL,
        vb4 int NOT NULL,
        Fecha datetime NOT NULL,
        Obs varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
        PRIMARY KEY (Id),
        KEY idx_IdTramite (IdTramite)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci',
    'SELECT "La tabla tbl_TramitesDet ya existe"'
);

PREPARE stmt FROM @create_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Migrar datos de vriunap_pilar3.tesTramsDet a legacy_vriunap.tbl_TramitesDet
SET @insert_query = IF(@origen_exists > 0 AND @destino_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_TramitesDet (
        Id,
        IdTramite,
        Iteracion,
        Titulo,
        Archivo,
        vb1,
        vb2,
        vb3,
        vb4,
        Fecha,
        Obs
     )
     SELECT 
        Id,
        IdTramite,
        Iteracion,
        Titulo,
        Archivo,
        vb1,
        vb2,
        vb3,
        vb4,
        Fecha,
        Obs
     FROM vriunap_pilar3.tesTramsDet
     WHERE EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Tramites t WHERE t.Id = tesTramsDet.IdTramite)',
    'SELECT "No se puede realizar la migración porque alguna tabla necesaria no existe"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar los resultados de la migración
SET @check_query = IF(@destino_exists > 0,
    'SELECT 
        (SELECT COUNT(*) FROM vriunap_pilar3.tesTramsDet) AS RegistrosOrigen,
        (SELECT COUNT(*) FROM legacy_vriunap.tbl_TramitesDet) AS RegistrosDestino',
    'SELECT "No se pueden verificar los resultados porque la tabla destino no existe"'
);

PREPARE stmt FROM @check_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;