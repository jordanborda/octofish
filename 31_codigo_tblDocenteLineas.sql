-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.tbl_DocenteLineas;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.tbl_DocenteLineas (
  Id int NOT NULL AUTO_INCREMENT,
  IdDocente int NOT NULL,
  IdLinea int NOT NULL,
  Tipo int NOT NULL DEFAULT 1,
  Fecha timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Estado int NOT NULL,
  Obs varchar(1000) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_DocenteLineas (Id, IdDocente, IdLinea, Tipo, Fecha, Estado, Obs)
SELECT 
    Id, 
    IdDocente, 
    IdLinea, 
    Tipo, 
    Fecha, 
    Estado, 
    Obs
FROM vriunap_pilar3.docLineas;