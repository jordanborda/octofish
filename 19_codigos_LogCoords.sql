SELECT
    CASE
        WHEN Just LIKE 'Envia Proyecto a Director%' THEN 'Envía Proyecto a Director'
        WHEN Just LIKE 'Retorna Documento%' THEN 'Retorna Documento: Corrección de Formato'
        WHEN Just LIKE 'Retorna Proyecto%' THEN 'Retorna Proyecto: Corrección de Formato'
        WHEN Just LIKE 'R.D.%' OR Just LIKE 'RD%' OR Just LIKE 'RESOLUCIÓN DECANAL%'
             OR Just LIKE 'RESOLUCION DECANAL%' OR Just LIKE 'RESOLUCIÓN DE DECANATO%'
             OR Just LIKE 'RESOLUCION DE DECANATO%' THEN 'Resolución Decanal'
        WHEN Just LIKE 'R.R.%' OR Just LIKE 'RR%' OR Just LIKE 'RESOLUCIÓN RECTORAL%' THEN 'Resolución Rectoral'
        WHEN Just LIKE 'Cambio estado Docente%' AND Just LIKE '%contrato%' THEN 'Cambio Estado Docente: Contrato'
        WHEN Just LIKE 'Cambio estado Docente%' AND (Just LIKE '%RESOLUCIÓN%' OR Just LIKE '%R.D.%' OR Just LIKE '%RD%')
            THEN 'Cambio Estado Docente: Resolución'
        WHEN Just LIKE 'Cambio estado Docente%' AND (Just LIKE '%R.R.%' OR Just LIKE '%RR%')
            THEN 'Cambio Estado Docente: Resolución Rectoral'
        WHEN Just LIKE 'Cambio estado Docente%' AND (Just LIKE '%MEMORANDO%' OR Just LIKE '%Memo%' OR Just LIKE '%OFICIO%')
            THEN 'Cambio Estado Docente: Memorando/Oficio'
        WHEN Just LIKE 'Cambio estado Docente%' THEN 'Cambio Estado Docente: Otro'
        WHEN Just LIKE 'OFICIO%' OR Just LIKE 'MEMORANDO%' OR Just LIKE 'Memo%' THEN 'Oficio/Memorando'
        WHEN Just LIKE 'Sorteo de Jurados%' THEN 'Sorteo de Jurados'
        WHEN Just LIKE 'Publico Sustentación%' THEN 'Publicación de Sustentación'
        WHEN Just LIKE 'Valida Lineas%' THEN 'Validación de Líneas'
        WHEN Just LIKE 'Recepcionó Ejemplares%' THEN 'Recepción de Ejemplares'
        WHEN Just LIKE 'Genero Acta%' THEN 'Generación de Acta'
        ELSE NULL
    END AS NormalizedJust,
    COUNT(*) AS TotalRegistros
FROM
    logCordinads
WHERE
    Just NOT LIKE 'Acceso a la Cuenta%'
GROUP BY
    NormalizedJust
HAVING
    NormalizedJust IS NOT NULL
ORDER BY
    TotalRegistros DESC;




    DELETE FROM logCordinads
WHERE Just NOT LIKE 'Envia Proyecto a Director%'
  AND Just NOT LIKE 'Retorna Documento%'
  AND Just NOT LIKE 'Retorna Proyecto%'
  AND Just NOT LIKE 'Sorteo de Jurados%'
  AND Just NOT LIKE 'Publico Sustentación%'
  AND Just NOT LIKE 'Valida Lineas%'
  AND Just NOT LIKE 'Recepcionó Ejemplares%'
  AND Just NOT LIKE 'Genero Acta%'
  AND Just NOT LIKE 'R.D.%' 
  AND Just NOT LIKE 'RD%' 
  AND Just NOT LIKE 'RESOLUCIÓN DECANAL%'
  AND Just NOT LIKE 'RESOLUCION DECANAL%' 
  AND Just NOT LIKE 'RESOLUCIÓN DE DECANATO%'
  AND Just NOT LIKE 'RESOLUCION DE DECANATO%'
  AND Just NOT LIKE 'R.R.%' 
  AND Just NOT LIKE 'RR%' 
  AND Just NOT LIKE 'RESOLUCIÓN RECTORAL%'
  AND Just NOT LIKE 'Cambio estado Docente%'
  AND Just NOT LIKE 'OFICIO%' 
  AND Just NOT LIKE 'MEMORANDO%' 
  AND Just NOT LIKE 'Memo%';


UPDATE logCordinads l
JOIN MapeoCoordinador m ON l.IdUser = m.IdOriginal
SET l.IdUser = m.IdNuevo;

-- Primero creamos la tabla en la base de datos destino con la misma estructura
CREATE TABLE legacy_vriunap.log_Coordinadores LIKE vriunap_pilar3.logCordinads;

-- Luego copiamos todos los datos
INSERT INTO legacy_vriunap.log_Coordinadores
SELECT * FROM vriunap_pilar3.logCordinads;