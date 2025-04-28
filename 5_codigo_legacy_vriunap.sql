-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS legacy_vriunap;
USE legacy_vriunap;

-- =====================================
-- TABLAS DE USUARIOS Y AUTENTICACIÓN
-- =====================================

CREATE TABLE tbl_Usuarios (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(75) NOT NULL,
  Apellido VARCHAR(75) NOT NULL,
  TipoDocIdentidad VARCHAR(30) NOT NULL,
  NumDocIdentidad VARCHAR(20) NOT NULL UNIQUE,
  Correo VARCHAR(255) NOT NULL UNIQUE,
  CorreoGoogle VARCHAR(255) NULL,
  Pais VARCHAR(75) NOT NULL,
  Direccion VARCHAR(255) NOT NULL,
  Sexo CHAR(1) NULL,
  Telefono VARCHAR(15) NULL,
  FechaNacimiento DATE NULL,
  Password VARCHAR(120) NOT NULL,
  RutaFoto VARCHAR(120) NULL,
  Estado TINYINT NOT NULL,
  INDEX idx_NumDocIdentidad (NumDocIdentidad),
  INDEX idx_Correo (Correo)
);

CREATE TABLE dic_Servicios (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL UNIQUE,
  Descripcion VARCHAR(255) NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE tbl_UsuariosServicios (
  IdUsuario INT NOT NULL,
  IdServicio INT NOT NULL,
  FechaAsignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (IdUsuario, IdServicio)
);

-- =====================================
-- TABLAS DE ESTRUCTURA ACADÉMICA
-- =====================================

CREATE TABLE dic_Areas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE dic_SubAreas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdArea INT NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE dic_Disciplinas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdSubArea INT NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE dic_Facultades (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Abreviatura VARCHAR(20) NOT NULL,
  IdArea INT NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE dic_Carreras (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdFacultad INT NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  TieneEspecialidades TINYINT NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE tbl_DetalleCarrera (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdCarrera INT NOT NULL,
  Descripcion VARCHAR(500) NULL,
  RutaArchivo VARCHAR(300) NULL,
  RutaArchivoBorrador VARCHAR(300) NULL,
  RutaEscudo VARCHAR(300) NULL
);

CREATE TABLE dic_Especialidades (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdCarrera INT NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE dic_Denominaciones (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdCarrera INT NOT NULL,
  IdEspecialidad INT NULL,
  DenominacionTitulo VARCHAR(200) NOT NULL,
  Estado TINYINT NOT NULL
);

-- =====================================
-- TABLAS DE PERFILES DE USUARIO
-- =====================================

CREATE TABLE dic_GradosAcademicos (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Abreviatura VARCHAR(15) NOT NULL
);

CREATE TABLE dic_CategoriasDocentes (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Tipo CHAR(1) NOT NULL,
  Nombre VARCHAR(50) NOT NULL,
  Abreviatura VARCHAR(15) NOT NULL
);

CREATE TABLE dic_EstadosTramite (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL UNIQUE,
  Descripcion VARCHAR(255) NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE tbl_Docentes (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL UNIQUE,
  CodigoDocente VARCHAR(20) NOT NULL UNIQUE,
  IdCategoria INT NULL,
  IdSubCategoria INT NULL,
  CodigoAIRHS VARCHAR(20) NULL,
  Estado TINYINT NOT NULL,
  INDEX idx_CodigoDocente (CodigoDocente),
  INDEX idx_CodigoAIRHS (CodigoAIRHS)
);

CREATE TABLE tbl_DocentesEstudios (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdDocente INT NOT NULL,
  Universidad VARCHAR(100) NOT NULL,
  IdGrado INT NOT NULL,
  AbreviaturaGrado VARCHAR(10) NOT NULL,
  Mencion VARCHAR(120) NULL,
  Especialidad VARCHAR(100) NULL,
  RutaDocumento VARCHAR(300) NULL,
  FechaObtencion DATE NOT NULL
);

CREATE TABLE tbl_DocentesEstadoHistorial (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdDocente INT NOT NULL,
  IdEstado INT NOT NULL,
  Activo TINYINT NOT NULL DEFAULT 1,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  NumeroResolucion VARCHAR(50) NULL,
  Comentario VARCHAR(255) NULL
);

CREATE TABLE tbl_Tesistas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL UNIQUE,
  CodigoEstudiante VARCHAR(20) NOT NULL UNIQUE,
  IdFacultad INT NOT NULL,
  IdCarrera INT NOT NULL,
  IdEspecialidad INT NULL,
  Estado TINYINT NOT NULL,
  INDEX idx_CodigoEstudiante (CodigoEstudiante)
);

CREATE TABLE tbl_Coordinadores (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL,
  IdFacultad INT NOT NULL,
  IdCarrera INT NOT NULL,
  NivelUsuario INT NOT NULL COMMENT '1=Básico, 2=Intermedio, 3=Avanzado',
  CorreoOficina VARCHAR(255) NOT NULL,
  DireccionOficina VARCHAR(500) NOT NULL,
  Horario VARCHAR(300) NOT NULL,
  FechaInicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FechaFin TIMESTAMP NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE tbl_CoordinadoresEstadoHistorial (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdCoordinador INT NOT NULL,
  IdEstado INT NOT NULL,
  Activo TINYINT NOT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  NumeroResolucion VARCHAR(50) NULL
);

CREATE TABLE tbl_Administradores (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL UNIQUE,
  FechaInicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FechaFin TIMESTAMP NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE tbl_PerfilesInvestigacion (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL UNIQUE,
  NombreInvestigador VARCHAR(200) NOT NULL,
  Institucion VARCHAR(200) NOT NULL,
  Afiliacion VARCHAR(200) NOT NULL,
  ORCID VARCHAR(50) NULL,
  IdRenacyt VARCHAR(50) NULL,
  NivelRenacyt VARCHAR(50) NULL,
  ScopusAuthorID VARCHAR(20) NULL,
  ResearcherID VARCHAR(20) NULL,
  CtivitaeID VARCHAR(20) NULL,
  AlternativoScopusID VARCHAR(20) NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE tbl_CoAsesoresExternos (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdUsuario INT NOT NULL UNIQUE,
  FechaRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FechaFin TIMESTAMP NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

-- =====================================
-- TABLAS DE LÍNEAS DE INVESTIGACIÓN
-- =====================================

CREATE TABLE dic_LineasUniversidad (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(800) NOT NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE tbl_LineasInvestigacion (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdLineaUniversidad INT NOT NULL,
  Nombre VARCHAR(300) NOT NULL,
  IdArea INT NOT NULL,
  IdSubArea INT NOT NULL,
  IdDisciplina INT NOT NULL,
  IdUsuarioCreador INT NOT NULL,
  IdFacultad INT NOT NULL,
  IdCarrera INT NOT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FechaModificacion TIMESTAMP NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE tbl_DocentesLineas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdDocente INT NOT NULL,
  IdLinea INT NOT NULL,
  Tipo INT NOT NULL,
  IdEstado INT NOT NULL,
  UNIQUE KEY uk_docente_linea (IdDocente, IdLinea)
);

CREATE TABLE log_DocentesLineas (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdDocenteLinea INT NOT NULL,
  IdEstado INT NOT NULL,
  IdResponsable INT NOT NULL,
  Observacion VARCHAR(500) NOT NULL,
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- TABLAS DE TRÁMITES DE TESIS
-- =====================================

CREATE TABLE dic_Modalidades (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Descripcion VARCHAR(200) NOT NULL,
  Ruta VARCHAR(100) NULL,
  Estado TINYINT NOT NULL
);

CREATE TABLE tbl_Tramites (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTesista INT NOT NULL,
  Codigo VARCHAR(20) NOT NULL,
  Anio INT NOT NULL,
  IdEstado INT NOT NULL,
  IdSubLinea INT NOT NULL,
  IdModalidad INT NOT NULL,
  TieneCoAsesorExterno TINYINT NOT NULL,
  IdFacultad INT NOT NULL,
  IdCarrera INT NOT NULL,
  IdEspecialidad INT NULL,
  TipoTrabajo VARCHAR(1) NOT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_Codigo (Codigo),
  INDEX idx_Tesista_Anio (IdTesista, Anio)
);

CREATE TABLE tbl_TramitesDet (
  Id int NOT NULL AUTO_INCREMENT,
  IdTramite int NOT NULL,
  Iteracion int NOT NULL,
  Titulo varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  Archivo varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  vb1 int NOT NULL,
  vb2 int NOT NULL,
  vb3 int NOT NULL,
  vb4 int NOT NULL,
  Fecha datetime NOT NULL,
  Obs varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
);

CREATE TABLE tbl_TramitesHistorial (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdEstado INT NOT NULL,
  Activo TINYINT NOT NULL,
  FechaCambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Comentario VARCHAR(500) NULL,
  IdUsuarioResponsable INT NOT NULL
);

CREATE TABLE tbl_ConformacionJurados (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdJurado INT NOT NULL,
  Orden INT NOT NULL,
  IdEstado INT NOT NULL,
  FechaAsignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  IdUsuarioAsignador INT NOT NULL,
  Estado TINYINT NOT NULL,
  UNIQUE KEY uk_tramite_jurado (IdTramite, IdJurado)
);

CREATE TABLE tbl_Dictamenes (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdJurado INT NOT NULL,
  IdEstado INT NOT NULL,
  Dictamen TEXT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FechaActualizacion TIMESTAMP NULL,
  Activo TINYINT NOT NULL,
  UNIQUE KEY uk_tramite_jurado (IdTramite, IdJurado)
);

CREATE TABLE tbl_CorrecionesObservaciones (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdEstado INT NOT NULL,
  IdDocente INT NOT NULL,
  Mensaje TEXT NOT NULL,
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Estado TINYINT NOT NULL
);

-- =====================================
-- TABLAS DE PARENTESCO Y RELACIONES
-- =====================================

CREATE TABLE dic_TiposParentesco (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL,
  Descripcion VARCHAR(255) NULL
);

CREATE TABLE tbl_Parentescos (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdDocente1 INT NOT NULL,
  IdDocente2 INT NOT NULL,
  IdTipoParentesco INT NOT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_docentes_parentesco (IdDocente1, IdDocente2, IdTipoParentesco)
);

-- =====================================
-- TABLAS DE SISTEMA Y AUDITORÍA
-- =====================================

CREATE TABLE dic_TiposMensaje (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL UNIQUE,
  Descripcion VARCHAR(255) NULL
);

CREATE TABLE log_Mensajes (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTipo INT NOT NULL,
  IdEmisor INT NOT NULL,
  IdReceptor INT NOT NULL,
  Mensaje TEXT NOT NULL,
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  RutaArchivo VARCHAR(300) NULL
);

CREATE TABLE dic_TiposAccion (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL UNIQUE,
  Descripcion VARCHAR(255) NULL
);

CREATE TABLE log_Acciones (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTramite INT NOT NULL,
  IdEstado INT NOT NULL,
  IdAccion INT NOT NULL,
  IdUsuario INT NOT NULL,
  IdRol INT NOT NULL,
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Mensaje VARCHAR(1024) NOT NULL
);

CREATE TABLE dic_TiposEvento (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL,
  Descripcion VARCHAR(255) NULL
);

CREATE TABLE log_Eventos (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  IdTipo INT NOT NULL,
  IdUsuario INT NOT NULL,
  IP VARCHAR(50) NOT NULL,
  SistemaOperativo VARCHAR(100) NULL,
  Navegador VARCHAR(100) NULL,
  Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_DiasFeriados (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Fecha DATE NOT NULL,
  Descripcion VARCHAR(255) NOT NULL,
  FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FechaModificacion TIMESTAMP NULL,
  Estado TINYINT NOT NULL DEFAULT 1
);