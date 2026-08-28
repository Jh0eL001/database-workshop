-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.0-beta1
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: Jzz
--CREATE DATABASE t2_composicion;

CREATE TABLE public.paciente (
	id_paciente serial NOT NULL,
	nombre varchar(50) NOT NULL,
	telefono varchar(50) NOT NULL,
	CONSTRAINT paciente_pk PRIMARY KEY (id_paciente)
);

ALTER TABLE public.paciente OWNER TO postgres;

CREATE TABLE public.doctor (
	id_doctor serial NOT NULL,
	nombre varchar(50) NOT NULL,
	especialidad varchar(50) NOT NULL,
	CONSTRAINT doctor_pk PRIMARY KEY (id_doctor)
);

ALTER TABLE public.doctor OWNER TO postgres;

CREATE TABLE public.consulta (
	fecha date NOT NULL,
	costo smallint NOT NULL,
	id_doctor_doctor integer NOT NULL,
	id_paciente_paciente integer NOT NULL,
	CONSTRAINT consulta_pk PRIMARY KEY (fecha,id_doctor_doctor,id_paciente_paciente)
);

ALTER TABLE public.consulta OWNER TO postgres;


-- object: doctor_fk | type: CONSTRAINT --
-- ALTER TABLE public.consulta DROP CONSTRAINT IF EXISTS doctor_fk CASCADE;
ALTER TABLE public.consulta ADD CONSTRAINT doctor_fk FOREIGN KEY (id_doctor_doctor)
REFERENCES public.doctor (id_doctor) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: paciente_fk | type: CONSTRAINT --
-- ALTER TABLE public.consulta DROP CONSTRAINT IF EXISTS paciente_fk CASCADE;
ALTER TABLE public.consulta ADD CONSTRAINT paciente_fk FOREIGN KEY (id_paciente_paciente)
REFERENCES public.paciente (id_paciente) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --


