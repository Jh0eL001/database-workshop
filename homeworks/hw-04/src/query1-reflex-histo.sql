SELECT
    e1.nombre AS ejercicio_original,
    e2.nombre AS ejercicio_reemplazo,
    h.fecha_inicio,
    h.fecha_fin,
    h.motivo
FROM ejercicio e1, ejercicio e2, historial_sustitucion_ejercicio h
WHERE h.id_ejercicio_original = e1.id_ejercicio
  AND h.id_ejercicio_reemplazo = e2.id_ejercicio;
