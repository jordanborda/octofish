-- Crear la tabla destino con la estructura requerida
CREATE TABLE IF NOT EXISTS legacy_vriunap.tbl_tesistaActaSustentacion (
  Id int NOT NULL AUTO_INCREMENT,
  IdTramite int NOT NULL,
  IdCarrera int NOT NULL,
  Dictamen int NOT NULL,
  Fecha datetime NULL,
  Num int NOT NULL,
  Obs text NOT NULL,
  ExtraObs text DEFAULT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Configurar SQL_MODE temporalmente para evitar problemas con fechas
SET SESSION sql_mode = '';

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_tesistaActaSustentacion (
  Id, IdTramite, IdCarrera, Dictamen, Fecha, Num, Obs, ExtraObs
)
SELECT 
  Id, IdTramite, IdCarrera, Dictamen, 
  NULLIF(Fecha, '0000-00-00 00:00:00') AS Fecha, 
  Num, Obs, ExtraObs
FROM vriunap_pilar3.tesSustenAct;