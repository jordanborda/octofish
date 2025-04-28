-- ======================================================================
-- Script Consolidado CORREGIDO para Limpiar y Estandarizar 'logTramites'
-- (Incluye workaround para sql_mode y fechas inválidas)
-- ======================================================================

-- !! ADVERTENCIA GENERAL !!
-- Este script realiza modificaciones estructurales, actualizaciones masivas
-- y eliminaciones PERMANENTES de datos.
-- ASEGÚRATE ABSOLUTAMENTE DE TENER UN RESPALDO FUNCIONAL Y RECIENTE
-- DE LA TABLA 'logTramites' (ej. 'logtramites_backup') ANTES DE CONTINUAR.
-- CREATE TABLE logtramites_backup LIKE logTramites;
-- INSERT INTO logtramites_backup SELECT * FROM logTramites;

-- ----------------------------------------------------------------------
-- Paso PREVIO: Obtener el SQL Mode Actual (¡Ejecútalo ANTES!)
-- ----------------------------------------------------------------------
-- NECESITAS copiar el resultado de este comando para usarlo más abajo.
-- SELECT @@sql_mode;
-- ¡¡ GUARDA EL RESULTADO DE ESTE COMANDO !!

-- ----------------------------------------------------------------------
-- Paso 1: Modificar Estructura de la Tabla (con workaround sql_mode)
-- ----------------------------------------------------------------------
-- Objetivo: Ajustar tamaño de 'Accion' y permitir NULL en 'Fecha'.

-- Paso 1.1: Relajar temporalmente el SQL Mode para permitir la modificación
--           a pesar de las fechas '0000-00-00 00:00:00'.
SET SESSION sql_mode = 'ALLOW_INVALID_DATES';
-- Alternativamente, si ALLOW_INVALID_DATES no funciona, puedes probar:
-- SET SESSION sql_mode = ''; -- Modo muy permisivo, úsalo con precaución.

-- Paso 1.2: Ejecutar las modificaciones estructurales AHORA
-- Aumentar tamaño de la columna 'Accion'
ALTER TABLE logTramites MODIFY COLUMN Accion VARCHAR(60); -- O 100

-- Permitir NULLs en la columna 'Fecha' y establecer NULL como default
ALTER TABLE logTramites MODIFY COLUMN Fecha DATETIME NULL DEFAULT NULL;

-- Paso 1.3: RESTAURAR INMEDIATAMENTE el SQL Mode Original (¡IMPORTANTE!)
-- Reemplaza 'PEGAR_AQUÍ_EL_VALOR_ORIGINAL_QUE_COPIASTE' con el resultado
-- del comando SELECT @@sql_mode; que ejecutaste al principio.

-- ----------------------------------------------------------------------
-- Paso 2: Limpiar Datos Inválidos de Fecha
-- ----------------------------------------------------------------------
-- Objetivo: Convertir las fechas '0000-00-00 00:00:00' a NULL.
--           Esto ahora es posible porque modificamos la estructura y
--           restauramos el sql_mode estricto (que ahora aceptará NULL).

UPDATE logTramites
SET Fecha = NULL
WHERE CAST(Fecha AS CHAR) = '0000-00-00 00:00:00';

-- ----------------------------------------------------------------------
-- Paso 3: Estandarizar Valores de la Columna 'Accion'
-- ----------------------------------------------------------------------
-- (Los comandos UPDATE para Accion van aquí - SIN CAMBIOS respecto al script anterior)

-- 49. Carga de Proyecto
UPDATE logTramites SET Accion = 'Carga de Proyecto' WHERE Accion = 'Subida de Proyecto';

-- 2. Acepta ser Asesor/Director de Proyecto
UPDATE logTramites SET Accion = 'Acepta ser Asesor/Director de Proyecto' WHERE Accion = 'Aceptación del Director';
UPDATE logTramites SET Accion = 'Acepta ser Asesor/Director de Proyecto' WHERE Accion = 'Aceptación de Director';

-- 32. Proyecto enviado a revision
UPDATE logTramites SET Accion = 'Proyecto enviado a revision' WHERE Accion = 'Proyecto enviado a Revisión';
UPDATE logTramites SET Accion = 'Proyecto enviado a revision' WHERE Accion = 'Envio a Dictaminacion de Borrador';
UPDATE logTramites SET Accion = 'Proyecto enviado a revision' WHERE Accion = 'Habilita para dictamen';

-- 38. Registro de dictamen
UPDATE logTramites SET Accion = 'Registro de dictamen' WHERE Accion IN (
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

-- 48. Carga de proyecto corregido
UPDATE logTramites SET Accion = 'Carga de proyecto corregido' WHERE Accion = 'Subida de Corrección';
UPDATE logTramites SET Accion = 'Carga de proyecto corregido' WHERE Accion = 'Actualización Proyecto de tesis';

-- 42. Retorna Proyecto
UPDATE logTramites SET Accion = 'Retorna Proyecto' WHERE Accion = 'Retorna Documento : Corregir Formato';
UPDATE logTramites SET Accion = 'Retorna Proyecto' WHERE Accion = 'Retorna Proyecto : Corregir Formato';

-- 45. Carga de requisitos para habilitacion etapa borrador
UPDATE logTramites SET Accion = 'Carga de requisitos para habilitacion etapa borrador' WHERE Accion = 'Subida de Bachiller';

-- 1. Cambio de Jurado
UPDATE logTramites SET Accion = 'Cambio de Jurado' WHERE Accion IN (
    'Cambio de Jurado de Proyecto', 'Cambio de Jurado y Envió de Borrador', 'CAMBIO DE JURADO PROYECTO',
    'Cambio de Jurado Borrador', 'Cambio de Jurado de Borrador', 'Cambio de Jurado -', 'cambio jurado',
    'Cambio de Jurados Borrador', ' Cambio de jurado', 'Cambio de Jurado (F)', 'Cambio de Jurado 2',
    'Cambio de Jurada', 'Cambio de Jurado por Licencia', 'Cambio de Jurado Presidente por Cargo',
    'Cambio de Jurado Pre-Sustentación'
);

-- 28. Habilitacion de tramite para Carga de correciones
UPDATE logTramites SET Accion = 'Habilitacion de tramite para Carga de correciones' WHERE Accion IN (
    'Habilitacion de Subida', 'Habilitación de Subida de Correcciones', 'Habitacion',
    'Habilitacion Subir Correcciones', 'Habilitacion de Correcciones', 'detalle habilitación borrador',
    'Habilitación para nueva generación de acta'
);

-- 44. Solicitud de Sustentacion no presencial
UPDATE logTramites SET Accion = 'Solicitud de Sustentacion no presencial' WHERE Accion = 'Solicitud No Presencial';

-- 31. Tramite archivado por exceso de tiempos de ejecucion
UPDATE logTramites SET Accion = 'Tramite archivado por exceso de tiempos de ejecucion' WHERE Accion = 'Proyecto de Tesis Archivado';
UPDATE logTramites SET Accion = 'Tramite archivado por exceso de tiempos de ejecucion' WHERE Accion = 'Trámite Archivado';

-- 15. Cancelacion de Proyecto
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto' WHERE Accion = 'Cancelación de Proyecto';
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto' WHERE Accion = 'Cancelación de Proyecto de Tesis';
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto' WHERE Accion = 'Cancelar Proyecto de Tesis';

-- 30. Archivado por exceso de tiempo en bandeja de jurado
UPDATE logTramites SET Accion = 'Archivado por exceso de tiempo en bandeja de jurado' WHERE Accion = 'Proyecto con tiempo excedido';

-- 24. Renuncia a Tramite
UPDATE logTramites SET Accion = 'Renuncia a Tramite' WHERE Accion IN (
    'Renuncia a Proyecto de Tesis', 'Elminación de Trámite', 'Renuncia de Proyecto de Tesis',
    'Renuncia a borrador de tesis', 'Renuncia al Proyecto', 'Renuncia a Proyecto y Borrador de Tesis',
    'Renuncia  a Proyecto de Tesis'
);

-- 34. Rechazo del proyecto por el director
UPDATE logTramites SET Accion = 'Rechazo del proyecto por el director' WHERE Accion = 'Rechazo del Director';

-- 26. Archivamiento de proyecto por exceso de tiempo Director
UPDATE logTramites SET Accion = 'Archivamiento de proyecto por exceso de tiempo Director' WHERE Accion = 'Exceso de tiempo Director/Asesor';

-- 18. Correcion de Formato Borrador
UPDATE logTramites SET Accion = 'Correcion de Formato Borrador' WHERE Accion = 'Revision de formato y envio';
UPDATE logTramites SET Accion = 'Correcion de Formato Borrador' WHERE Accion = 'Corrección de Formato Borrador';

-- 27. Registro de Fecha de Sustentacion
UPDATE logTramites SET Accion = 'Registro de Fecha de Sustentacion' WHERE Accion = 'Fecha de Sustentacion';

-- 43. Retrocede Estado
UPDATE logTramites SET Accion = 'Retrocede Estado' WHERE Accion IN ('Retroceso de estado', 'Retroce estado', 'Espera - Retrocede', 'Retroceso estado');

-- 12. Cambio de Titulo de Proyecto de Tesis
UPDATE logTramites SET Accion = 'Cambio de Titulo de Proyecto de Tesis' WHERE Accion = 'Cambio de Título';
UPDATE logTramites SET Accion = 'Cambio de Titulo de Proyecto de Tesis' WHERE Accion = 'Cambio de nombre Titulo de Proyecto';

-- 36. Restablecimiento de tramite
UPDATE logTramites SET Accion = 'Restablecimiento de tramite' WHERE Accion IN (
    'Recuperación trámite', 'Activar Proyecto', 'Habilitacion de Proyecto', 'Reactivación de trámite', 'Trámite desarchivado'
);

-- 8. Cambio de Asesor/Director
UPDATE logTramites SET Accion = 'Cambio de Asesor/Director' WHERE Accion = 'Cambio de asesor';
UPDATE logTramites SET Accion = 'Cambio de Asesor/Director' WHERE Accion = 'Cambio de Director';

-- 41. Retiro de coasesor externo
UPDATE logTramites SET Accion = 'Retiro de coasesor externo' WHERE Accion = 'Retiro de Co asesor';
UPDATE logTramites SET Accion = 'Retiro de coasesor externo' WHERE Accion = 'Retiro coasesor';

-- 21. Desaprobacion de Proyecto
UPDATE logTramites SET Accion = 'Desaprobacion de Proyecto' WHERE Accion = 'Desaparobacion de Proyecto y Cancelación';

-- 23. Eliminacion de un Tesista
UPDATE logTramites SET Accion = 'Eliminacion de un Tesista' WHERE Accion IN (
    'Renuncia de un Integrante', 'Renuncia de Tesista', 'Modificacion de Integrantes',
    'Modificación de Acta y Renuncia de Integrante', 'Renuncia a Proyecto de Tesis de un tesista',
    'Retirar un Tesista', 'Eliminación de un tesista de un proyecto'
);

-- 35. Reconformacion de Jurado (Cubre también mapeo de #13)
UPDATE logTramites SET Accion = 'Reconformacion de Jurado' WHERE Accion = 'Reconformación jurados';
UPDATE logTramites SET Accion = 'Reconformacion de Jurado' WHERE Accion = 'Corrección de orden de Jurado';
UPDATE logTramites SET Accion = 'Reconformacion de Jurado' WHERE Accion = 'Cambio de orden de jurado';

-- 6. Aprobacion de Proyecto
UPDATE logTramites SET Accion = 'Aprobacion de Proyecto' WHERE Accion = 'Visto Bueno';

-- 17. Sorteo de Jurado
UPDATE logTramites SET Accion = 'Sorteo de Jurado' WHERE Accion = 'Sorteo e Inicio de Revision';
UPDATE logTramites SET Accion = 'Sorteo de Jurado' WHERE Accion = 'Confirmación de Sorteo';

-- 5. Anulacion de Proyecto de Tesis
UPDATE logTramites SET Accion = 'Anulacion de Proyecto de Tesis' WHERE Accion = 'DESHABILITADO';
UPDATE logTramites SET Accion = 'Anulacion de Proyecto de Tesis' WHERE Accion = 'Retroceder y eliminar el proyecto';
UPDATE logTramites SET Accion = 'Anulacion de Proyecto de Tesis' WHERE Accion = 'Anulación de Proyecto';

-- 10. Cambio de Linea de Investigacion
UPDATE logTramites SET Accion = 'Cambio de Linea de Investigacion' WHERE Accion = 'cambio de LINEA';

-- 11. Cambio de nombre de Tesista
UPDATE logTramites SET Accion = 'Cambio de nombre de Tesista' WHERE Accion = 'Cambio de nombre';

-- 19. Correcion de estado
UPDATE logTramites SET Accion = 'Correcion de estado' WHERE Accion = 'Correccion por error en BD';
UPDATE logTramites SET Accion = 'Correcion de estado' WHERE Accion = 'Cancelación de Cambio';
UPDATE logTramites SET Accion = 'Correcion de estado' WHERE Accion = 'Corrección estado';
UPDATE logTramites SET Accion = 'Correcion de estado' WHERE Accion = 'Elimina estado 5';

-- 39. Reprogramacion de Fecha de Sustentacion
UPDATE logTramites SET Accion = 'Reprogramacion de Fecha de Sustentacion' WHERE Accion = 'Reprogramacion de Sustentación';
UPDATE logTramites SET Accion = 'Reprogramacion de Fecha de Sustentacion' WHERE Accion = 'reprogramación sustentación';

-- 14. Cambio de Titulo de Tesis
UPDATE logTramites SET Accion = 'Cambio de Titulo de Tesis' WHERE Accion = 'Corrección de titulo de Borrador';
UPDATE logTramites SET Accion = 'Cambio de Titulo de Tesis' WHERE Accion = 'Cambio de Titulo de Borrador de Tesis';

-- 16. Cancelacion de Proyecto por Desaprobacion
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto por Desaprobacion' WHERE Accion = 'Cancelación por Desaprobación de Proyecto';
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto por Desaprobacion' WHERE Accion = 'Cancelación por Desaprobación';
UPDATE logTramites SET Accion = 'Cancelacion de Proyecto por Desaprobacion' WHERE Accion = 'Cancelación de Proyecto de Tesis por Desaprobación';

-- 7. Inhabilitacion de Tesis por Plagio
UPDATE logTramites SET Accion = 'Inhabilitacion de Tesis por Plagio' WHERE Accion = 'Bloqueo del proyecto por Plagio';

-- 3. Agregar Tesista
UPDATE logTramites SET Accion = 'Agregar Tesista' WHERE Accion = 'Agrega Tesista';
UPDATE logTramites SET Accion = 'Agregar Tesista' WHERE Accion = 'Agregar tesista a proyecyto';
UPDATE logTramites SET Accion = 'Agregar Tesista' WHERE Accion = 'Reincorporación a proyecto';
UPDATE logTramites SET Accion = 'Agregar Tesista' WHERE Accion = 'Agregar tesista a  proyecto';

-- 22. Docente renuncia a Tesis
UPDATE logTramites SET Accion = 'Docente renuncia a Tesis' WHERE Accion = 'Renuncia de jurado a proyecto aprobado';
UPDATE logTramites SET Accion = 'Docente renuncia a Tesis' WHERE Accion = 'Docente renuncia a proyecto de tesis';
UPDATE logTramites SET Accion = 'Docente renuncia a Tesis' WHERE Accion = 'Docente renuncia a borrador de tesis';

-- 37. Restablecimiento de intentos de sorteo
UPDATE logTramites SET Accion = 'Restablecimiento de intentos de sorteo' WHERE Accion = 'Reestablecimiento sorteo';

-- 20. Correcion fecha acta de sustentacion
UPDATE logTramites SET Accion = 'Correcion fecha acta de sustentacion' WHERE Accion = 'Corrección fecha acta de sustentación';

-- Correcciones de omisiones detectadas anteriormente
UPDATE logTramites SET Accion = 'Enviado al Director' WHERE Accion = 'Envio a Director';
UPDATE logTramites SET Accion = 'Recepcion de ejemplares de borrador de tesis' WHERE Accion = 'Recepción de ejemplares';
UPDATE logTramites SET Accion = 'Habilitacion Excepcional' WHERE Accion = 'Habilitación Excepcional R.R. N° 2965';


-- ----------------------------------------------------------------------
-- Paso 4: Eliminar Filas con Acciones No Estándar
-- ----------------------------------------------------------------------
-- Objetivo: Borrar todas las filas restantes cuya 'Accion' no coincida
--           exactamente con la lista final de acciones válidas.

-- Paso 4.1 (PREVISUALIZACIÓN - RECOMENDADO): Ver qué se eliminaría
SELECT Accion, COUNT(*) as Total_A_Eliminar
FROM logTramites
WHERE Accion NOT IN (
    'Cambio de Jurado', 'Acepta ser Asesor/Director de Proyecto', 'Agregar Tesista',
    'Ampliacion de Proyecto de Tesis', 'Anulacion de Proyecto de Tesis', 'Aprobacion de Proyecto',
    'Inhabilitacion de Tesis por Plagio', 'Cambio de Asesor/Director', 'Cambio de Estado de Dictamen',
    'Cambio de Linea de Investigacion', 'Cambio de nombre de Tesista', 'Cambio de Titulo de Proyecto de Tesis',
    'Reconformacion de Jurado', 'Cambio de Titulo de Tesis', 'Cancelacion de Proyecto',
    'Cancelacion de Proyecto por Desaprobacion', 'Sorteo de Jurado', 'Correcion de Formato Borrador',
    'Correcion de estado', 'Correcion fecha acta de sustentacion', 'Desaprobacion de Proyecto',
    'Docente renuncia a Tesis', 'Eliminacion de un Tesista', 'Renuncia a Tramite', 'Enviado al Director',
    'Archivamiento de proyecto por exceso de tiempo Director', 'Registro de Fecha de Sustentacion',
    'Habilitacion de tramite para Carga de correciones', 'Habilitacion Excepcional',
    'Archivado por exceso de tiempo en bandeja de jurado', 'Tramite archivado por exceso de tiempos de ejecucion',
    'Proyecto enviado a revision', 'Recepcion de ejemplares de borrador de tesis',
    'Rechazo del proyecto por el director', 'Restablecimiento de tramite',
    'Restablecimiento de intentos de sorteo', 'Registro de dictamen', 'Reprogramacion de Fecha de Sustentacion',
    'Retiro de coasesor externo', 'Retorna Proyecto', 'Retrocede Estado',
    'Solicitud de Sustentacion no presencial', 'Carga de requisitos para habilitacion etapa borrador',
    'Subida de Borrador', 'Subida de Borrador Final', 'Carga de proyecto corregido', 'Carga de Proyecto'
) AND Accion IS NOT NULL AND Accion != '' -- Excluir nulos o vacíos explícitamente si existen
GROUP BY Accion;

-- Paso 4.2 (CONTEO - OPCIONAL): Ver cuántas filas se eliminarían
SELECT COUNT(*) as Total_Filas_A_Eliminar
FROM logTramites
WHERE Accion NOT IN (
    -- ... Pega la misma lista larga de 48 acciones válidas aquí ...
    'Cambio de Jurado', 'Acepta ser Asesor/Director de Proyecto', 'Agregar Tesista',
    'Ampliacion de Proyecto de Tesis', 'Anulacion de Proyecto de Tesis', 'Aprobacion de Proyecto',
    'Inhabilitacion de Tesis por Plagio', 'Cambio de Asesor/Director', 'Cambio de Estado de Dictamen',
    'Cambio de Linea de Investigacion', 'Cambio de nombre de Tesista', 'Cambio de Titulo de Proyecto de Tesis',
    'Reconformacion de Jurado', 'Cambio de Titulo de Tesis', 'Cancelacion de Proyecto',
    'Cancelacion de Proyecto por Desaprobacion', 'Sorteo de Jurado', 'Correcion de Formato Borrador',
    'Correcion de estado', 'Correcion fecha acta de sustentacion', 'Desaprobacion de Proyecto',
    'Docente renuncia a Tesis', 'Eliminacion de un Tesista', 'Renuncia a Tramite', 'Enviado al Director',
    'Archivamiento de proyecto por exceso de tiempo Director', 'Registro de Fecha de Sustentacion',
    'Habilitacion de tramite para Carga de correciones', 'Habilitacion Excepcional',
    'Archivado por exceso de tiempo en bandeja de jurado', 'Tramite archivado por exceso de tiempos de ejecucion',
    'Proyecto enviado a revision', 'Recepcion de ejemplares de borrador de tesis',
    'Rechazo del proyecto por el director', 'Restablecimiento de tramite',
    'Restablecimiento de intentos de sorteo', 'Registro de dictamen', 'Reprogramacion de Fecha de Sustentacion',
    'Retiro de coasesor externo', 'Retorna Proyecto', 'Retrocede Estado',
    'Solicitud de Sustentacion no presencial', 'Carga de requisitos para habilitacion etapa borrador',
    'Subida de Borrador', 'Subida de Borrador Final', 'Carga de proyecto corregido', 'Carga de Proyecto'
) AND Accion IS NOT NULL AND Accion != '';

-- Paso 4.3 (EJECUCIÓN DE BORRADO - ¡¡¡ACCIÓN DESTRUCTIVA!!!)
-- ¡¡¡SOLO EJECUTA ESTO SI ESTÁS COMPLETAMENTE SEGURO!!!
DELETE FROM logTramites
WHERE Accion NOT IN (
    -- ... Pega la misma lista larga de 48 acciones válidas aquí ...
    'Cambio de Jurado', 'Acepta ser Asesor/Director de Proyecto', 'Agregar Tesista',
    'Ampliacion de Proyecto de Tesis', 'Anulacion de Proyecto de Tesis', 'Aprobacion de Proyecto',
    'Inhabilitacion de Tesis por Plagio', 'Cambio de Asesor/Director', 'Cambio de Estado de Dictamen',
    'Cambio de Linea de Investigacion', 'Cambio de nombre de Tesista', 'Cambio de Titulo de Proyecto de Tesis',
    'Reconformacion de Jurado', 'Cambio de Titulo de Tesis', 'Cancelacion de Proyecto',
    'Cancelacion de Proyecto por Desaprobacion', 'Sorteo de Jurado', 'Correcion de Formato Borrador',
    'Correcion de estado', 'Correcion fecha acta de sustentacion', 'Desaprobacion de Proyecto',
    'Docente renuncia a Tesis', 'Eliminacion de un Tesista', 'Renuncia a Tramite', 'Enviado al Director',
    'Archivamiento de proyecto por exceso de tiempo Director', 'Registro de Fecha de Sustentacion',
    'Habilitacion de tramite para Carga de correciones', 'Habilitacion Excepcional',
    'Archivado por exceso de tiempo en bandeja de jurado', 'Tramite archivado por exceso de tiempos de ejecucion',
    'Proyecto enviado a revision', 'Recepcion de ejemplares de borrador de tesis',
    'Rechazo del proyecto por el director', 'Restablecimiento de tramite',
    'Restablecimiento de intentos de sorteo', 'Registro de dictamen', 'Reprogramacion de Fecha de Sustentacion',
    'Retiro de coasesor externo', 'Retorna Proyecto', 'Retrocede Estado',
    'Solicitud de Sustentacion no presencial', 'Carga de requisitos para habilitacion etapa borrador',
    'Subida de Borrador', 'Subida de Borrador Final', 'Carga de proyecto corregido', 'Carga de Proyecto'
) OR Accion IS NULL OR Accion = ''; -- Asegurarse de eliminar también nulos o vacíos

-- ----------------------------------------------------------------------
-- Paso 5: Verificar Resultado Final (Opcional)
-- ----------------------------------------------------------------------
SELECT Accion, COUNT(*) as Total
FROM logTramites
GROUP BY Accion
ORDER BY Total DESC;

-- ======================================================================
-- FIN DEL SCRIPT
-- ======================================================================