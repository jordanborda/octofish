-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Migrar datos sin verificación estricta de integridad y con IdEstado como NULL
INSERT IGNORE INTO legacy_vriunap.tbl_CorrecionesObservaciones (
    IdTramite,
    IdEstado,
    IdDocente,
    Mensaje,
    Fecha,
    Estado
)
SELECT 
    IdTramite,
    NULL AS IdEstado,  -- No usar Iteracion, dejar NULL
    IdDocente,
    Mensaje,
    Fecha,
    1 AS Estado
FROM vriunap_pilar3.tblCorrects;