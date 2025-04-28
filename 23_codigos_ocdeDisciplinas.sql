-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_ocdeDisciplinas;

-- Crear la tabla con la estructura requerida más la columna Estado
CREATE TABLE legacy_vriunap.dic_ocdeDisciplinas (
  Id int NOT NULL AUTO_INCREMENT,
  Nombre varchar(300) NOT NULL,
  IdArea int NOT NULL,
  IdSubArea int NOT NULL,
  Estado tinyint NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_ocdeDisciplinas (Id, Nombre, IdArea, IdSubArea, Estado)
SELECT 
    Id, 
    Nombre, 
    IdArea, 
    IdSubArea,
    1 AS Estado
FROM vriunap_pilar3_abs_main.ocdeDisciplinas;