-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- 1. Crear servicios en dic_Servicios
INSERT IGNORE INTO legacy_vriunap.dic_Servicios (Nombre, Descripcion, Estado)
VALUES 
('Tesista', 'Acceso a servicios para tesistas', 1),
('Docente', 'Acceso a servicios para docentes', 1),
('Coordinador', 'Acceso a servicios para coordinadores y secretarios', 1);

-- 2. Asignar usuarios al servicio "Tesista"
INSERT IGNORE INTO legacy_vriunap.tbl_UsuariosServicios (IdUsuario, IdServicio)
SELECT 
    t.Id AS IdUsuario,
    (SELECT Id FROM legacy_vriunap.dic_Servicios WHERE Nombre = 'Tesista') AS IdServicio
FROM vriunap_pilar3.tblTesistas t
WHERE EXISTS (
    SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = t.Id
);

-- 3. Asignar usuarios al servicio "Docente"
INSERT IGNORE INTO legacy_vriunap.tbl_UsuariosServicios (IdUsuario, IdServicio)
SELECT 
    d.Id AS IdUsuario,
    (SELECT Id FROM legacy_vriunap.dic_Servicios WHERE Nombre = 'Docente') AS IdServicio
FROM vriunap_absmain.tblDocentes d
WHERE EXISTS (
    SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = d.Id
);

-- 4. Asignar usuarios al servicio "Coordinador"
INSERT IGNORE INTO legacy_vriunap.tbl_UsuariosServicios (IdUsuario, IdServicio)
SELECT 
    s.Id AS IdUsuario,
    (SELECT Id FROM legacy_vriunap.dic_Servicios WHERE Nombre = 'Coordinador') AS IdServicio
FROM vriunap_pilar3.tblSecres s
WHERE EXISTS (
    SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = s.Id
);