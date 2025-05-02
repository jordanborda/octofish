-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_LineasVRI;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.dic_LineasVRI (
  Id int NOT NULL AUTO_INCREMENT,
  Nombre varchar(800) NOT NULL,
  Estado int NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_LineasVRI (Id, Nombre, Estado)
SELECT 
    Id, 
    Nombre, 
    Estado
FROM vriunap_absmain.dic_LineasVRI;