SELECT
    e1.nombre AS ejercicio_avanzado,
    e2.nombre AS ejercicio_base,
    e1.id_ejercicio_base AS id
FROM ejercicio e1, ejercicio e2
WHERE e1.id_ejercicio_base = e2.id_ejercicio;
