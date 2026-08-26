-- 1. Tabla principal de ejercicios
CREATE TABLE ejercicio (
    id_ejercicio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    grupo_muscular VARCHAR(50) NOT NULL
);

-- 2. Tabla intermedia con historia (contiene las dos claves foráneas que apuntan a la misma tabla)
CREATE TABLE historial_sustitucion_ejercicio (
    id_historial SERIAL PRIMARY KEY,
    id_ejercicio_original INT NOT NULL REFERENCES ejercicio(id_ejercicio),
    id_ejercicio_reemplazo INT NOT NULL REFERENCES ejercicio(id_ejercicio),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    motivo VARCHAR(150),

    -- Restricción para evitar que un ejercicio se reemplace a sí mismo
    CONSTRAINT chk_diferentes_ejercicios CHECK (id_ejercicio_original <> id_ejercicio_reemplazo)
);
