-- 1. CATÁLOGOS INDEPENDIENTES (CLASIFICADORES Y TORNEO)
INSERT INTO public.categoria (cod_categoria, nombre, descripcion) VALUES
('OPEN', 'Categoría Open', 'Máxima categoría abierta sin límite de edad'),
('A',    'Primera Categoría A', 'Nivel avanzado');

INSERT INTO public.fase (cod_fase, nombre, orden_secuencia) VALUES
('GRUPOS', 'Fase de Grupos', 1),
('FINAL',  'Gran Final',     2);

INSERT INTO public.cancha (nro_cancha, nombre, disponible) VALUES
(1, 'Cancha Central Sarco', true),
(2, 'Cancha Panamericana 2', true);

INSERT INTO public.torneo (nombre, fecha_inicio, fecha_fin) VALUES
('Campeonato Nacional Apertura 2026', '2026-04-10', '2026-04-15');

-- 2. PERSONAS (SUPERTIPO) Y SUS ROLES ESPECIALIZADOS (SUBTIPOS IS_A)
-- 4 competidores y 1 árbitro
INSERT INTO public.persona (ci, nombre, apellido, telefono) VALUES
('7011223', 'Carlos', 'Conrrado', '79712345'),
('7022334', 'Roberto', 'Mena',     '79723456'),
('7033445', 'Javier',  'Ríos',     '79734567'),
('7044556', 'Mateo',   'Guzmán',   '79745678'),
('6055667', 'Rolando', 'Torrico',  '78311222');

-- Especialización de jugadores (id_persona 1 al 4)
INSERT INTO public.jugador (id_persona, mano_habil, club_origen, cod_categoria) VALUES
(1, 'Diestro', 'Country Club', 'OPEN'),
(2, 'Zurdo',   'Country Club', 'OPEN'),
(3, 'Diestro', 'Club Sucre',   'OPEN'),
(4, 'Diestro', 'Club Urbarí',  'OPEN');

-- Especialización de árbitro (id_persona 5)
INSERT INTO public.arbitro (id_persona, nivel_certificacion, anios_experiencia) VALUES
(5, 'Árbitro Internacional IRT', 8);

-- 3. ADMISIÓN Y PAGO (IDIOM COMPOSICIÓN)
-- Los 4 jugadores pagan y formalizan su inscripción al Torneo 1
INSERT INTO public.registro_jugador (fecha_inscripcion, monto_pago, id_torneo, id_persona) VALUES
('2026-04-01', 250.00, 1, 1),
('2026-04-01', 250.00, 1, 2),
('2026-04-02', 250.00, 1, 3),
('2026-04-02', 250.00, 1, 4);

-- 4. CLASIFICACIÓN POR SERIES (IDIOM MAESTRO-DETALLE EN GRUPOS)
-- Se crea el Grupo A del torneo
INSERT INTO public.grupo (nombre_grupo, id_torneo, cod_categoria) VALUES
('Grupo A', 1, 'OPEN');

-- Se siembran los 4 jugadores registrados en el Grupo 1 (siembras del 1 al 4)
INSERT INTO public.detalle_grupo (nro_siembra, clasificado, id_grupo, fecha_inscripcion, id_torneo, id_persona) VALUES
(1, true,  1, '2026-04-01', 1, 1),
(2, false, 1, '2026-04-01', 1, 2),
(3, false, 1, '2026-04-02', 1, 3),
(4, false, 1, '2026-04-02', 1, 4);

-- 5. PROGRAMACIÓN DE PARTIDO Y RESULTADOS SET A SET (IDIOM MAESTRO-DETALLE)
-- Partido entre Carlos Conrrado (J1) y Roberto Mena (J2), arbitrado por Rolando Torrico
INSERT INTO public.partido (
    fecha_hora, nro_cancha, cod_fase, id_grupo, id_arbitro,
    fecha_inscripcion_j1, id_torneo_j1, id_persona_j1,
    fecha_inscripcion_j2, id_torneo_j2, id_persona_j2
) VALUES (
    '2026-04-10 09:00:00', 1, 'GRUPOS', 1, 5,
    '2026-04-01', 1, 1,
    '2026-04-01', 1, 2
);

-- Carga del acta deportiva (Sets disputados para el partido 1)
INSERT INTO public.set_partido (nro_set, puntos_j1, puntos_j2, id_partido) VALUES
(1, 15, 12, 1),
(2, 11, 15, 1),
(3, 11, 8,  1);
