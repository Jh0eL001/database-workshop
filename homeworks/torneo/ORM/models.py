from datetime import date, time, datetime
from typing import Optional, List
from sqlalchemy import Integer, String, Boolean, Date, Time, DateTime, Text, ForeignKey # type: ignore
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship # type: ignore

# 1. Base declarativa central de SQLAlchemy
class Base(DeclarativeBase):
    pass


# 1. MÓDULO DE IDENTIDAD Y SESIÓN (Maestro - Detalle)

class Usuario(Base):
    __tablename__ = "usuario"

    id_user: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nombre: Mapped[str] = mapped_column(String(50), nullable=False)
    contrasenia: Mapped[str] = mapped_column(String(100), nullable=False)
    activo: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)

    # Relaciones hacia sesiones y asignaciones de roles
    sesiones: Mapped[List["Sesion"]] = relationship(
        back_populates="usuario", cascade="all, delete-orphan"
    )
    roles_asignados: Mapped[List["UserRol"]] = relationship(
        back_populates="usuario", cascade="all, delete-orphan"
    )


class Sesion(Base):
    __tablename__ = "sesion"

    # Clave primaria compuesta (id_user + nro_sesion)
    id_user: Mapped[int] = mapped_column(
        Integer, ForeignKey("usuario.id_user", ondelete="CASCADE"), primary_key=True
    )
    nro_sesion: Mapped[int] = mapped_column(Integer, primary_key=True)
    pid_postgres: Mapped[int] = mapped_column(Integer, nullable=False)
    fecha: Mapped[date] = mapped_column(Date, nullable=False)
    hora: Mapped[time] = mapped_column(Time, nullable=False)
    activo: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)

    usuario: Mapped["Usuario"] = relationship(back_populates="sesiones")


# 2. MÓDULO RBAC: CATÁLOGOS BASE (Rol, Función, IU)

class Rol(Base):
    __tablename__ = "rol"

    id_rol: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nombre_rol: Mapped[str] = mapped_column(String(50), nullable=False)
    descripcion: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)

    usuarios_asignados: Mapped[List["UserRol"]] = relationship(
        back_populates="rol", cascade="all, delete-orphan"
    )
    funciones_asignadas: Mapped[List["RolFuncion"]] = relationship(
        back_populates="rol", cascade="all, delete-orphan"
    )


class Funcion(Base):
    __tablename__ = "funcion"

    id_funcion: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nombre_funcion: Mapped[str] = mapped_column(String(50), nullable=False)

    roles_asignados: Mapped[List["RolFuncion"]] = relationship(
        back_populates="funcion", cascade="all, delete-orphan"
    )
    interfaces_asignadas: Mapped[List["FuncionIu"]] = relationship(
        back_populates="funcion", cascade="all, delete-orphan"
    )


class Iu(Base):
    __tablename__ = "iu"

    id_iu: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nombre_form: Mapped[str] = mapped_column(String(50), nullable=False)

    funciones_asignadas: Mapped[List["FuncionIu"]] = relationship(
        back_populates="iu", cascade="all, delete-orphan"
    )


# 3. MÓDULO RBAC: TABLAS DE ASOCIACIÓN

class UserRol(Base):
    __tablename__ = "user_rol"

    # Clave primaria compuesta (desde + id_user + id_rol)
    desde: Mapped[date] = mapped_column(Date, primary_key=True)
    id_user: Mapped[int] = mapped_column(
        Integer, ForeignKey("usuario.id_user", ondelete="CASCADE"), primary_key=True
    )
    id_rol: Mapped[int] = mapped_column(
        Integer, ForeignKey("rol.id_rol", ondelete="CASCADE"), primary_key=True
    )
    hasta: Mapped[Optional[date]] = mapped_column(Date, nullable=True)

    usuario: Mapped["Usuario"] = relationship(back_populates="roles_asignados")
    rol: Mapped["Rol"] = relationship(back_populates="usuarios_asignados")


class RolFuncion(Base):
    __tablename__ = "rol_funcion"

    # Clave primaria compuesta (id_rol + id_funcion)
    id_rol: Mapped[int] = mapped_column(
        Integer, ForeignKey("rol.id_rol", ondelete="CASCADE"), primary_key=True
    )
    id_funcion: Mapped[int] = mapped_column(
        Integer, ForeignKey("funcion.id_funcion", ondelete="CASCADE"), primary_key=True
    )

    rol: Mapped["Rol"] = relationship(back_populates="funciones_asignadas")
    funcion: Mapped["Funcion"] = relationship(back_populates="roles_asignados")


class FuncionIu(Base):
    __tablename__ = "funcion_iu"

    # Clave primaria compuesta (id_funcion + id_iu)
    id_funcion: Mapped[int] = mapped_column(
        Integer, ForeignKey("funcion.id_funcion", ondelete="CASCADE"), primary_key=True
    )
    id_iu: Mapped[int] = mapped_column(
        Integer, ForeignKey("iu.id_iu", ondelete="CASCADE"), primary_key=True
    )

    funcion: Mapped["Funcion"] = relationship(back_populates="interfaces_asignadas")
    iu: Mapped["Iu"] = relationship(back_populates="funciones_asignadas")


# 4. LOG

class Log(Base):
    __tablename__ = "log"

    id_log: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    fecha_hora: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    nombre_tabla: Mapped[str] = mapped_column(String(40), nullable=False)
    operacion: Mapped[str] = mapped_column(String(30), nullable=False)
    usuario: Mapped[str] = mapped_column(String(50), nullable=False)
    pid_postgres: Mapped[int] = mapped_column(Integer, nullable=False)
    datos_old: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    datos_new: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
