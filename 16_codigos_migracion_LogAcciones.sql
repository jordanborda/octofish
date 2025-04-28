ALTER TABLE legacy_vriunap.log_Acciones MODIFY COLUMN IdAccion VARCHAR(60);

INSERT INTO legacy_vriunap.log_Acciones (
    IdTramite,
    IdEstado,
    IdAccion,
    IdUsuario,
    IdRol,
    Fecha,
    Mensaje
)
SELECT 
    IdTramite,
    -10 AS IdEstado,
    Accion AS IdAccion, -- Sin conversión, dejando el texto tal cual
    IdUser AS IdUsuario,
    CASE 
        WHEN UPPER(Quien) = 'PILAR' THEN 4
        WHEN Quien = 'Coordinacion' THEN 3
        WHEN Quien = 'Docente' THEN 2
        WHEN Quien = 'Tesista' THEN 1
        ELSE 4
    END AS IdRol,
    IFNULL(Fecha, CURRENT_TIMESTAMP) AS Fecha,
    Detalle AS Mensaje
FROM 
    vriunap_pilar3_abs_main.logTramites;





-- Crear la tabla dic_Acciones
CREATE TABLE legacy_vriunap.dic_Acciones (
    Id INT NOT NULL AUTO_INCREMENT,
    Accion VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id)
);

-- Insertar las 47 acciones
INSERT INTO legacy_vriunap.dic_Acciones (Accion) VALUES
('Acepta ser Asesor/Director de Proyecto'),
('Agregar Tesista'),
('Ampliación de Proyecto de Tesis'),
('Anulacion de Proyecto de Tesis'),
('Aprobación de Proyecto'),
('Archivado por exceso de tiempo en bandeja de jurado'),
('Archivamiento de proyecto por exceso de tiempo Director'),
('Cambio de Asesor/Director'),
('Cambio de Estado de Dictamen'),
('Cambio de Jurado'),
('Cambio de Linea de Investigacion'),
('Cambio de nombre de Tesista'),
('Cambio de Titulo de Proyecto de Tesis'),
('Cambio de Titulo de Tesis'),
('Cancelacion de Proyecto'),
('Cancelación de Proyecto por Desaprobación'),
('Carga de Proyecto'),
('Carga de proyecto corregido'),
('Carga de requisitos para habilitacion etapa borrador'),
('Correcion de estado'),
('Correcion de Formato Borrador'),
('Correcion fecha acta de sustentacion'),
('Desaprobación de Proyecto'),
('Docente renuncia a Tesis'),
('Eliminacion de un Tesista'),
('Enviado al Director'),
('Habilitacion de tramite para Carga de correciones'),
('Habilitacion Excepcional'),
('Inhabilitacion de Tesis por Plagio'),
('Proyecto enviado a revision'),
('Recepcion de ejemplares de borrador de tesis'),
('Rechazo del proyecto por el director'),
('Reconformación de Jurado'),
('Registro de dictamen'),
('Registro de Fecha de Sustentacion'),
('Renuncia a Tramite'),
('Reprogramacion de Fecha de Sustentacion'),
('Restablecimiento de intentos de sorteo'),
('Restablecimiento de tramite'),
('Retiro de coasesor externo'),
('Retorna Proyecto'),
('Retrocede Estado'),
('Solicitud de Sustentacion no presencial'),
('Sorteo de Jurado'),
('Subida de Borrador'),
('Subida de Borrador Final'),
('Tramite archivado por exceso de tiempos de ejecucion');



