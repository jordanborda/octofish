UPDATE vriunap_pilar3.logCorreos l
JOIN vriunap_pilar3.MapeoTesistas m ON l.IdTesista = m.IdOriginal
SET l.IdTesista = m.IdNuevo;

UPDATE vriunap_pilar3.logCorreos l
JOIN vriunap_absmain.MapeoDocentes m ON l.IdDocente = m.IdOriginal
SET l.IdDocente = m.IdNuevo;


CREATE TABLE legacy_vriunap.log_Correos (
  Id int NOT NULL AUTO_INCREMENT,
  Fecha datetime NOT NULL,
  IdDocente int NOT NULL,
  IdTesista int NOT NULL,
  Correo varchar(50) NOT NULL,
  Titulo varchar(50) NOT NULL,
  Mensaje varchar(500) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



INSERT INTO legacy_vriunap.log_Correos (Id, Fecha, IdDocente, IdTesista, Correo, Titulo, Mensaje)
SELECT Id, Fecha, IdDocente, IdTesista, Correo, Titulo, Mensaje
FROM vriunap_pilar3.logCorreos;

UPDATE legacy_vriunap.log_Correos
SET IdTesista = 0
WHERE IdDocente = IdTesista;

ALTER TABLE legacy_vriunap.log_Correos 
MODIFY COLUMN IdTesista int NULL,
MODIFY COLUMN IdDocente int NULL;

UPDATE legacy_vriunap.log_Correos
SET IdTesista = NULL, IdDocente = NULL
WHERE IdDocente = IdTesista;


UPDATE legacy_vriunap.log_Correos
SET IdTesista = NULL
WHERE IdTesista = 0;

UPDATE legacy_vriunap.log_Correos
SET IdDocente = NULL
WHERE IdDocente = 0;

DELETE FROM legacy_vriunap.log_Correos
WHERE IdTesista IS NULL AND IdDocente IS NULL;