SELECT 
    u.id_usuario, 
    u.correo, 
    u.fecha_registro, 
    c.limite_credito, 
    c.nivel_riesgo
FROM public."USUARIO" u, public."CLIENTE" c
WHERE u.id_usuario = c."id:_usuario_USUARIO";
