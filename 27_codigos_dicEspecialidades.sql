-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_Especialidades;

-- Crear la tabla con la estructura requerida, sin la columna Cod y con las nuevas columnas
CREATE TABLE legacy_vriunap.dic_Especialidades (
  Id int NOT NULL AUTO_INCREMENT,
  IdCarrera int NOT NULL,
  Nombre varchar(75) NOT NULL,
  Denominacion varchar(150) DEFAULT NULL,
  Estado tinyint NOT NULL DEFAULT 1,
  Fecha_Reg datetime NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Insertar datos desde la tabla origen a la tabla destino, omitiendo la columna Cod
-- y agregando las columnas Estado y Fecha_Reg
INSERT INTO legacy_vriunap.dic_Especialidades (Id, IdCarrera, Nombre, Denominacion, Estado, Fecha_Reg)
SELECT 
    Id, 
    IdCarrera, 
    Nombre, 
    Denominacion,
    1 AS Estado,
    NOW() AS Fecha_Reg
FROM vriunap_pilar3_abs_main.dicEspecialis;



-- Crear la tabla dic_Denominaciones
CREATE TABLE legacy_vriunap.dic_Denominaciones (
  id int NOT NULL AUTO_INCREMENT,
  DenominacionTitulo varchar(150) DEFAULT NULL,
  Estado tinyint NOT NULL DEFAULT 1,
  Fecha_Reg datetime NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Insertar valores únicos de Denominacion de dic_Especialidades
INSERT INTO legacy_vriunap.dic_Denominaciones (DenominacionTitulo, Estado, Fecha_Reg)
SELECT DISTINCT 
    Denominacion,
    1 AS Estado,
    NOW() AS Fecha_Reg
FROM legacy_vriunap.dic_Especialidades
WHERE Denominacion IS NOT NULL;

-- Agregar campo IdDenominacion a dic_Especialidades
ALTER TABLE legacy_vriunap.dic_Especialidades
ADD COLUMN IdDenominacion int DEFAULT NULL;

-- Actualizar dic_Especialidades con las referencias a dic_Denominaciones
UPDATE legacy_vriunap.dic_Especialidades e
JOIN legacy_vriunap.dic_Denominaciones d ON e.Denominacion = d.DenominacionTitulo
SET e.IdDenominacion = d.id
WHERE e.Denominacion IS NOT NULL;

-- Opcional: Eliminar la columna Denominacion antigua después de la migración
-- ALTER TABLE legacy_vriunap.dic_Especialidades
-- DROP COLUMN Denominacion;

