--CREATE DATABASE encomiendas
--GO

USE encomiendas
GO

--lunes 29 de agosto 2022
--creacion de tablas base

CREATE TABLE personas
(
	idpersona	INT identity(1,1) primary key,
	apellidos		nvarchar(40) NOT NULL,
	nombres			nvarchar(40) NOT NULL,
	tipodocumento		char(1)	 NOT NULL, --D (DNI), C (CARNET EXTRANJERIA)
	numerodocumento		char(8)  NOT NULL,
	direccion			nvarchar(70)NULL,
	email				nvarchar(70)NULL,
	telefono			char(9)		NULL,
	CONSTRAINT ck_tipodocumento_per CHECK(tipodocumento IN ('D','C')),
	CONSTRAINT ck_numerodocumento_per CHECK(numerodocumento LIKE('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
	CONSTRAINT ck_telefono_per CHECK (telefono LIKE('[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
)
GO


CREATE TABLE usuarios
(
	idusuario		INT IDENTITY(1,1) PRIMARY KEY,
	idpersona		INT				NOT NULL,
	nombreusuario	NVARCHAR(20)	NOT NULL,
	claveacceso		NVARCHAR(100)	NOT NULL,
	nivelacceso		CHAR(1)			NOT NULL,--STANDARD / (A) dmin
	fecharegistro	DATETIME		NOT NULL DEFAULT GETDATE(),--ES UNA FUNCION  POR DEFECTO LA FECHA ACTUAL
	fechabaja		DATETIME		NULL,
	estado			BIT				NOT NULL,
	CONSTRAINT fk_idpersona_usuarios FOREIGN KEY(idpersona) REFERENCES personas(idpersona),
	CONSTRAINT uk_idpersona_usuarios UNIQUE(idpersona),
	CONSTRAINT uk_nombreusuario_usuarios UNIQUE(nombreusuario),
	CONSTRAINT CH_nivelacceso_usuarios CHECK(nivelacceso IN ('S','A'))
)
GO

CREATE TABLE clientes
(
	idcliente		INT			IDENTITY(1,1) PRIMARY KEY,
	idpersona		INT			NOT NULL,--foraneo
	fecharegistro	DATETIME	NOT NULL DEFAULT GETDATE(),
	tipocliente		CHAR(3)		NOT NULL,--cehck
	CONSTRAINT fk_idpersona_clientes FOREIGN KEY(idpersona) REFERENCES personas(idpersona),
	CONSTRAINT CH_tipocliente_clientes CHECK(tipocliente IN ('STD','VIP')),
)
GO

INSERT INTO personas (apellidos,nombres,tipodocumento,numerodocumento)VALUES
	('Padilla Chumbiauca','Marks Steven','D','75187090'),
	('Saavedra Arroyo','Jose Andres','D','77082168'),
	('Montesinos ','Jose','C','88888888'),
	('Magallanes','Juan','D','12345678')
GO

SELECT * FROM personas
GO

INSERT INTO usuarios(idpersona,nombreusuario,claveacceso,nivelacceso,estado) VALUES
	('1','Marks Steven','AAAAA','S','1'),
	('2','Jose Andres','AAAAA','A','1')
GO

INSERT INTO clientes(idpersona,tipocliente) VALUES
	('3','VIP'),
	('4','VIP')
GO

delete from clientes where idcliente=2

SELECT * FROM clientes
GO
	
----------------CLASE-----------LUNES-------05/09/2022----------------------------------------------------

--FUNCIONES IMPORTANTES

SELECT GETDATE() --fecha /hora/minuto/segundo/milisegundo
SELECT YEAR(GETDATE()) --OBTENER AÑO
SELECT MONTH(GETDATE()) --OBTENER MES
SELECT DAY(GETDATE())   --OBTENER DÍA
SELECT DAY('2005-08-10') --OBTENER EL DIA DE UNA FECHA EN PARTICULAR APLICA PARA(AÑO Y MES)
GO



--consulta detallada a la tabla Usuarios
SELECT * FROM usuarios
go

--INNER JOIN
SELECT USU.idusuario,USU.nombreusuario,USU.nivelacceso,PER.apellidos,PER.nombres
	FROM usuarios as USU
	INNER JOIN personas AS  PER on USU.idpersona = PER.idpersona 
go

--Vista

CREATE VIEW vs_usuario_basic
AS
SELECT USU.idusuario,USU.nombreusuario,USU.nivelacceso,PER.apellidos,PER.nombres,
	CASE USU.nivelacceso 
	WHEN 'S' THEN 'Standar'
	When 'A' THEN 'Administrador'
	END 'Nivel de acceso'
	FROM usuarios as USU
	INNER JOIN personas AS  PER on USU.idpersona = PER.idpersona 
	WHERE USU.estado=1
GO

select * from vs_usuario_basic
GO

SELECT * FROM clientes
go
--------TAREA---------

CREATE VIEW vs_cliente_basic
AS
SELECT CLI.idcliente,PER.apellidos,PER.nombres,PER.direccion,PER.telefono,CLI.tipocliente
	FROM clientes as CLI
	INNER JOIN personas AS  PER on CLI.idpersona = PER.idpersona 	
GO

select * from vs_cliente_basic
GO

-----PRACTICA DE ALTER TABLE(MODFICIAR ESTRUCTURA DE LA TABLA)-------

CREATE TABLE tmpPersona(
	idpersona INT IDENTITY(1,1),
	apellidos char(10) NULL,
	nombres varchar(500)NULL,
	dni INT NOT NULL,
	telefono CHAR(9),
	fax VARCHAR(10)NOT NULL

	CONSTRAINT uk_nombres_tmp UNIQUE(nombres),
	CONSTRAINT ck_dni_tmp CHECK (dni LIKE('[0-9]'))
)

GO
--Mejorando la estructura de la tabla

-- AGREGAR COLUMNA = ADD COLUMN

--Agregar 2 nuevos campos

ALTER TABLE tmpPersona ADD 
	fechacreacion DATETIME NOT NULL DEFAULT GETDATE()
	GO

SELECT * FROM tmpPersona

--PROCEDIMIENTO PARA OBTENER INFORMACION DE DICHA TABLA
EXEC sp_help 'tmpPersona'
GO

-- AGREGAR CAMPO (ADD)
ALTER TABLE tmpPersona ADD 
	estado BIT NOT NULL DEFAULT 1
	GO


--ELIMINAR COLUMNA (DROP COLUMN)

ALTER TABLE tmpPersona DROP COLUMN fax
GO


--QUITAR / ELIMINAR RESTRICCIONES (DROP CONSTRAINT)
ALTER TABLE tmpPersona DROP CONSTRAINT
uk_nombres_tmp,ck_dni_tmp
GO

--MODIFICAR CAMPOS (ALTER COLUMN)

ALTER TABLE tmpPersona ALTER COLUMN apellidos VARCHAR(40) NOT NULL
GO

ALTER TABLE tmpPersona ALTER COLUMN nombres VARCHAR(40) NOT NULL
GO

ALTER TABLE tmpPersona ALTER COLUMN DNI CHAR(8) NOT NULL
GO

--AGREGAR RESTRICCIONES (ADD CONSTRAINT)

ALTER TABLE tmpPersona ADD CONSTRAINT pk_idPersona_tmp PRIMARY KEY (idpersona)
GO

ALTER TABLE tmpPersona ADD CONSTRAINT uk_dni_tmp UNIQUE(dni)
GO

ALTER TABLE tmpPersona ADD CONSTRAINT ck_dni_tmp CHECK(dni LIKE('[0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9]'))
GO

ALTER TABLE tmpPersona ADD CONSTRAINT  ck_telefono_tmp CHECK (telefono LIKE('[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))

EXEC sp_help 'tmpPersona'
GO
 
 ------------------------------TAREA-------------------------------------------------

 --------------AGENCIA-------------------


 CREATE TABLE agencia(
	idagencia INT IDENTITY(1,1) PRIMARY KEY,
	direccion VARCHAR(70) NOT NULL,
	telefono char(9) NOT NULL,
	fechacreacion DATETIME NOT NULL DEFAULT GETDATE(),
	fechabaja DATETIME NULL,
	iddistrito varchar(6) NOT NULL,
	estado BIT NOT NULL,
 
 CONSTRAINT fk_distritos_agencia FOREIGN KEY(iddistrito) REFERENCES distritos(iddistrito),
 CONSTRAINT ck_telefono_agencia CHECK (telefono LIKE('[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
 )
 GO









 ---------ENCOMIENDA--------
 CREATE TABLE encomiendas(
	idencomiendas INT IDENTITY(1,1) PRIMARY KEY,
	idclienteorigen INT NOT NULL,
	idcliendestino INT NOT NULL,
	idusuariorigen INT NOT NULL,
	idusuariodestino INT NOT NULL,
	idagengiaorigen INT NOT NULL,
	idagenciadestino INT NOT NULL,
	fecharecepcion DATETIME NOT NULL DEFAULT GETDATE(),
	fechatraslado DATETIME NULL,
	fechadescarga DATETIME NULL,
	fechaentrega DATETIME NULL,
	endomicilio BIT NOT NULL DEFAULT 0,
	cantidadcajas smallint NOT NULL,
	direccionentrega varchar(80) NOT NULL,
	referenciadireccion VARCHAR(100)NOT NULL,
	claverecepcion CHAR(4)NOT NULL,
	precioservicio DECIMAL(7,2)NOT NULL,

	 CONSTRAINT fk_idcliente_origen FOREIGN KEY(idclienteorigen) REFERENCES clientes(idcliente),
	 CONSTRAINT  fk_idcliente_destino FOREIGN KEY(idcliendestino) REFERENCES clientes(idcliente),
	 CONSTRAINT fk_idusuari_origen FOREIGN KEY(idusuariorigen) REFERENCES usuarios(idusuario),
	 CONSTRAINT fk_idusuari_destino FOREIGN KEY(idusuariodestino ) REFERENCES usuarios(idusuario),
	 CONSTRAINT fk_idagengia_origen FOREIGN KEY(idagengiaorigen ) REFERENCES agencia(idagencia),
	 CONSTRAINT fk_idagencia_destino FOREIGN KEY(idagenciadestino  ) REFERENCES agencia(idagencia),
	 CONSTRAINT ck_cantidad_cajas CHECK (cantidadcajas > 1),
	 CONSTRAINT ck_precio_servicio CHECK (precioservicio > 1),
	 CONSTRAINT ck_clave_recepcion CHECK(claverecepcion LIKE('[0-9][0-9][0-9][0-9]'))

 )
 GO


