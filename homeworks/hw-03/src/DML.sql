-- 1. Insertar ejercicios base (nivel inicial)
INSERT INTO ejercicio (nombre, grupo_muscular, id_ejercicio_base) VALUES
('Flexión en pared', 'Pecho', NULL),
('Sentadilla con peso corporal', 'Piernas', NULL);

-- 2. Insertar ejercicios avanzados (dependen del id anterior)
INSERT INTO ejercicio (nombre, grupo_muscular, id_ejercicio_base) VALUES
('Flexión tradicional', 'Pecho', 1),          -- Depende de 'Flexión en pared' (ID 1)
('Sentadilla con barra (Back Squat)', 'Piernas', 2); -- Depende de 'Sentadilla' (ID 2)
