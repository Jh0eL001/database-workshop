-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.0-beta1
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: Jhoel ZZ

-- DROP DATABASE IF EXISTS t2_maestro_detalle;
CREATE DATABASE t2_maestro_detalle;

CREATE TABLE public."LIBRO" (
	id_libro serial NOT NULL,
	titulo varchar(100) NOT NULL,
	autor varchar(50) NOT NULL,
	CONSTRAINT "LIBRO_pk" PRIMARY KEY (id_libro)
);
ALTER TABLE public."LIBRO" OWNER TO postgres;

CREATE TABLE public."CAPITULO" (
	nro_capitulo integer NOT NULL,
	titulo varchar(150) NOT NULL,
	paginas smallint NOT NULL,
	"id_libro_LIBRO" integer NOT NULL,
	CONSTRAINT "CAPITULO_pk" PRIMARY KEY (nro_capitulo,"id_libro_LIBRO")
);

ALTER TABLE public."CAPITULO" OWNER TO postgres;

- ALTER TABLE public."CAPITULO" DROP CONSTRAINT IF EXISTS "LIBRO_fk" CASCADE;
ALTER TABLE public."CAPITULO" ADD CONSTRAINT "LIBRO_fk" FOREIGN KEY ("id_libro_LIBRO")
REFERENCES public."LIBRO" (id_libro) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;


