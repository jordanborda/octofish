-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_Facultades;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.dic_Facultades (
  Id int NOT NULL AUTO_INCREMENT,
  Nombre varchar(100) NOT NULL,
  Abreviatura varchar(20) NOT NULL,
  IdArea int NOT NULL,
  Estado tinyint NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_Facultades (Id, Nombre, Abreviatura, IdArea, Estado)
SELECT 
    Id, 
    Nombre, 
    Abrev AS Abreviatura, 
    IdArea,
    1 AS Estado
FROM vriunap_pilar3_abs_main.dicFacultades;