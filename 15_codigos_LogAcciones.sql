SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

CREATE TABLE IF NOT EXISTS legacy_vriunap.logTramites (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdUsuario INT NOT NULL,
  Fecha DATETIME NULL DEFAULT NULL,
  Accion VARCHAR(60)
);

ALTER TABLE legacy_vriunap.logTramites MODIFY COLUMN Accion VARCHAR(60);
ALTER TABLE legacy_vriunap.logTramites MODIFY COLUMN Fecha DATETIME NULL DEFAULT NULL;

UPDATE legacy_vriunap.logTramites
SET Fecha = NULL
WHERE CAST(Fecha AS CHAR) = '0000-00-00 00:00:00';

UPDATE legacy_vriunap.logTramites SET Accion = 'Carga de Proyecto' WHERE Accion = 'Subida de Proyecto';
UPDATE legacy_vriunap.logTramites SET Accion = 'Acepta ser Asesor/Director de Proyecto' WHERE Accion IN ('Aceptación del Director', 'Aceptación de Director');
UPDATE legacy_vriunap.logTramites SET Accion = 'Proyecto enviado a revision' WHERE Accion IN ('Proyecto enviado a Revisión', 'Envio a Dictaminacion de Borrador', 'Habilita para dictamen');
UPDATE legacy_vriunap.logTramites SET Accion = 'Registro de dictamen' WHERE Accion IN (
  'Fin de Correcciones Jurado 3', 'Fin de Correcciones Jurado 2', 'Fin de Correcciones Jurado 1',
  'Dictaminación de Jurado 3', 'Dictaminación de Jurado 4', 'Dictaminación de Jurado 2',
  'Dictaminación de Jurado 1', 'Fin de Correcciones Borrador Jurado 3', 'Fin de Correcciones Borrador Jurado 1',
  'Fin de Correcciones Borrador Jurado 2', 'Fin de Correcciones Borrador Jurado 4',
  'Dictaminación de Jurado 1 : 1', 'Dictaminación de Jurado 3 : 1', 'Dictaminación de Jurado 2 : 1',
  'Dictaminación de Jurado 4 : 1', 'Dictaminación de Jurado 4 : 2', 'Fin de Correcciones Jurado 4',
  'Dictaminación de Jurado 3 : 2', 'Dictaminación de Jurado 1 : 2', 'Dictaminación de Jurado 2 : 2',
  'Dictaminación de Jurado 3 : 0', 'Dictaminación de Jurado 2 : 0', 'Dictaminación de Jurado 1 : 0',
  'Dictaminación de Jurado 4 : 0', 'registro de dictamen', 'Fin de Correcciones Borrador Jurado 2 /chdeanby1m',
  'Obsercación', 'Dictaminación de Jurado 1 - R', 'Registro dictamen'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Carga de proyecto corregido' WHERE Accion IN ('Subida de Corrección', 'Actualización Proyecto de tesis');
UPDATE legacy_vriunap.logTramites SET Accion = 'Retorna Proyecto' WHERE Accion IN ('Retorna Documento : Corregir Formato', 'Retorna Proyecto : Corregir Formato');
UPDATE legacy_vriunap.logTramites SET Accion = 'Carga de requisitos para habilitacion etapa borrador' WHERE Accion = 'Subida de Bachiller';
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de Jurado' WHERE Accion IN (
  'Cambio de Jurado de Proyecto', 'Cambio de Jurado y Envió de Borrador', 'CAMBIO DE JURADO PROYECTO',
  'Cambio de Jurado Borrador', 'Cambio de Jurado de Borrador', 'Cambio de Jurado -', 'cambio jurado',
  'Cambio de Jurados Borrador', ' Cambio de jurado', 'Cambio de Jurado (F)', 'Cambio de Jurado 2',
  'Cambio de Jurada', 'Cambio de Jurado por Licencia', 'Cambio de Jurado Presidente por Cargo',
  'Cambio de Jurado Pre-Sustentación'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Habilitacion de tramite para Carga de correciones' WHERE Accion IN (
  'Habilitacion de Subida', 'Habilitación de Subida de Correcciones', 'Habitacion',
  'Habilitacion Subir Correcciones', 'Habilitacion de Correcciones', 'detalle habilitación borrador',
  'Habilitación para nueva generación de acta'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Solicitud de Sustentacion no presencial' WHERE Accion = 'Solicitud No Presencial';
UPDATE legacy_vriunap.logTramites SET Accion = 'Tramite archivado por exceso de tiempos de ejecucion' WHERE Accion IN ('Proyecto de Tesis Archivado', 'Trámite Archivado');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cancelacion de Proyecto' WHERE Accion IN ('Cancelación de Proyecto', 'Cancelación de Proyecto de Tesis', 'Cancelar Proyecto de Tesis');
UPDATE legacy_vriunap.logTramites SET Accion = 'Archivado por exceso de tiempo en bandeja de jurado' WHERE Accion = 'Proyecto con tiempo excedido';
UPDATE legacy_vriunap.logTramites SET Accion = 'Renuncia a Tramite' WHERE Accion IN (
  'Renuncia a Proyecto de Tesis', 'Elminación de Trámite', 'Renuncia de Proyecto de Tesis',
  'Renuncia a borrador de tesis', 'Renuncia al Proyecto', 'Renuncia a Proyecto y Borrador de Tesis',
  'Renuncia  a Proyecto de Tesis'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Rechazo del proyecto por el director' WHERE Accion = 'Rechazo del Director';
UPDATE legacy_vriunap.logTramites SET Accion = 'Archivamiento de proyecto por exceso de tiempo Director' WHERE Accion = 'Exceso de tiempo Director/Asesor';
UPDATE legacy_vriunap.logTramites SET Accion = 'Correcion de Formato Borrador' WHERE Accion IN ('Revision de formato y envio', 'Corrección de Formato Borrador');
UPDATE legacy_vriunap.logTramites SET Accion = 'Registro de Fecha de Sustentacion' WHERE Accion = 'Fecha de Sustentacion';
UPDATE legacy_vriunap.logTramites SET Accion = 'Retrocede Estado' WHERE Accion IN ('Retroceso de estado', 'Retroce estado', 'Espera - Retrocede', 'Retroceso estado');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de Titulo de Proyecto de Tesis' WHERE Accion IN ('Cambio de Título', 'Cambio de nombre Titulo de Proyecto');
UPDATE legacy_vriunap.logTramites SET Accion = 'Restablecimiento de tramite' WHERE Accion IN ('Recuperación trámite', 'Activar Proyecto', 'Habilitacion de Proyecto', 'Reactivación de trámite', 'Trámite desarchivado');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de Asesor/Director' WHERE Accion IN ('Cambio de asesor', 'Cambio de Director');
UPDATE legacy_vriunap.logTramites SET Accion = 'Retiro de coasesor externo' WHERE Accion IN ('Retiro de Co asesor', 'Retiro coasesor');
UPDATE legacy_vriunap.logTramites SET Accion = 'Desaprobacion de Proyecto' WHERE Accion = 'Desaparobacion de Proyecto y Cancelación';
UPDATE legacy_vriunap.logTramites SET Accion = 'Eliminacion de un Tesista' WHERE Accion IN (
  'Renuncia de un Integrante', 'Renuncia de Tesista', 'Modificacion de Integrantes',
  'Modificación de Acta y Renuncia de Integrante', 'Renuncia a Proyecto de Tesis de un tesista',
  'Retirar un Tesista', 'Eliminación de un tesista de un proyecto'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Reconformacion de Jurado' WHERE Accion IN (
  'Reconformación jurados', 'Corrección de orden de Jurado', 'Cambio de orden de jurado'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Aprobacion de Proyecto' WHERE Accion = 'Visto Bueno';
UPDATE legacy_vriunap.logTramites SET Accion = 'Sorteo de Jurado' WHERE Accion IN ('Sorteo e Inicio de Revision', 'Confirmación de Sorteo');
UPDATE legacy_vriunap.logTramites SET Accion = 'Anulacion de Proyecto de Tesis' WHERE Accion IN ('DESHABILITADO', 'Retroceder y eliminar el proyecto', 'Anulación de Proyecto');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de Linea de Investigacion' WHERE Accion = 'cambio de LINEA';
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de nombre de Tesista' WHERE Accion = 'Cambio de nombre';
UPDATE legacy_vriunap.logTramites SET Accion = 'Correcion de estado' WHERE Accion IN ('Correccion por error en BD', 'Cancelación de Cambio', 'Corrección estado', 'Elimina estado 5');
UPDATE legacy_vriunap.logTramites SET Accion = 'Reprogramacion de Fecha de Sustentacion' WHERE Accion IN ('Reprogramacion de Sustentación', 'reprogramación sustentación');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cambio de Titulo de Tesis' WHERE Accion IN ('Corrección de titulo de Borrador', 'Cambio de Titulo de Borrador de Tesis');
UPDATE legacy_vriunap.logTramites SET Accion = 'Cancelacion de Proyecto por Desaprobacion' WHERE Accion IN (
  'Cancelación por Desaprobación de Proyecto', 'Cancelación por Desaprobación', 'Cancelación de Proyecto de Tesis por Desaprobación'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Inhabilitacion de Tesis por Plagio' WHERE Accion = 'Bloqueo del proyecto por Plagio';
UPDATE legacy_vriunap.logTramites SET Accion = 'Agregar Tesista' WHERE Accion IN (
  'Agrega Tesista', 'Agregar tesista a proyecyto', 'Reincorporación a proyecto', 'Agregar tesista a  proyecto'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Docente renuncia a Tesis' WHERE Accion IN (
  'Renuncia de jurado a proyecto aprobado', 'Docente renuncia a proyecto de tesis', 'Docente renuncia a borrador de tesis'
);
UPDATE legacy_vriunap.logTramites SET Accion = 'Restablecimiento de intentos de sorteo' WHERE Accion = 'Reestablecimiento sorteo';
UPDATE legacy_vriunap.logTramites SET Accion = 'Correcion fecha acta de sustentacion' WHERE Accion = 'Corrección fecha acta de sustentación';
UPDATE legacy_vriunap.logTramites SET Accion = 'Enviado al Director' WHERE Accion = 'Envio a Director';
UPDATE legacy_vriunap.logTramites SET Accion = 'Recepcion de ejemplares de borrador de tesis' WHERE Accion = 'Recepción de ejemplares';
UPDATE legacy_vriunap.logTramites SET Accion = 'Habilitacion Excepcional' WHERE Accion = 'Habilitación Excepcional R.R. N° 2965';
