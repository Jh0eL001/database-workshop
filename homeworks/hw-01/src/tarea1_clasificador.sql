-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.0-beta1
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: Jhoel Zeballos Zelada

-- object: tarea1_clasificacion | type: DATABASE --
--DROP DATABASE IF EXISTS tarea1_clasificacion;
--CREATE DATABASE tarea1_clasificacion;
-- ddl-end --


-- object: public.raza | type: TABLE --
-- DROP TABLE IF EXISTS public.raza CASCADE;
CREATE TABLE public.raza (
	id_raza serial NOT NULL,
	nombre varchar(50) NOT NULL,
	CONSTRAINT raza_pk PRIMARY KEY (id_raza)
);
-- ddl-end --
ALTER TABLE public.raza OWNER TO postgres;
-- ddl-end --

-- object: public.perro | type: TABLE --
DROP TABLE IF EXISTS public.perro CASCADE;
CREATE TABLE public.perro (
	id_perro serial NOT NULL,
	nombre varchar(50) NOT NULL,
	id_raza_raza integer NOT NULL,
	CONSTRAINT perro_pk PRIMARY KEY (id_perro)
);
-- ddl-end --
ALTER TABLE public.perro OWNER TO postgres;
-- ddl-end --

-- object: raza_fk | type: CONSTRAINT --
-- ALTER TABLE public.perro DROP CONSTRAINT IF EXISTS raza_fk CASCADE;
ALTER TABLE public.perro ADD CONSTRAINT raza_fk FOREIGN KEY (id_raza_raza)
REFERENCES public.raza (id_raza) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


