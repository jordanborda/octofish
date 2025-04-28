-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Desactivar temporalmente las restricciones de clave única
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Insertar datos de tblTesistas (en vriunap_pilar3) a tbl_Usuarios (en legacy_vriunap)
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
 Id,
 Nombres,
 Apellidos,
 'DNI',
 DNI,
 Correo,
 NULL,
 'Perú',
 Direccion,
 Sexo,
 NroCelular,
 NULL,
 Clave,
 NULL,
 Activo
FROM vriunap_pilar3.tblTesistas;

-- Reactivar las restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;

-- Restaurar SQL_MODE a su valor por defecto
SET SESSION sql_mode = DEFAULT;

-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Desactivar temporalmente las restricciones de clave única
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Insertar datos de tblDocentes (en vriunap_pilar3) a tbl_Usuarios (en legacy_vriunap)
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
 Id,
 Nombres,
 Apellidos,
 'DNI',
 DNI,
 Correo,
 NULL,
 'Perú',
 Direccion,
 Sexo,
 NroCelular,
 FechaNac,
 Clave,
 NULL,
 Activo
FROM vriunap_pilar3_abs_main.tblDocentes;

-- Reactivar las restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;

-- Restaurar SQL_MODE a su valor por defecto
SET SESSION sql_mode = DEFAULT;

-- Configurar SQL_MODE temporalmente para evitar problemas
SET SESSION sql_mode = '';

-- Desactivar temporalmente las restricciones de clave única
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- Verificar si las tablas existen antes de realizar la inserción
SET @legacy_users_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'legacy_vriunap'
    AND table_name = 'tbl_Usuarios'
);

SET @secres_exists = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'vriunap_pilar3'
    AND table_name = 'tblSecres'
);

-- Insertar datos de tblSecres (en vriunap_pilar3) a tbl_Usuarios (en legacy_vriunap)
-- Usando NOMBRES y APELLIDOS directamente
SET @insert_query = IF(@legacy_users_exists > 0 AND @secres_exists > 0,
    'INSERT IGNORE INTO legacy_vriunap.tbl_Usuarios (
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
     Id,
     IFNULL(NOMBRES, Resp), -- Usar NOMBRES si no es NULL, de lo contrario usar Resp
     IFNULL(APELLIDOS, ""), -- Usar APELLIDOS si no es NULL, de lo contrario vacío
     "DNI",
     CONCAT("SEC", LPAD(Id, 6, "0")), -- Genera un ID único con formato SEC000001
     Correo,
     NULL,
     "Perú",
     Direccion,
     NULL,
     Celular,
     NULL,
     Clave,
     NULL,
     Estado
    FROM vriunap_pilar3.tblSecres',
    'SELECT "No se puede realizar la inserción porque alguna tabla necesaria no existe"'
);

PREPARE stmt FROM @insert_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Reactivar las restricciones
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;

-- Restaurar SQL_MODE a su valor por defecto
SET SESSION sql_mode = DEFAULT;