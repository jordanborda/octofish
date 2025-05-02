-- Configurar SQL_MODE temporalmente para evitar errores estrictos
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Migrar datos desde vriunap_pilar3.tblTesistas hacia legacy_vriunap.tbl_Usuarios
INSERT IGNORE INTO legacy_vriunap.tbl_Usuarios (
 Id,
 Nombre,
 Apellido,
 TipoDocIdentidad,
 NumDocIdentidad,
 Correo,
 CorreoGoogle,
 Pais,
 Direccion,
 Sexo,
 Telefono,
 FechaNacimiento,
 Password,
 RutaFoto,
 Estado
)
SELECT
 idTesista,                     -- Id → idTesista
 Nombres,                      -- Nombre
 Apellidos,                    -- Apellido
 'DNI',                        -- TipoDocIdentidad fijo como 'DNI'
 DNI,                          -- NumDocIdentidad
 Correo,                       -- Correo
 NULL,                         -- CorreoGoogle
 'Perú',                       -- Pais
 Direccion,                    -- Direccion
 LEFT(Sexo, 1),                -- Sexo → se toma solo el primer carácter ('M' o 'F')
 NroCelular,                   -- Telefono
 NULL,                         -- FechaNacimiento no disponible
 Clave,                        -- Password
 NULL,                         -- RutaFoto no disponible
 Activo                        -- Estado
FROM vriunap_pilar3.tblTesistas
WHERE idTesista IS NOT NULL;

-- Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;




-- Configurar SQL_MODE temporalmente para evitar errores estrictos
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Migrar datos desde vriunap_absmain.tblDocentes hacia legacy_vriunap.tbl_Usuarios
INSERT IGNORE INTO legacy_vriunap.tbl_Usuarios (
 Id,
 Nombre,
 Apellido,
 TipoDocIdentidad,
 NumDocIdentidad,
 Correo,
 CorreoGoogle,
 Pais,
 Direccion,
 Sexo,
 Telefono,
 FechaNacimiento,
 Password,
 RutaFoto,
 Estado
)
SELECT
 idDocente,                   -- Id → idDocente
 Nombres,                    -- Nombre
 Apellidos,                  -- Apellido
 'DNI',                      -- TipoDocIdentidad
 DNI,                        -- NumDocIdentidad
 Correo,                     -- Correo
 NULL,                       -- CorreoGoogle
 'Perú',                     -- Pais
 Direccion,                  -- Direccion
 LEFT(Sexo, 1),              -- Sexo (primer carácter)
 NroCelular,                 -- Telefono
 FechaNac,                   -- FechaNacimiento
 Clave,                      -- Password
 NULL,                       -- RutaFoto
 Activo                      -- Estado
FROM vriunap_absmain.tblDocentes
WHERE idDocente IS NOT NULL;

-- Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;


-- Configurar SQL_MODE temporalmente para evitar errores estrictos
SET SESSION sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Migrar datos desde vriunap_pilar3.tblSecres hacia legacy_vriunap.tbl_Usuarios
INSERT IGNORE INTO legacy_vriunap.tbl_Usuarios (
 Id,
 Nombre,
 Apellido,
 TipoDocIdentidad,
 NumDocIdentidad,
 Correo,
 CorreoGoogle,
 Pais,
 Direccion,
 Sexo,
 Telefono,
 FechaNacimiento,
 Password,
 RutaFoto,
 Estado
)
SELECT
 idCoordinador,              -- Id → idCoordinador
 COALESCE(NOMBRES, Resp),    -- Nombre (preferir NOMBRES, si no usar Resp)
 COALESCE(APELLIDOS, ""),    -- Apellido (si hay)
 'DNI',                      -- TipoDocIdentidad
 CONCAT('SEC', LPAD(Id, 6, '0')), -- NumDocIdentidad generado
 Correo,                     -- Correo
 NULL,                       -- CorreoGoogle
 'Perú',                     -- Pais
 Direccion,                  -- Direccion
 NULL,                       -- Sexo no disponible
 Celular,                    -- Telefono
 NULL,                       -- FechaNacimiento no disponible
 Clave,                      -- Password
 NULL,                       -- RutaFoto
 Estado                      -- Estado
FROM vriunap_pilar3.tblSecres
WHERE idCoordinador IS NOT NULL;

-- Restaurar restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = DEFAULT;
