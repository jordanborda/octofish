-- Crear la tabla destino con la estructura requerida
CREATE TABLE IF NOT EXISTS legacy_vriunap.tbl_tesistaProyHabilitados (
  Id int NOT NULL AUTO_INCREMENT,
  IdTram int NOT NULL,
  Codigo varchar(10) NOT NULL,
  IdDocente int NOT NULL,
  PosJurado int NOT NULL,
  Motivo varchar(300) NOT NULL,
  FechSort datetime NULL,
  Fecha datetime NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Configurar SQL_MODE temporalmente para evitar problemas con fechas
SET SESSION sql_mode = '';

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_tesistaProyHabilitados (
  Id, IdTram, Codigo, IdDocente, PosJurado, Motivo, FechSort, Fecha
)
SELECT 
  Id, IdTram, Codigo, IdDocente, PosJurado, Motivo, 
  NULLIF(FechSort, '0000-00-00 00:00:00') AS FechSort, 
  NULLIF(Fecha, '0000-00-00 00:00:00') AS Fecha
FROM vriunap_pilar3.tesProyHabs;