-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.0-beta1
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE new_database;
-- ddl-end --


-- object: public.categoria | type: TABLE --
-- DROP TABLE IF EXISTS public.categoria CASCADE;
CREATE TABLE public.categoria (
	cod_categoria varchar(10) NOT NULL,
	nombre varchar(50) NOT NULL,
	descripcion varchar(100),
	CONSTRAINT categoria_pk PRIMARY KEY (cod_categoria)
);
-- ddl-end --
COMMENT ON TABLE public.categoria IS E'categoria (padre) ----->  grupo (hija). Idiom Clasificador.';
-- ddl-end --
ALTER TABLE public.categoria OWNER TO postgres;
-- ddl-end --

-- object: public.torneo | type: TABLE --
-- DROP TABLE IF EXISTS public.torneo CASCADE;
CREATE TABLE public.torneo (
	id_torneo serial NOT NULL,
	nombre varchar(80) NOT NULL,
	fecha_inicio date NOT NULL,
	fecha_fin date NOT NULL,
	CONSTRAINT torneo_pk PRIMARY KEY (id_torneo)
);
-- ddl-end --
ALTER TABLE public.torneo OWNER TO postgres;
-- ddl-end --

-- object: public.cancha | type: TABLE --
-- DROP TABLE IF EXISTS public.cancha CASCADE;
CREATE TABLE public.cancha (
	nro_cancha integer NOT NULL,
	nombre varchar(50) NOT NULL,
	disponible boolean NOT NULL DEFAULT true,
	CONSTRAINT cancha_pk PRIMARY KEY (nro_cancha),
	CONSTRAINT check_rango_cancha CHECK (nro_cancha BETWEEN 1 AND 12)
);
-- ddl-end --
COMMENT ON TABLE public.cancha IS E'cancha ---> partido clasificador';
-- ddl-end --
ALTER TABLE public.cancha OWNER TO postgres;
-- ddl-end --

-- object: public.fase | type: TABLE --
-- DROP TABLE IF EXISTS public.fase CASCADE;
CREATE TABLE public.fase (
	cod_fase varchar(10) NOT NULL,
	nombre varchar(30) NOT NULL,
	orden_secuencia smallint NOT NULL,
	CONSTRAINT fase_pk PRIMARY KEY (cod_fase)
);
-- ddl-end --
ALTER TABLE public.fase OWNER TO postgres;
-- ddl-end --

-- object: public.persona | type: TABLE --
-- DROP TABLE IF EXISTS public.persona CASCADE;
CREATE TABLE public.persona (
	id_persona serial NOT NULL,
	ci varchar(20) NOT NULL,
	nombre varchar(50) NOT NULL,
	apellido varchar(50) NOT NULL,
	telefono varchar(20) NOT NULL,
	CONSTRAINT persona_pk PRIMARY KEY (id_persona)
);
-- ddl-end --
ALTER TABLE public.persona OWNER TO postgres;
-- ddl-end --

-- object: public.jugador | type: TABLE --
-- DROP TABLE IF EXISTS public.jugador CASCADE;
CREATE TABLE public.jugador (
	mano_habil varchar(10) NOT NULL DEFAULT 'Diestro',
	club_origen varchar(20) DEFAULT 'Country Club',
	id_persona integer NOT NULL,
	cod_categoria varchar(10) NOT NULL,
	CONSTRAINT jugador_pk PRIMARY KEY (id_persona)
);
-- ddl-end --
ALTER TABLE public.jugador OWNER TO postgres;
-- ddl-end --

-- object: public.arbitro | type: TABLE --
-- DROP TABLE IF EXISTS public.arbitro CASCADE;
CREATE TABLE public.arbitro (
	nivel_certificacion varchar(50) NOT NULL,
	anios_experiencia smallint DEFAULT 0,
	id_persona integer NOT NULL,
	CONSTRAINT arbitro_pk PRIMARY KEY (id_persona)
);
-- ddl-end --
ALTER TABLE public.arbitro OWNER TO postgres;
-- ddl-end --

-- object: persona_fk | type: CONSTRAINT --
-- ALTER TABLE public.jugador DROP CONSTRAINT IF EXISTS persona_fk CASCADE;
ALTER TABLE public.jugador ADD CONSTRAINT persona_fk FOREIGN KEY (id_persona)
REFERENCES public.persona (id_persona) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: persona_fk | type: CONSTRAINT --
-- ALTER TABLE public.arbitro DROP CONSTRAINT IF EXISTS persona_fk CASCADE;
ALTER TABLE public.arbitro ADD CONSTRAINT persona_fk FOREIGN KEY (id_persona)
REFERENCES public.persona (id_persona) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: categoria_fk | type: CONSTRAINT --
-- ALTER TABLE public.jugador DROP CONSTRAINT IF EXISTS categoria_fk CASCADE;
ALTER TABLE public.jugador ADD CONSTRAINT categoria_fk FOREIGN KEY (cod_categoria)
REFERENCES public.categoria (cod_categoria) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.registro_jugador | type: TABLE --
-- DROP TABLE IF EXISTS public.registro_jugador CASCADE;
CREATE TABLE public.registro_jugador (
	fecha_inscripcion date NOT NULL,
	monto_pago numeric(8,2) NOT NULL,
	id_torneo integer NOT NULL,
	id_persona integer NOT NULL,
	CONSTRAINT inscripcion_pk PRIMARY KEY (fecha_inscripcion,id_torneo,id_persona)
);
-- ddl-end --
COMMENT ON TABLE public.registro_jugador IS E'tabla composicion para torneo y jugador.';
-- ddl-end --
ALTER TABLE public.registro_jugador OWNER TO postgres;
-- ddl-end --

-- object: torneo_fk | type: CONSTRAINT --
-- ALTER TABLE public.registro_jugador DROP CONSTRAINT IF EXISTS torneo_fk CASCADE;
ALTER TABLE public.registro_jugador ADD CONSTRAINT torneo_fk FOREIGN KEY (id_torneo)
REFERENCES public.torneo (id_torneo) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: jugador_fk | type: CONSTRAINT --
-- ALTER TABLE public.registro_jugador DROP CONSTRAINT IF EXISTS jugador_fk CASCADE;
ALTER TABLE public.registro_jugador ADD CONSTRAINT jugador_fk FOREIGN KEY (id_persona)
REFERENCES public.jugador (id_persona) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: public.grupo | type: TABLE --
-- DROP TABLE IF EXISTS public.grupo CASCADE;
CREATE TABLE public.grupo (
	id_grupo serial NOT NULL,
	nombre_grupo varchar(10) NOT NULL,
	id_torneo integer NOT NULL,
	cod_categoria varchar(10) NOT NULL,
	CONSTRAINT grupo_pk PRIMARY KEY (id_grupo)
);
-- ddl-end --
COMMENT ON TABLE public.grupo IS E'grupo ----> detalle_grupo (Maestro-Detalle)\nrelacion con partido no null porque en octavos, cuartos, demas ya no pertenecen a ningun grupo';
-- ddl-end --
ALTER TABLE public.grupo OWNER TO postgres;
-- ddl-end --

-- object: torneo_fk | type: CONSTRAINT --
-- ALTER TABLE public.grupo DROP CONSTRAINT IF EXISTS torneo_fk CASCADE;
ALTER TABLE public.grupo ADD CONSTRAINT torneo_fk FOREIGN KEY (id_torneo)
REFERENCES public.torneo (id_torneo) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: categoria_fk | type: CONSTRAINT --
-- ALTER TABLE public.grupo DROP CONSTRAINT IF EXISTS categoria_fk CASCADE;
ALTER TABLE public.grupo ADD CONSTRAINT categoria_fk FOREIGN KEY (cod_categoria)
REFERENCES public.categoria (cod_categoria) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.detalle_grupo | type: TABLE --
-- DROP TABLE IF EXISTS public.detalle_grupo CASCADE;
CREATE TABLE public.detalle_grupo (
	nro_siembra smallint NOT NULL,
	clasificado boolean NOT NULL DEFAULT false,
	id_grupo integer NOT NULL,
	fecha_inscripcion date NOT NULL,
	id_torneo integer NOT NULL,
	id_persona integer NOT NULL,
	CONSTRAINT detalle_grupo_pk PRIMARY KEY (nro_siembra,id_grupo)
);
-- ddl-end --
COMMENT ON TABLE public.detalle_grupo IS E'Verificación del Idiom: En detalle_grupo, la columna id_grupo debe aparecer ahora con la etiqueta << pk fk >>, conformando la Clave Primaria Compuesta: (id_grupo, nro_siembra).';
-- ddl-end --
ALTER TABLE public.detalle_grupo OWNER TO postgres;
-- ddl-end --

-- object: grupo_fk | type: CONSTRAINT --
-- ALTER TABLE public.detalle_grupo DROP CONSTRAINT IF EXISTS grupo_fk CASCADE;
ALTER TABLE public.detalle_grupo ADD CONSTRAINT grupo_fk FOREIGN KEY (id_grupo)
REFERENCES public.grupo (id_grupo) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: registro_jugador_fk | type: CONSTRAINT --
-- ALTER TABLE public.detalle_grupo DROP CONSTRAINT IF EXISTS registro_jugador_fk CASCADE;
ALTER TABLE public.detalle_grupo ADD CONSTRAINT registro_jugador_fk FOREIGN KEY (fecha_inscripcion,id_torneo,id_persona)
REFERENCES public.registro_jugador (fecha_inscripcion,id_torneo,id_persona) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.partido | type: TABLE --
-- DROP TABLE IF EXISTS public.partido CASCADE;
CREATE TABLE public.partido (
	id_partido serial NOT NULL,
	fecha_hora timestamp NOT NULL,
	nro_cancha integer NOT NULL,
	cod_fase varchar(10) NOT NULL,
	id_grupo integer,
	id_arbitro integer,
	fecha_inscripcion_j1 date NOT NULL,
	id_torneo_j1 integer NOT NULL,
	id_persona_j1 integer NOT NULL,
	fecha_inscripcion_j2 date NOT NULL,
	id_torneo_j2 integer NOT NULL,
	id_persona_j2 integer NOT NULL,
	CONSTRAINT partido_pk PRIMARY KEY (id_partido),
	CONSTRAINT chk_jugadores_distintos CHECK (id_persona_j1 <> id_persona_j2 AND id_torneo_j1 = id_torneo_j2)
);
-- ddl-end --
COMMENT ON TABLE public.partido IS E'el punto de encuentro donde convergen la cancha, la etapa, el árbitro y los dos contrincantes.';
-- ddl-end --
ALTER TABLE public.partido OWNER TO postgres;
-- ddl-end --

-- object: cancha_fk | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS cancha_fk CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT cancha_fk FOREIGN KEY (nro_cancha)
REFERENCES public.cancha (nro_cancha) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fase_fk | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS fase_fk CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT fase_fk FOREIGN KEY (cod_fase)
REFERENCES public.fase (cod_fase) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: grupo_fk | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS grupo_fk CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT grupo_fk FOREIGN KEY (id_grupo)
REFERENCES public.grupo (id_grupo) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: arbitro_fk | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS arbitro_fk CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT arbitro_fk FOREIGN KEY (id_arbitro)
REFERENCES public.arbitro (id_persona) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.set_partido | type: TABLE --
-- DROP TABLE IF EXISTS public.set_partido CASCADE;
CREATE TABLE public.set_partido (
	nro_set smallint NOT NULL,
	puntos_j1 smallint NOT NULL DEFAULT 0,
	puntos_j2 smallint NOT NULL DEFAULT 0,
	id_partido integer NOT NULL,
	CONSTRAINT set_partido_pk PRIMARY KEY (nro_set,id_partido),
	CONSTRAINT chk_rango_sets CHECK (nro_set BETWEEN 1 and 5),
	CONSTRAINT chk_puntos_no_negativos CHECK (puntos_j1 >= 0 AND puntos_j2 >= 0)
);
-- ddl-end --
COMMENT ON TABLE public.set_partido IS E'MAESTRO-DETALLE';
-- ddl-end --
ALTER TABLE public.set_partido OWNER TO postgres;
-- ddl-end --

-- object: partido_fk | type: CONSTRAINT --
-- ALTER TABLE public.set_partido DROP CONSTRAINT IF EXISTS partido_fk CASCADE;
ALTER TABLE public.set_partido ADD CONSTRAINT partido_fk FOREIGN KEY (id_partido)
REFERENCES public.partido (id_partido) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: registro_jugador_fk | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS registro_jugador_fk CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT registro_jugador_fk FOREIGN KEY (fecha_inscripcion_j1,id_torneo_j1,id_persona_j1)
REFERENCES public.registro_jugador (fecha_inscripcion,id_torneo,id_persona) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: registro_jugador_fk1 | type: CONSTRAINT --
-- ALTER TABLE public.partido DROP CONSTRAINT IF EXISTS registro_jugador_fk1 CASCADE;
ALTER TABLE public.partido ADD CONSTRAINT registro_jugador_fk1 FOREIGN KEY (fecha_inscripcion_j2,id_torneo_j2,id_persona_j2)
REFERENCES public.registro_jugador (fecha_inscripcion,id_torneo,id_persona) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


