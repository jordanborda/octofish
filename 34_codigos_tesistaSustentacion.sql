-- Crear la tabla destino con la estructura requerida
CREATE TABLE IF NOT EXISTS legacy_vriunap.tbl_TesistaSustentacion (
  Id int NOT NULL AUTO_INCREMENT,
  Activo int NOT NULL DEFAULT 1,
  Tipo int NOT NULL DEFAULT 1,
  IdBorrador int NOT NULL,
  IdTramite int NOT NULL,
  Codigo varchar(12) NOT NULL,
  Fecha datetime NULL,
  FechaDic date NULL,
  IdCarrera int NOT NULL,
  Lugar varchar(100) NOT NULL,
  obs varchar(300) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Configurar SQL_MODE temporalmente para evitar problemas con fechas
SET SESSION sql_mode = '';

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_TesistaSustentacion (
  Id, Activo, Tipo, IdBorrador, IdTramite, 
  Codigo, Fecha, FechaDic, IdCarrera, Lugar, obs
)
SELECT 
  Id, Activo, Tipo, IdBorrador, IdTramite, 
  Codigo, 
  NULLIF(Fecha, '0000-00-00 00:00:00') AS Fecha, 
  NULLIF(FechaDic, '0000-00-00') AS FechaDic,
  IdCarrera, Lugar, obs
FROM vriunap_pilar3.tesSustens;