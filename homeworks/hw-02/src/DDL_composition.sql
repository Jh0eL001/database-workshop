INSERT INTO public.paciente (nombre, telefono) VALUES
('Carlos Mendoza', '70711223'),
('Mariana Rios',   '79733445'),
('Andrea Vargas',  '71755667');

INSERT INTO public.doctor (nombre, especialidad) VALUES
('Dr. Ramiro Arce',     'Cardiologia'),
('Dra. Elena Torrico',  'Pediatria'),
('Dr. Gonzalo Suarez',  'Traumatologia');

INSERT INTO public.consulta (id_paciente_PACIENTE, id_doctor_DOCTOR, fecha, costo) VALUES
(1, 1, '2026-08-10', 150.00),
(1, 1, '2026-08-22', 120.00),
(1, 3, '2026-08-15', 180.00),
(2, 2, '2026-08-18', 100.00),
(3, 1, '2026-08-12', 200.00),
(3, 2, '2026-08-20', 80.00);

