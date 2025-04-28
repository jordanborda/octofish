-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.tbl_Administradores;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.tbl_Administradores (
  Id int NOT NULL AUTO_INCREMENT,
  Nivel int NOT NULL,
  IdDoc int NOT NULL,
  Responsable varchar(32) NOT NULL,
  Usuario varchar(12) NOT NULL,
  Clave varchar(100) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.tbl_Administradores (Id, Nivel, IdDoc, Responsable, Usuario, Clave)
SELECT 
    Id, 
    Nivel, 
    IdDoc, 
    Responsable, 
    Usuario, 
    Clave
FROM vriunap_pilar3.tblManagers;