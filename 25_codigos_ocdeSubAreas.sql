-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_ocdeSubAreas;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.dic_ocdeSubAreas (
  Id int NOT NULL AUTO_INCREMENT,
  Nombre varchar(100) NOT NULL,
  IdArea int NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_ocdeSubAreas (Id, Nombre, IdArea)
SELECT 
    Id, 
    Nombre,
    IdArea
FROM vriunap_absmain.ocdeSubAreas;