-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.0-beta1
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: Jzz

-- Database creation must be performed outside a multi lined SQL file.
-- These commands were put in this file only as a convenience.
--
-- object: is_A_DB | type: DATABASE --
-- DROP DATABASE IF EXISTS is_A_DB;
-- CREATE DATABASE is_A_DB;
-- ddl-end --


-- object: public."USUARIO" | type: TABLE --
-- DROP TABLE IF EXISTS public."USUARIO" CASCADE;
CREATE TABLE public."USUARIO" (
	id_usuario integer NOT NULL,
	correo varchar(100) NOT NULL,
	password varchar(255) NOT NULL,
	fecha_registro timestamp NOT NULL,
	CONSTRAINT "USUARIO_pk" PRIMARY KEY (id_usuario)
);
-- ddl-end --
ALTER TABLE public."USUARIO" OWNER TO postgres;
-- ddl-end --

-- object: public."CLIENTE" | type: TABLE --
-- DROP TABLE IF EXISTS public."CLIENTE" CASCADE;
CREATE TABLE public."CLIENTE" (
	limite_credito numeric(12,2) NOT NULL,
	nivel_riesgo varchar(20) NOT NULL,
	"id_usuario_USUARIO" integer NOT NULL,
	CONSTRAINT "CLIENTE_pk" PRIMARY KEY ("id_usuario_USUARIO")
);
-- ddl-end --
ALTER TABLE public."CLIENTE" OWNER TO postgres;
-- ddl-end --

-- object: public."ADMINISTRADOR" | type: TABLE --
-- DROP TABLE IF EXISTS public."ADMINISTRADOR" CASCADE;
CREATE TABLE public."ADMINISTRADOR" (
	nivel_acceso integer NOT NULL,
	extension_telefonica varchar(10) NOT NULL,
	"id_usuario_USUARIO" integer NOT NULL,
	CONSTRAINT "ADMINISTRADOR_pk" PRIMARY KEY ("id_usuario_USUARIO")
);
-- ddl-end --
ALTER TABLE public."ADMINISTRADOR" OWNER TO postgres;
-- ddl-end --

-- object: "USUARIO_fk" | type: CONSTRAINT --
-- ALTER TABLE public."CLIENTE" DROP CONSTRAINT IF EXISTS "USUARIO_fk" CASCADE;
ALTER TABLE public."CLIENTE" ADD CONSTRAINT "USUARIO_fk" FOREIGN KEY ("id_usuario_USUARIO")
REFERENCES public."USUARIO" (id_usuario) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: "USUARIO_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ADMINISTRADOR" DROP CONSTRAINT IF EXISTS "USUARIO_fk" CASCADE;
ALTER TABLE public."ADMINISTRADOR" ADD CONSTRAINT "USUARIO_fk" FOREIGN KEY ("id_usuario_USUARIO")
REFERENCES public."USUARIO" (id_usuario) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --


