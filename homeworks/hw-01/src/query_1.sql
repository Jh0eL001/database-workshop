SELECT perro.nombre, raza,nombre
FROM public.perro
INNER JOIN public.raza
ON perro.id_raza_raza = raza.id_raza;
