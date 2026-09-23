-- Asignar roles a los usuarios existentes
INSERT INTO public.user_rol (id_user, id_rol, desde, hasta) VALUES
-- 1. admin_torneo -> Administrador (ID 1)
((SELECT id_user FROM public.usuario WHERE nombre = 'admin_torneo'), 1, '2026-01-01', '2026-12-31'),

-- 2. lgomez -> Árbitro (ID 2)
((SELECT id_user FROM public.usuario WHERE nombre = 'lgomez'), 2, '2026-01-01', '2026-12-31'),

-- 3. cmoscoso -> Jugador (ID 3)
((SELECT id_user FROM public.usuario WHERE nombre = 'cmoscoso'), 3, '2026-01-01', '2026-12-31'),

-- 4. cmendoza -> Doble Rol (Árbitro + Jugador)
((SELECT id_user FROM public.usuario WHERE nombre = 'cmendoza'), 2, '2026-01-01', '2026-12-31'),
((SELECT id_user FROM public.usuario WHERE nombre = 'cmendoza'), 3, '2026-01-01', '2026-12-31'),

-- 5. jquispe -> Jugador (ID 3, usuario inactivo)
((SELECT id_user FROM public.usuario WHERE nombre = 'jquispe'), 3, '2026-01-01', '2026-12-31')
ON CONFLICT DO NOTHING;
