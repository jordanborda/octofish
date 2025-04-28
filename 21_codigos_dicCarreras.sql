-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_Carreras;

-- Crear la tabla con la estructura requerida
CREATE TABLE legacy_vriunap.dic_Carreras (
  Id int NOT NULL AUTO_INCREMENT,
  IdFacultad int NOT NULL,
  Nombre varchar(100) NOT NULL,
  TieneEspecialidades tinyint NOT NULL,
  Estado tinyint NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_Carreras (Id, IdFacultad, Nombre, TieneEspecialidades, Estado)
SELECT 
    Id, 
    IdFacultad, 
    Nombre, 
    subEsp AS TieneEspecialidades,
    1 AS Estado
FROM vriunap_pilar3_abs_main.dicCarreras;

