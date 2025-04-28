-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Verificar si la tabla origen existe
SET @origen_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'dicEstadTram'
);

-- Crear tabla equivalente en legacy_vriunap si no existe
CREATE TABLE IF NOT EXISTS legacy_vriunap.dic_EstadosTramite (
    Id INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(150) NOT NULL,
    Descripcion VARCHAR(800) NOT NULL,
    Estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrar datos de vriunap_pilar3.dicEstadTram a legacy_vriunap.dic_EstadosTramite
SET @insert_query = IF(@origen_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.dic_EstadosTramite (Id, Nombre, Descripcion, Estado)
     SELECT 
        Id,
        Nombre,
        Descrip AS Descripcion,
        Estado
     FROM vriunap_pilar3.dicEstadTram',
    'SELECT "No se puede realizar la migración porque la tabla de origen no existe"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verificar los resultados de la migración
SELECT 
    (SELECT COUNT(*) FROM vriunap_pilar3.dicEstadTram) AS RegistrosOrigen,
    (SELECT COUNT(*) FROM legacy_vriunap.dic_EstadosTramite) AS RegistrosDestino;