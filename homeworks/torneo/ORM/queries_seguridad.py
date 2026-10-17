from datetime import date, datetime
from sqlalchemy import create_engine, select, func #type: ignore
from sqlalchemy.orm import Session # type: ignore
from models import Usuario, Sesion, UserRol, RolFuncion, FuncionIu, Iu, Log

# Conexión local a PostgreSQL en WSL
DATABASE_URL = "postgresql+psycopg2://sharkdev:IwillrememberthisoneIpromise@localhost:5432/torneo_racquetbol"
engine = create_engine(DATABASE_URL, echo=False)


def query_1_login(session: Session, nombre_usuario: str, password_usuario: str):
    print("\n--- 1. AUTENTICACIÓN DE CREDENCIALES - LOGIN ---")
    stmt = (
        select(Usuario)
        .where(
            Usuario.nombre == nombre_usuario,
            Usuario.contrasenia == password_usuario,
            Usuario.activo == True
        )
    )
    usuario = session.scalars(stmt).first()
    if usuario:
        print(f"[OK] Login exitoso: Usuario '{usuario.nombre}' (ID: {usuario.id_user})")
        return usuario
    else:
        print(" [X] Credenciales inválidas o cuenta inactiva.")
        return None


def query_2_formularios_usuario(session: Session, id_usuario: int):
    print(f"\n--- 2. FORMULARIOS AUTORIZADOS PARA ID_USER = {id_usuario} ---")

    # Cadena con subconsultas IN
    sub_roles = (
        select(UserRol.id_rol)
        .where(UserRol.id_user == id_usuario)
        .scalar_subquery()
    )
    sub_funciones = (
        select(RolFuncion.id_funcion)
        .where(RolFuncion.id_rol.in_(sub_roles))
        .scalar_subquery()
    )
    sub_ius = (
        select(FuncionIu.id_iu)
        .where(FuncionIu.id_funcion.in_(sub_funciones))
        .scalar_subquery()
    )
    stmt = (
        select(Iu.nombre_form)
        .where(Iu.id_iu.in_(sub_ius))
    )

    formularios = session.scalars(stmt).all()
    if formularios:
        print(f" Formularios disponibles ({len(formularios)}):")
        for f in formularios:
            print(f"  -> {f}")
    else:
        print(" No tiene formularios asignados o roles vigentes.")


def query_3_registrar_sesion(session: Session, id_usuario: int):
    print(f"\n--- 3. REGISTRO DE SESIÓN (MAESTRO-DETALLE + PID) ---")

    # 1. Capturar el PID de PostgreSQL de la conexión activa
    pid_actual = session.scalar(select(func.pg_backend_pid()))

    # 2. Calcular el siguiente nro_sesion del usuario
    sub_max = (
        select(func.coalesce(func.max(Sesion.nro_sesion), 0) + 1)
        .where(Sesion.id_user == id_usuario)
    )
    siguiente_nro = session.scalar(sub_max)

    # 3. Instanciar e insertar la sesión
    nueva_sesion = Sesion(
        id_user=id_usuario,
        nro_sesion=siguiente_nro,
        pid_postgres=pid_actual,
        fecha=date.today(),
        hora=datetime.now().time(),
        activo=True
    )
    session.add(nueva_sesion)
    session.commit()
    print(f" [OK] Sesión #{siguiente_nro} abierta para Usuario {id_usuario} con PID de Postgres: {pid_actual}")


def query_4_recuperar_o_actualizar_password(session: Session, nombre_usuario: str, nueva_pass: str):
    print(f"\n--- 4. RECUPERACIÓN / CAMBIO DE CONTRASEÑA ---")
    usuario = session.scalars(
        select(Usuario).where(Usuario.nombre == nombre_usuario)
    ).first()

    if usuario:
        usuario.contrasenia = nueva_pass
        session.commit()
        print(f" [OK] Contraseña actualizada exitosamente para '{usuario.nombre}'.")
    else:
        print(f" [X] El usuario '{nombre_usuario}' no existe.")


def query_5_auditoria_logs(session: Session, limite: int = 3):
    print(f"\n--- 5. ÚLTIMOS MOVIMIENTOS EN LOG ---")
    stmt = (
        select(Log)
        .order_by(Log.fecha_hora.desc())
        .limit(limite)
    )
    logs = session.scalars(stmt).all()
    for l in logs:
        print(f"  - Log #{l.id_log} | Tabla: {l.nombre_tabla} | Op: {l.operacion} | Usuario: {l.usuario} | PID: {l.pid_postgres}")


# ============================================================================
# EJECUCIÓN PRINCIPAL DE PRUEBA
# ============================================================================
if __name__ == "__main__":
    print("=" * 65)
    print(" EJECUCIÓN DE QUERIES CON SQLALCHEMY ")
    print("=" * 65)

    with Session(engine) as session:
        # 1. Probar login con un usuario existente
        user = query_1_login(session, "cmendoza", "nueva_clave_2026")

        # Si el usuario existe, probamos consultar sus formularios y abrirle sesión
        if user:
            query_2_formularios_usuario(session, user.id_user)
            query_3_registrar_sesion(session, user.id_user)

        # 4. Probar recuperación / actualización de contraseña
        query_4_recuperar_o_actualizar_password(session, "cmendoza", "cmendoza123")

        # 5. Consultar los logs generados por la base de datos
        query_5_auditoria_logs(session, limite=3)

    print("\n" + "=" * 65 + "\n")
