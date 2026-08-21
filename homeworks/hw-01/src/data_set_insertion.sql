-- 1. Insertamos en la tabla clasificadora
INSERT INTO public.raza (nombre) VALUES
('Pastor Aleman'), --1
('Golden'), --2
('Rottweiler'), --3
('Husky'), --4
('mestizo'), --5
('Salchicha'); --6

-- 2. Insertamos en la tabla clasificada
INSERT INTO public.perro (nombre, id_raza_raza) VALUES
('Darla', 3),
('Kira', 1),
('Sami', 5),
('Balto', 5),
('Luna', 2),
('Tarzan', 4),
('Mila', 5),
('Otto', 6),
('Bruno', 6),
('Rocky', 1),
('Thor', 3),
('Bobby', 5),
('Nieve', 4),
('Simba', 2),
('Choco', 5);
