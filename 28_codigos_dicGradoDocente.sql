-- Si necesitas recrear la tabla destino (si ya existe)
DROP TABLE IF EXISTS legacy_vriunap.dic_GradosDocentes;

-- Crear la tabla con la estructura requerida, sin la columna Archivo y permitiendo NULL en Fecha
CREATE TABLE legacy_vriunap.dic_GradosDocentes (
  Id int NOT NULL AUTO_INCREMENT,
  IdDocente int NOT NULL,
  Universidad varchar(99) NOT NULL,
  IdGrado int NOT NULL DEFAULT 1,
  AbrevGrado varchar(7) NOT NULL,
  Mencion varchar(120) NOT NULL,
  Fecha date DEFAULT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Primero, configurar MySQL para permitir valores de fecha cero temporalmente
SET sql_mode = '';

-- Insertar datos desde la tabla origen a la tabla destino
INSERT INTO legacy_vriunap.dic_GradosDocentes (Id, IdDocente, Universidad, IdGrado, AbrevGrado, Mencion, Fecha)
SELECT 
    Id, 
    IdDocente, 
    Universidad, 
    IdGrado, 
    AbrevGrado, 
    Mencion,
    NULLIF(Fecha, '0000-00-00')
FROM vriunap_pilar3.docEstudios;

-- Restaurar la configuración de MySQL (opcional)
SET sql_mode = DEFAULT;





-- Actualizar IdDocente basándose en la tabla de mapeo
UPDATE legacy_vriunap.dic_GradosDocentes gd
JOIN vriunap_absmain.MapeoDocentes md ON gd.IdDocente = md.IdOriginal
SET gd.IdDocente = md.IdNuevo
WHERE md.IdNuevo IS NOT NULL;

