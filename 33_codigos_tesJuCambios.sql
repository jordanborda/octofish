-- Crear la nueva tabla en la base de datos destino
CREATE TABLE IF NOT EXISTS legacy_vriunap.tbl_tesJuCambios (
  Id int NOT NULL AUTO_INCREMENT,
  IdTramite int NOT NULL,
  Tipo int NOT NULL,
  Referens varchar(50) NOT NULL,
  IdJurado int NOT NULL,
  Orden int NOT NULL,
  Fecha datetime NOT NULL,
  Motivo varchar(200) NOT NULL,
  IdEstado int NOT NULL DEFAULT 1,
  IdUsuarioAsignador int NOT NULL DEFAULT 1,
  Estado tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Configurar SQL_MODE temporalmente para evitar problemas con fechas
SET SESSION sql_mode = '';

-- Migrar los datos de IdJurado1
INSERT INTO legacy_vriunap.tbl_tesJuCambios 
(IdTramite, Tipo, Referens, IdJurado, Orden, Fecha, Motivo, IdEstado, IdUsuarioAsignador, Estado)
SELECT 
    IdTramite,
    Tipo,
    Referens,
    IdJurado1 AS IdJurado,
    1 AS Orden,
    Fecha,
    Motivo,
    1 AS IdEstado,
    1 AS IdUsuarioAsignador,
    1 AS Estado
FROM vriunap_pilar3.tesJuCambios
WHERE IdJurado1 > 0;

-- Migrar los datos de IdJurado2
INSERT INTO legacy_vriunap.tbl_tesJuCambios 
(IdTramite, Tipo, Referens, IdJurado, Orden, Fecha, Motivo, IdEstado, IdUsuarioAsignador, Estado)
SELECT 
    IdTramite,
    Tipo,
    Referens,
    IdJurado2 AS IdJurado,
    2 AS Orden,
    Fecha,
    Motivo,
    1 AS IdEstado,
    1 AS IdUsuarioAsignador,
    1 AS Estado
FROM vriunap_pilar3.tesJuCambios
WHERE IdJurado2 > 0;

-- Migrar los datos de IdJurado3
INSERT INTO legacy_vriunap.tbl_tesJuCambios 
(IdTramite, Tipo, Referens, IdJurado, Orden, Fecha, Motivo, IdEstado, IdUsuarioAsignador, Estado)
SELECT 
    IdTramite,
    Tipo,
    Referens,
    IdJurado3 AS IdJurado,
    3 AS Orden,
    Fecha,
    Motivo,
    1 AS IdEstado,
    1 AS IdUsuarioAsignador,
    1 AS Estado
FROM vriunap_pilar3.tesJuCambios
WHERE IdJurado3 > 0;

-- Migrar los datos de IdJurado4
INSERT INTO legacy_vriunap.tbl_tesJuCambios 
(IdTramite, Tipo, Referens, IdJurado, Orden, Fecha, Motivo, IdEstado, IdUsuarioAsignador, Estado)
SELECT 
    IdTramite,
    Tipo,
    Referens,
    IdJurado4 AS IdJurado,
    4 AS Orden,
    Fecha,
    Motivo,
    1 AS IdEstado,
    1 AS IdUsuarioAsignador,
    1 AS Estado
FROM vriunap_pilar3.tesJuCambios
WHERE IdJurado4 > 0;