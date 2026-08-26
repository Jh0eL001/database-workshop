-- 1. Insertar los libros
INSERT INTO public.libro (titulo, autor) VALUES
('Deep Work', 'Cal Newport'),                                  -- id_libro: 1
('Clean Code', 'Robert C. Martin'),                             -- id_libro: 2
('Automate the Boring Stuff with Python', 'Al Sweigart'),       -- id_libro: 3
('El Quijote', 'Miguel de Cervantes');                          -- id_libro: 4

-- 2. Insertar los capítulos (Tabla Detalle - Clave compuesta)
INSERT INTO public.capitulo (id_libro, nro_capitulo, titulo, paginas) VALUES
-- Capítulos de Deep Work (id_libro = 1)
(1, 1, 'Deep Work is Valuable', 35),
(1, 2, 'Deep Work is Rare', 28),
(1, 3, 'Deep Work is Meaningful', 30),
(1, 4, 'Rule #1: Work Deeply', 45),

-- Capítulos de Clean Code id_libro = 2
(2, 1, 'Clean Code', 14),
(2, 2, 'Meaningful Names', 22),
(2, 3, 'Functions', 38),

-- Capítulos de Automate the Boring Stuff id_libro = 3
(3, 1, 'Python Basics', 25),
(3, 2, 'Flow Control', 32),
(3, 3, 'Functions', 28);

