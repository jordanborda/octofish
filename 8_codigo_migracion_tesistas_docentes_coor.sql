-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- 1. Insertar datos en tbl_Tesistas desde vriunap_pilar3.tblTesistas
INSERT IGNORE INTO legacy_vriunap.tbl_Tesistas (
    IdUsuario,
    CodigoEstudiante,
    IdFacultad,
    IdCarrera,
    IdEspecialidad,
    Estado
)
SELECT 
    t.Id AS IdUsuario,
    tc.Codigo AS CodigoEstudiante,
    tc.IdFacultad,
    tc.IdCarrera,
    tc.IdEspec AS IdEspecialidad,
    t.Activo AS Estado
FROM 
    vriunap_pilar3.tblTesistas t
JOIN 
    vriunap_pilar3.tblTesistasCodigos tc ON t.Id = tc.IdTesista
WHERE 
    EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = t.Id);

-- 2. Insertar datos en tbl_Coordinadores desde vriunap_pilar3.tblSecres
INSERT IGNORE INTO legacy_vriunap.tbl_Coordinadores (
    IdUsuario,
    IdFacultad,
    IdCarrera,
    NivelUsuario,
    CorreoOficina,
    DireccionOficina,
    Horario,
    FechaInicio,
    Estado
)
SELECT 
    s.Id AS IdUsuario,
    s.Id_Facultad AS IdFacultad,
    s.IdCarrera,
    s.UserLevel AS NivelUsuario,
    s.Correo AS CorreoOficina,
    s.Direccion AS DireccionOficina,
    s.Horario,
    s.FechReg AS FechaInicio,
    s.Estado
FROM 
    vriunap_pilar3.tblSecres s
WHERE 
    EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = s.Id);

-- 3. Insertar datos en tbl_Docentes desde vriunap_pilar3_abs_main.tblDocentes
INSERT IGNORE INTO legacy_vriunap.tbl_Docentes (
    IdUsuario,
    CodigoDocente,
    IdCategoria,
    IdSubCategoria,
    CodigoAIRHS,
    Estado
)
SELECT 
    d.Id AS IdUsuario,
    d.Codigo AS CodigoDocente,
    d.IdCategoria,
    d.SubCat AS IdSubCategoria,
    d.Renacyt AS CodigoAIRHS,
    d.Activo AS Estado
FROM 
    vriunap_pilar3_abs_main.tblDocentes d
WHERE 
    EXISTS (SELECT 1 FROM legacy_vriunap.tbl_Usuarios u WHERE u.Id = d.Id);