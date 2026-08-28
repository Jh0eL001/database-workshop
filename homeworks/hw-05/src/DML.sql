-- Consultar Clientes
SELECT
    u.id_usuario,
    u.correo,
    u.fecha_registro,
    c.limite_credito,
    c.nivel_riesgo
FROM public."USUARIO" u, public."CLIENTE" c
WHERE u.id_usuario = c."id_usuario_USUARIO";

-- Consultar Administradores
SELECT
    u.id_usuario,
    u.correo,
    u.fecha_registro,
    a.nivel_acceso,
    a.extension_telefonica
FROM public."USUARIO" u, public."ADMINISTRADOR" a
WHERE u.id_usuario = a."id_usuario_USUARIO";
