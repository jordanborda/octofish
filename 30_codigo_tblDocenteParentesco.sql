-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.tbl_DocenteParentesco;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.tbl_DocenteParentesco (
  Id int NOT NULL AUTO_INCREMENT,
  Filiacion varchar(5) NOT NULL,
  IdDocente1 int NOT NULL,
  IdDocente2 int NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_DocenteParentesco (Id, Filiacion, IdDocente1, IdDocente2)
SELECT 
    Id, 
    Filiacion, 
    IdDocente1, 
    IdDocente2
FROM vriunap_pilar3.docParentesco;