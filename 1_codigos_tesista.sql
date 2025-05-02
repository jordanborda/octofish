-- Paso 1: Añadir la nueva columna idTesista
ALTER TABLE tblTesistas ADD COLUMN idTesista INT;

-- Paso 2: Inicialmente, establecer idTesista igual al Id actual para todos los registros
UPDATE tblTesistas SET idTesista = Id;

-- Paso 3: Crear una tabla temporal con los DNI duplicados y el Id mayor para cada uno
CREATE TEMPORARY TABLE DNIDuplicados AS
SELECT 
    DNI,
    MAX(Id) AS IdMayor
FROM 
    tblTesistas
GROUP BY 
    DNI
HAVING 
    COUNT(*) > 1;

-- Paso 4: Actualizar la columna idTesista para todos los registros con DNI duplicados
UPDATE tblTesistas t
INNER JOIN DNIDuplicados d ON t.DNI = d.DNI
SET t.idTesista = d.IdMayor;

-- Paso 5: Eliminar la tabla temporal
DROP TEMPORARY TABLE IF EXISTS DNIDuplicados;





-- Paso 1: Crear una tabla de mapeo
CREATE TABLE MapeoTesistas (
    idOriginal INT,
    idNuevo INT AUTO_INCREMENT,
    PRIMARY KEY (idNuevo)
);

-- Paso 2: Poblar la tabla con idTesista únicos
INSERT INTO MapeoTesistas (idOriginal)
SELECT DISTINCT idTesista
FROM tblTesistas
ORDER BY idTesista;

-- Opcional: Ver el contenido de la tabla
SELECT * FROM MapeoTesistas;