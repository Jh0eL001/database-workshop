-- Insertar ejercicios
INSERT INTO ejercicio (nombre, grupo_muscular) VALUES 
('Sentadilla libre', 'Piernas'),
('Prensa de pierna', 'Piernas'),
('Zancadas con mancuerna', 'Piernas');

-- Insertar el historial de sustitución (ej: se cambió la sentadilla libre por prensa debido a lesión)
INSERT INTO historial_sustitucion_ejercicio (id_ejercicio_original, id_ejercicio_reemplazo, fecha_inicio, fecha_fin, motivo) VALUES 
(1, 2, '2025-01-10', '2025-03-10', 'Lesión leve de rodilla - Cambio temporal'),
(2, 3, '2025-03-11', NULL, 'Modificación definitiva de rutina');
