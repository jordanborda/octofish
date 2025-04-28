-- 1. Crear la tabla en la base de datos de destino
CREATE TABLE legacy_vriunap.log_Logins (
  Id int NOT NULL AUTO_INCREMENT,
  Tipo varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  IdUser int NOT NULL,
  Fecha datetime NOT NULL,
  Accion varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  IP varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  OS varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  Browser varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 2. Copiar todos los datos de la tabla original a la nueva tabla
INSERT INTO legacy_vriunap.log_Logins (Tipo, IdUser, Fecha, Accion, IP, OS, Browser)
SELECT Tipo, IdUser, Fecha, Accion, IP, OS, Browser
FROM vriunap_pilar3.logLogins;



-- Desactivar temporalmente las restricciones de SQL mode
SET SESSION sql_mode = '';

-- 1. Actualizar los registros donde Tipo = 'T' (Tesistas)
UPDATE legacy_vriunap.log_Logins l
JOIN vriunap_pilar3.MapeoTesistas m ON l.IdUser = m.IdOriginal
SET l.IdUser = m.IdPrincipal
WHERE l.Tipo = 'T';

-- 2. Actualizar los registros donde Tipo = 'D' (Docentes)
UPDATE legacy_vriunap.log_Logins l
JOIN vriunap_pilar3_abs_main.MapeoDocentes m ON l.IdUser = m.IdOriginal
SET l.IdUser = m.IdNuevo
WHERE l.Tipo = 'D';

-- 3. Verificar cuántos registros se actualizaron
SELECT Tipo, COUNT(*) AS RegistrosActualizados
FROM legacy_vriunap.log_Logins
GROUP BY Tipo;

