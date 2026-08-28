-- Creación de la tabla con Idiom Reflexivo (Simple)
CREATE TABLE ejercicio (
    id_ejercicio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    grupo_muscular VARCHAR(50) NOT NULL,
    -- Clave foránea reflexiva (apunta a la misma tabla)
    id_ejercicio_base INT REFERENCES ejercicio(id_ejercicio)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
