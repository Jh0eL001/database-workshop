from sqlalchemy import create_engine, select
from sqlalchemy.orm import Session
from models import Usuario, Sesion, Rol, UserRol, Funcion, RolFuncion, Iu, FuncionIu, Log

DATABASE_URL = "postgresql+psycopg2://sharkdev:IwillrememberthisoneIpromise@localhost:5432/torneo_racquetbol"
engine = create_engine(DATABASE_URL)

modelos = [
    ("Usuario", Usuario),
    ("Sesion", Sesion),
    ("Rol", Rol),
    ("UserRol", UserRol),
    ("Funcion", Funcion),
    ("RolFuncion", RolFuncion),
    ("Iu", Iu),
    ("FuncionIu", FuncionIu),
    ("Log", Log),
]

print("\n" + "=" * 60)
print(" VERIFICANDO EL MAPEO DE LAS 9 TABLAS DE SEGURIDAD")
print("=" * 60)

with Session(engine) as session:
    for nombre, modelo in modelos:
        try:
            total = len(session.scalars(select(modelo).limit(5)).all())
            print(f" [OK] {nombre:<15} -> Mapeado correctamente (Registros leídos: {total})")
        except Exception as e:
            print(f" [X]  {nombre:<15} -> Error de mapeo: {e}")

print("=" * 60 + "\n")
