from sqlalchemy import create_engine, select, Integer, String, Boolean
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, Session

DATABASE_URL = "postgresql+psycopg2://sharkdev:IwillrememberthisoneIpromise@localhost:5432/torneo_racquetbol"
engine = create_engine(DATABASE_URL, echo=True)

class Base(DeclarativeBase):
    pass

# 1. Agregamos el mapeo de la columna contrasenia
class Usuario(Base):
    __tablename__ = "usuario"

    id_user: Mapped[int] = mapped_column(Integer, primary_key=True)
    nombre: Mapped[str] = mapped_column(String(50))
    contrasenia: Mapped[str] = mapped_column(String(255))
    activo: Mapped[bool] = mapped_column(Boolean)

print("\n>>> PROBANDO INSERCIÓN Y COMMIT CON EL ORM <<<\n")

with Session(engine) as session:
    # 2. Le pasamos una contraseña para cumplir con el NOT NULL
    nuevo_usuario = Usuario(
        nombre="usuario_orm_test",
        contrasenia="password_seguro_123",
        activo=True
    )

    session.add(nuevo_usuario)
    session.commit()
    print(f"\n[OK] Usuario creado con ID asignado automáticamente: {nuevo_usuario.id_user}\n")

with Session(engine) as session:
    # 3. Consulta y actualización (UPDATE)
    usuario_a_modificar = session.scalars(
        select(Usuario).where(Usuario.nombre == "usuario_orm_test")
    ).first()

    if usuario_a_modificar:
        usuario_a_modificar.nombre = "usuario_orm_actualizado"
        session.commit()
        print("\n[OK] Usuario actualizado con éxito en PostgreSQL.\n")
