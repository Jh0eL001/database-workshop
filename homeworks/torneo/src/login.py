import tkinter as tk
from tkinter import messagebox
import psycopg2

def autenticar():
    usuario_ingresado = entry_user.get().strip()
    clave_ingresada = entry_pass.get().strip()

    if not usuario_ingresado or not clave_ingresada:
        messagebox.showwarning("ATENCION", "Ingresa el Usuario y la contraseña!")
        return

    try:
        # 1. Conexion al motor usando el user BD
        conexion = psycopg2.connect(
            host="localhost",
            database="torneo_racquetbol",
            user="sharkdev",
            password="IwillrememberthisoneIpromise"
        )
        cursor = conexion.cursor()

        # 2. OBTENER EL PID asignado por PostgreSQL a la conexion
        cursor.execute("SELECT pg_backend_pid();")
        pid_actual = cursor.fetchone()[0]

        # 3. Validar credenciales contra la tabla de usuario
        consulta = """
            SELECT id_user, activo
            FROM public.usuario
            WHERE nombre = %s AND contrasenia = %s;
        """
        cursor.execute(consulta, (usuario_ingresado, clave_ingresada))
        resultado = cursor.fetchone()

        if resultado:
            id_user, activo = resultado
            if not activo:
                cursor.close()
                conexion.close()
                messagebox.showerror("BLOQUEADO", "El usuario existe pero esta inactivo.")
                return

            # 4. Registrar la sesion en la DB
            query_sesion = """
                INSERT INTO public.sesion (id_user, nro_sesion, pid_postgres, activo)
                VALUES (
                    %s,
                    COALESCE((SELECT MAX(nro_sesion) + 1 FROM public.sesion WHERE id_user = %s), 1),
                    %s,
                    true
                );
            """
            cursor.execute(query_sesion, (id_user, id_user, pid_actual))
            conexion.commit()

            # 5. Mostrar el process ID en el Login
            lbl_pid.config(text=f"Acceso Exitoso!\nUsuario: {usuario_ingresado}\nPostgreSQL PID: {pid_actual}", fg="green")

            # 6. Consultar permisos en la BD (Sintaxis clasica con WHERE)
            query_permisos = """
                SELECT r.nombre_rol, f.nombre_funcion, iu.nombre_form
                FROM public.user_rol ur,
                     public.rol r,
                     public.rol_funcion rf,
                     public.funcion f,
                     public.funcion_iu fi,
                     public.iu iu
                WHERE ur.id_rol = r.id_rol
                  AND r.id_rol = rf.id_rol
                  AND rf.id_funcion = f.id_funcion
                  AND f.id_funcion = fi.id_funcion
                  AND fi.id_iu = iu.id_iu
                  AND ur.id_user = %s;
            """
            cursor.execute(query_permisos, (id_user,))
            permisos = cursor.fetchall()

            # 7. Abrir la pantallita secundaria
            pantalla2 = tk.Toplevel()
            pantalla2.title("Permisos del Usuario")
            pantalla2.geometry("300x320")

            tk.Label(pantalla2, text=f"Usuario: {usuario_ingresado} (PID: {pid_actual})", font=("Arial", 10, "bold")).pack(pady=10)

            # Bucle dinamico: se dibuja un boton por cada fila que devolvio Postgres
            for fila in permisos:
                rol = fila[0]
                funcion = fila[1]
                form = fila[2]
                tk.Button(pantalla2, text=f"{form} - ({funcion})").pack(pady=5)

        else:
            messagebox.showerror("Error", "Credenciales Incorrectas.")

        cursor.close()
        conexion.close()

    except Exception as e:
        messagebox.showerror("Error de Conexion", str(e))

# Configuracion de la ventana principal
ventana = tk.Tk()
ventana.title("LOGIN Y PID")
ventana.geometry("340x350")
ventana.resizable(False, False)

# Formulario
tk.Label(ventana, text="Iniciar Sesion", font=("Arial", 16, "bold")).pack(pady=15)

tk.Label(ventana, text="Usuario:").pack()
entry_user = tk.Entry(ventana, width=25)
entry_user.pack(pady=6)

tk.Label(ventana, text="Contraseña:").pack()
entry_pass = tk.Entry(ventana, width=25, show="*")
entry_pass.pack(pady=5)

tk.Button(ventana, text="Conectar y Obtener PID", command=autenticar, bg="#0d6efd", fg="white", padx=5, pady=5).pack(pady=15)

# Etiqueta para mostrar el PID del backend
lbl_pid = tk.Label(ventana, text="PostgreSQL PID: ---", font=("Arial", 11, "bold"), fg="#555")
lbl_pid.pack(pady=10)

ventana.mainloop()
