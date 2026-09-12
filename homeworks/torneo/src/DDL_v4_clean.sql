-- ============================================================================
-- 1. ENTIDADES INDEPENDIENTES (IDIOM CLASIFICADOR)
-- ============================================================================

CREATE TABLE public.categoria (
    cod_categoria varchar(10) NOT NULL,
    nombre varchar(50) NOT NULL,
    descripcion varchar(100),
    CONSTRAINT categoria_pk PRIMARY KEY (cod_categoria)
);

CREATE TABLE public.torneo (
    id_torneo serial NOT NULL,
    nombre varchar(80) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    CONSTRAINT torneo_pk PRIMARY KEY (id_torneo)
);

CREATE TABLE public.cancha (
    nro_cancha integer NOT NULL,
    nombre varchar(50) NOT NULL,
    disponible boolean NOT NULL DEFAULT true,
    CONSTRAINT cancha_pk PRIMARY KEY (nro_cancha),
    CONSTRAINT check_rango_cancha CHECK (nro_cancha BETWEEN 1 AND 12)
);

CREATE TABLE public.fase (
    cod_fase varchar(10) NOT NULL,
    nombre varchar(30) NOT NULL,
    orden_secuencia smallint NOT NULL,
    CONSTRAINT fase_pk PRIMARY KEY (cod_fase)
);

-- ============================================================================
-- 2. BLOQUE PERSONAS-ROLES IDIOM IS_A
-- ============================================================================

CREATE TABLE public.persona (
    id_persona serial NOT NULL,
    ci varchar(20) NOT NULL,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    telefono varchar(20) NOT NULL,
    CONSTRAINT persona_pk PRIMARY KEY (id_persona),
    CONSTRAINT persona_ci_uq UNIQUE (ci)
);

CREATE TABLE public.jugador (
    id_persona integer NOT NULL,
    mano_habil varchar(10) NOT NULL DEFAULT 'Diestro',
    club_origen varchar(20) DEFAULT 'Country Club',
    cod_categoria varchar(10) NOT NULL,
    CONSTRAINT jugador_pk PRIMARY KEY (id_persona),
    CONSTRAINT jugador_persona_fk FOREIGN KEY (id_persona)
        REFERENCES public.persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT jugador_categoria_fk FOREIGN KEY (cod_categoria)
        REFERENCES public.categoria (cod_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE public.arbitro (
    id_persona integer NOT NULL,
    nivel_certificacion varchar(50) NOT NULL,
    anios_experiencia smallint DEFAULT 0,
    CONSTRAINT arbitro_pk PRIMARY KEY (id_persona),
    CONSTRAINT arbitro_persona_fk FOREIGN KEY (id_persona)
        REFERENCES public.persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================================
-- 3. INSCRIPCIÓN Y CLASIFICACIÓN (IDIOMS COMPOSICIÓN Y MAESTRO-DETALLE)
-- ============================================================================

CREATE TABLE public.registro_jugador (
    fecha_inscripcion date NOT NULL,
    monto_pago numeric(8,2) NOT NULL,
    id_torneo integer NOT NULL,
    id_persona integer NOT NULL,
    CONSTRAINT registro_jugador_pk PRIMARY KEY (fecha_inscripcion, id_torneo, id_persona),
    CONSTRAINT registro_jugador_torneo_fk FOREIGN KEY (id_torneo)
        REFERENCES public.torneo (id_torneo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT registro_jugador_jugador_fk FOREIGN KEY (id_persona)
        REFERENCES public.jugador (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE public.grupo (
    id_grupo serial NOT NULL,
    nombre_grupo varchar(10) NOT NULL,
    id_torneo integer NOT NULL,
    cod_categoria varchar(10) NOT NULL,
    CONSTRAINT grupo_pk PRIMARY KEY (id_grupo),
    CONSTRAINT grupo_torneo_fk FOREIGN KEY (id_torneo)
        REFERENCES public.torneo (id_torneo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT grupo_categoria_fk FOREIGN KEY (cod_categoria)
        REFERENCES public.categoria (cod_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE public.detalle_grupo (
    nro_siembra smallint NOT NULL,
    clasificado boolean NOT NULL DEFAULT false,
    id_grupo integer NOT NULL,
    fecha_inscripcion date NOT NULL,
    id_torneo integer NOT NULL,
    id_persona integer NOT NULL,
    CONSTRAINT detalle_grupo_pk PRIMARY KEY (nro_siembra, id_grupo),
    CONSTRAINT detalle_grupo_grupo_fk FOREIGN KEY (id_grupo)
        REFERENCES public.grupo (id_grupo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT detalle_grupo_registro_fk FOREIGN KEY (fecha_inscripcion, id_torneo, id_persona) 
        REFERENCES public.registro_jugador (fecha_inscripcion, id_torneo, id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================================
-- 4. PARTIDOS Y MARCADORES (EVENTO Y MAESTRO-DETALLE)
-- ============================================================================

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
    CONSTRAINT chk_jugadores_distintos CHECK (id_persona_j1 <> id_persona_j2 AND id_torneo_j1 = id_torneo_j2),
    CONSTRAINT partido_cancha_fk FOREIGN KEY (nro_cancha)
        REFERENCES public.cancha (nro_cancha) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT partido_fase_fk FOREIGN KEY (cod_fase)
        REFERENCES public.fase (cod_fase) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT partido_grupo_fk FOREIGN KEY (id_grupo)
        REFERENCES public.grupo (id_grupo) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT partido_arbitro_fk FOREIGN KEY (id_arbitro)
        REFERENCES public.arbitro (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT partido_registro_j1_fk FOREIGN KEY (fecha_inscripcion_j1, id_torneo_j1, id_persona_j1)
        REFERENCES public.registro_jugador (fecha_inscripcion, id_torneo, id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT partido_registro_j2_fk FOREIGN KEY (fecha_inscripcion_j2, id_torneo_j2, id_persona_j2)
        REFERENCES public.registro_jugador (fecha_inscripcion, id_torneo, id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE public.set_partido (
    nro_set smallint NOT NULL,
    puntos_j1 smallint NOT NULL DEFAULT 0,
    puntos_j2 smallint NOT NULL DEFAULT 0,
    id_partido integer NOT NULL,
    CONSTRAINT set_partido_pk PRIMARY KEY (nro_set, id_partido),
    CONSTRAINT chk_rango_sets CHECK (nro_set BETWEEN 1 AND 5),
    CONSTRAINT chk_puntos_no_negativos CHECK (puntos_j1 >= 0 AND puntos_j2 >= 0),
    CONSTRAINT set_partido_partido_fk FOREIGN KEY (id_partido)
        REFERENCES public.partido (id_partido) ON DELETE CASCADE ON UPDATE CASCADE
);
